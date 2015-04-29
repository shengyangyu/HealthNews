//
//  SPTableView.m
//  HealthNews
//
//  Created by yushengyang on 15/4/27.
//  Copyright (c) 2015年 yushengyang. All rights reserved.
//

#import "SPTableView.h"

@implementation SPTableView

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    if ([self.touchDelegate conformsToProtocol:@protocol(CustomerTableViewDelegate)] &&
        [self.touchDelegate respondsToSelector:@selector(tableViewHeaderRereshing: withCompletioned:)]) {
        
        [self.touchDelegate tableViewHeaderRereshing:self withCompletioned:^() {
            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            [self.header endRefreshing];
        }];
    }
    else {
        //下拉刷新
        m_indexNum = 1;
        m_totalCount = 0;
        [self requestNews];//请求机票订单列表数据
    }
}

- (void)footerRereshing
{
    if ([self.touchDelegate conformsToProtocol:@protocol(CustomerTableViewDelegate)] &&
        [self.touchDelegate respondsToSelector:@selector(tableViewFooterRereshing: withCompletioned:)]) {
        
        [self.touchDelegate tableViewFooterRereshing:self withCompletioned:^() {
            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            [self.footer endRefreshing];
        }];
    }
    else {
        //上拉加载更多
        [self requestNews];
    }
}

#pragma mark -请求
- (void)requestNews {
    @try {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:
                                       @{@"page":[NSString stringWithFormat:@"%@",@(m_indexNum)],
                                         @"limit":@"20",
                                         @"type":@"id",
                                         @"id":self.m_type}];
        apiNewsList = [[AFInterfaceAPIExcute alloc] initWithAPI:API_NewsList retClass:@"HNNewsList" Params:params setDelegate:self] ;
        [apiNewsList beginRequest];
        
    }
    @catch (NSException *exception) {
        //[self HUDShow:@"请求资讯列表错误" delay:kShowTitleAfterDelay];
    }
    
}

-(void) interfaceExcuteSuccess:(id)retObj apiName:(NSString*)ApiName apiFlag:(NSString*) ApiFlag {
    
    // 资讯列表
    if ([ApiName isEqualToString:API_NewsList]) {
        HNNewsList *mClass = (HNNewsList *)retObj;
        if (m_indexNum == 1) {
            self.mInfoArray = nil;
            self.mInfoArray = [[NSMutableArray alloc] init];
            self.m_heads = nil;
            self.m_heads = [[NSMutableArray alloc] init];
            // 分割数组
            if ([mClass.yi18 count] > 4) {
                for(NSInteger i = 0; i < 4; i ++) {
                    [self.m_heads addObject:mClass.yi18[i]];
                }
                for (NSInteger i = 4; i < [mClass.yi18 count]; i ++) {
                    [self.mInfoArray addObject:mClass.yi18[i]];
                }
            }else {
                [self.m_heads addObject:mClass.yi18];
            }
        }else {
            [self.mInfoArray addObjectsFromArray:mClass.yi18];
        }
        m_indexNum ++;
        //改变header显示图片
        [self changeHeaderContentWithCustomTable];
        [self reloadData:([mClass.total integerValue] == ([self.mInfoArray count]+[self.m_heads count]))];
    }
}


#pragma mark 改变TableView上面滚动栏的内容
-(void)changeHeaderContentWithCustomTable {
    NSInteger length = 4;
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSInteger i = 0 ; i < length; i++) {
        HNNewsDetail *mclass = (HNNewsDetail *)self.m_heads[i];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              mclass.title,@"title" ,
                              [NSString stringWithFormat:@"%@/%@",kImageUrl,mclass.img],@"image",
                              mclass.mId,@"type",
                              nil];
        [tempArray addObject:dict];
    }
    
    NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:length+2];
    //添加最后一张图 用于循环
    if (length > 1) {
        NSDictionary *dict = [tempArray objectAtIndex:length-1];
        SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:dict tag:@"-1"];
        [itemArray addObject:item];
    }
    for (int i = 0; i < length; i++) {
        NSDictionary *dict = [tempArray objectAtIndex:i];
        SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:dict tag:dict[@"type"]];
        [itemArray addObject:item];
        
    }
    //添加第一张图 用于循环
    if (length > 1) {
        NSDictionary *dict = [tempArray objectAtIndex:0];
        SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:dict tag:@"-1"];
        [itemArray addObject:item];
    }
    
    SGFocusImageFrame *vFocusFrame = (SGFocusImageFrame *)self.tableHeaderView;
    [vFocusFrame changeImageViewsContent:itemArray];
}


@end
