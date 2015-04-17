//
//  BaseTableViewController.h
//  HealthNews
//
//  Created by yushengyang on 15/4/17.
//  Copyright (c) 2015年 yushengyang. All rights reserved.
//

#import "BaseViewController.h"
#import "RefreshTableView.h"
#import "ULETablePage.h"

@interface BaseTableViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,CustomerTableViewDelegate>
{
    RefreshTableView  *m_tableView;
    NSInteger               m_indexNum;           //当前下标
    NSInteger               m_totalCount;        //总数
    NSMutableDictionary     *m_params;
    NSString                *m_APIUrl;
    NSString                *m_RetStruct;
    NSString                *m_ListKey;
    NSMutableArray          *m_muArray;
    ULETablePage *stuPage;
}

/**
 * 初始化
 */
- (void)addTableView:(CGRect)rect
           withStyle:(UITableViewStyle)style
            withType:(ULETableViewType)type
              parent:(UIView*)parentView;

- (RefreshTableView *)fenleiTableView;

//分页设置
-(void) setIndexNum:(int) listCount
         totalCount:(int) totalCount;

//还原第一页时候的数据
-(void) setReduction;

@end
