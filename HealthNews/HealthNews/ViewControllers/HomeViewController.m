//
//  HomeViewController.m
//  HealthNews
//
//  Created by yushengyang on 15/4/17.
//  Copyright (c) 2015年 yushengyang. All rights reserved.
//

#import "HomeViewController.h"
#import "DetailNewsViewController.h"
#import "MenuHrizontal.h"
#import "ScrollPageView.h"

@interface HomeViewController ()<MenuHrizontalDelegate,ScrollPageViewDelegate>
{
    AFInterfaceAPIExcute *apiType;//资讯分类列表
    MenuHrizontal *mMenuHriZontal;//顶部滚动条
    ScrollPageView *mScrollPageView;//滚动view
}

@property (nonatomic, strong) NSMutableArray *mTypeArray;

@end

@implementation HomeViewController
@synthesize mTypeArray;

- (void)viewDidLoad {
    self.isHideLeftItem = YES;
    self.isShowTabbar = YES;
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self titleLabel:@"健康资讯"];
    [self HUDShow:@"加载中"];
    [self requestType];
}

#pragma mark -Data
- (void)setData
{
    m_indexNum = 1;
    m_totalCount = 0;
    m_muArray = nil;
    m_muArray = [[NSMutableArray alloc] init];
}

#pragma mark -UI
- (void)hideEmptySeparators
{
    UIView *view = [[UIView  alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor clearColor];
    [m_tableView setTableFooterView:view];
}

#pragma mark - request
- (void)requestType {
    apiType = [[AFInterfaceAPIExcute alloc] initWithAPI:API_NewsTypeList retClass:@"HNNewsTypeList" Params:nil setDelegate:self] ;
    [apiType beginRequest];
}



#pragma mark - AFInterfaceAPIDelegate
-(void) interfaceExcuteSuccess:(id)retObj apiName:(NSString*)ApiName apiFlag:(NSString*) ApiFlag
{
    [self HUDHidden];
    // 分类列表
    if ([ApiName isEqualToString:API_NewsTypeList]) {
        HNNewsTypeList *mClass = (HNNewsTypeList *)retObj;
        if ([mClass.success boolValue] && [mClass.yi18 count] != 0) {
            mTypeArray = nil;
            mTypeArray = [[NSMutableArray alloc] init];
            [mTypeArray addObjectsFromArray:mClass.yi18];
            @try {
                NSMutableArray *vBtnItems = [[NSMutableArray alloc] init];
                NSMutableArray *vBtnTypes = [[NSMutableArray alloc] init];
                for (NSInteger i = 0; i < [mTypeArray count]; i ++) {
                    HNNewsType *tmp = (HNNewsType *)mTypeArray[i];
                    [vBtnItems addObject:@{NOMALKEY: @"normal",
                                           HEIGHTKEY:@"helight",
                                           TITLEKEY:tmp.name,
                                           TYPEKEY:tmp.mId,
                                           TITLEWIDTH:[NSNumber numberWithFloat:60]}];
                    [vBtnTypes addObject:tmp.mId];
                }
                if ([vBtnItems count] != 0) {
                    if (mMenuHriZontal == nil) {
                        mMenuHriZontal = [[MenuHrizontal alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, MENUHEIHT) ButtonItems:vBtnItems];
                        mMenuHriZontal.delegate = self;
                        //初始化滑动列表
                        if (mScrollPageView == nil) {
                            mScrollPageView = [[ScrollPageView alloc] initWithFrame:CGRectMake(0, MENUHEIHT, __MainScreen_Width, __viewContent_hight3 - MENUHEIHT)];
                            mScrollPageView.delegate = self;
                            mScrollPageView.typeArray = vBtnTypes;
                            mScrollPageView.supVC = self;
                        }
                        [mScrollPageView setContentOfTables:vBtnItems.count];
                        //默认选中第一个button
                        [mMenuHriZontal clickButtonAtIndex:0];
                        //-------
                        [self.view addSubview:mScrollPageView];
                        [self.view addSubview:mMenuHriZontal];
                    }
                }
            }
            @catch (NSException *exception) {
                
            }
            //[self setData];
        }
    }
}

#pragma mark MenuHrizontalDelegate
-(void)didMenuHrizontalClickedButtonAtIndex:(NSInteger)aIndex{
    NSLog(@"第%d个Button点击了",aIndex);
    [mScrollPageView moveScrollowViewAthIndex:aIndex];
}

#pragma mark ScrollPageViewDelegate
-(void)didScrollPageViewChangedPage:(NSInteger)aPage{
    NSLog(@"CurrentPage:%d",aPage);
    [mMenuHriZontal changeButtonStateAtIndex:aPage];
    //刷新当页数据
    [mScrollPageView freshContentTableAtIndex:aPage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
