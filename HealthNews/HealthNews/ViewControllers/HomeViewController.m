//
//  HomeViewController.m
//  HealthNews
//
//  Created by yushengyang on 15/4/17.
//  Copyright (c) 2015年 yushengyang. All rights reserved.
//

#import "HomeViewController.h"
#import "DetailViewController.h"
#import "HomeCell.h"
#import "MenuHrizontal.h"
#import "ScrollPageView.h"

@interface HomeViewController ()<MenuHrizontalDelegate,ScrollPageViewDelegate>
{
    AFInterfaceAPIExcute *apiType;//资讯分类列表
    AFInterfaceAPIExcute *apiNewsList;//资讯列表
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
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self titleLabel:@"健康资讯"];
    //[self initTableView];
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
    [self requestNews];
}

#pragma mark -UI
- (void)hideEmptySeparators
{
    UIView *view = [[UIView  alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor clearColor];
    [m_tableView setTableFooterView:view];
}

-(void)initTableView{
    [self addTableView:CGRectMake(0, 0, __MainScreen_Width, __viewContent_hight3) withStyle:UITableViewStylePlain withType:ULE_TableViewTypeAll parent:self.view];
    [self hideEmptySeparators];
}

#pragma mark - request
- (void)requestType {
    apiType = [[AFInterfaceAPIExcute alloc] initWithAPI:API_NewsTypeList retClass:@"HNNewsTypeList" Params:nil setDelegate:self] ;
    [apiType beginRequest];
}

- (void)requestNews {
    @try {
        HNNewsType *mclass = (HNNewsType *)mTypeArray[0];
        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:
            @{@"page":[NSString stringWithFormat:@"%@",@(m_indexNum)],
                                        @"limit":@"20",
                                        @"type":@"id",
                                        @"id":mclass.mId}];
        apiNewsList = [[AFInterfaceAPIExcute alloc] initWithAPI:API_NewsList retClass:@"HNNewsList" Params:params setDelegate:self] ;
        [apiNewsList beginRequest];

    }
    @catch (NSException *exception) {
        [self HUDShow:@"请求资讯列表错误" delay:kShowTitleAfterDelay];
    }
    
}

#pragma mark - Table view data source
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return HC_Cell_height;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_muArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"HomeCell";
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[HomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    @try {
        HNNewsDetail *mclass = (HNNewsDetail *)m_muArray[indexPath.row];
        [cell.mIconImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",kImageUrl,mclass.img]] placeholderImage:[UIImage imageNamed:@"hc_cell_icon"]];
        cell.mTitleLab.text = mclass.title;
        cell.mTimeLab.text = [NSString changeTimeMethod:mclass.time];
    }
    @catch (NSException *exception) {
        
    }
    
    return cell;
}

+ (NSDate *)methodDateFromString:(NSString *)mString withFormat:(NSString *)mFormat
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [formatter setDateFormat:mFormat];
    return [formatter dateFromString:mString];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    @try {
        HNNewsDetail *mclass = (HNNewsDetail *)m_muArray[indexPath.row];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:mclass.mId forKey:@"id"];
        [self pushNewViewController:@"DetailViewController" isNibPage:NO withData:dic];
    }
    @catch (NSException *exception) {
        [self HUDShow:@"获取详情错误!" delay:kShowTitleAfterDelay];
    }
}

#pragma mark - AFInterfaceAPIDelegate
-(void) interfaceExcuteSuccess:(id)retObj apiName:(NSString*)ApiName
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
                for (NSInteger i = 0; i < [mTypeArray count]; i ++) {
                    HNNewsType *tmp = (HNNewsType *)mTypeArray[i];
                    [vBtnItems addObject:@{NOMALKEY: @"normal",
                                           HEIGHTKEY:@"helight",
                                           TITLEKEY:tmp.name,
                                           TYPEKEY:tmp.mId,
                                           TITLEWIDTH:[NSNumber numberWithFloat:60]}];
                }
                if ([vBtnItems count] != 0) {
                    if (mMenuHriZontal == nil) {
                        mMenuHriZontal = [[MenuHrizontal alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, MENUHEIHT) ButtonItems:vBtnItems];
                        mMenuHriZontal.delegate = self;
                        //初始化滑动列表
                        if (mScrollPageView == nil) {
                            mScrollPageView = [[ScrollPageView alloc] initWithFrame:CGRectMake(0, MENUHEIHT, __MainScreen_Width, __viewContent_hight3 - MENUHEIHT)];
                            mScrollPageView.delegate = self;
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
    // 资讯列表
    else if ([ApiName isEqualToString:API_NewsList]) {
        HNNewsList *mClass = (HNNewsList *)retObj;
        if (m_indexNum == 1) {
            m_muArray = nil;
            m_muArray = [[NSMutableArray alloc] init];
        }
        m_indexNum ++;
        [m_muArray addObjectsFromArray:mClass.yi18];
        [m_tableView reloadData:([mClass.total integerValue] == [m_muArray count])];
    }
    
}

#pragma mark 开始进入刷新状态

- (void)tableViewHeaderRereshing:(UITableView *)tableView withCompletioned:(void (^)())completioned
{
    //下拉刷新
    m_indexNum = 1;
    m_totalCount = 0;
    [self requestNews];//请求机票订单列表数据
}

- (void)tableViewFooterRereshing:(UITableView *)tableView withCompletioned:(void (^)())completioned
{
    //上拉加载更多
    [self requestNews];
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
