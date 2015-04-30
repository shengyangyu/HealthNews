//
//  ReadViewController.m
//  HealthNews
//
//  Created by yushengyang on 15/4/17.
//  Copyright (c) 2015年 yushengyang. All rights reserved.
//

#import "ReadViewController.h"
#import "DVSwitch.h"
#import "RefreshTableView.h"
#import "HomeCell.h"
#import "DetailReadViewController.h"

@interface ReadViewController ()<UIScrollViewDelegate,CustomerTableViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    AFInterfaceAPIExcute *hotList;//推荐列表
    AFInterfaceAPIExcute *typeList;//资讯分类列表
    AFInterfaceAPIExcute *typeDetailList;//资讯分类列表
    NSInteger m_indexNum;
    // 控制刷新
    dispatch_group_t downloadGroup;
    BOOL canUpdate;
    // 滑动
    BOOL canUseDelegate;
    NSInteger mCurrentPage;
}
//请求数组
@property (strong, nonatomic) NSMutableArray *apiArray;
@property (strong, nonatomic) NSMutableDictionary *apiDic;
// top
@property (nonatomic, strong) DVSwitch *mSwitcher;
// 主ScrollView
@property (nonatomic, strong) UIScrollView *mScrollView;
@property (nonatomic, strong) NSMutableArray *mTypeArray;
// 推荐列表
@property (nonatomic, strong) RefreshTableView *leftTable;
@property (nonatomic, strong) NSMutableArray *leftArray;
// 分类列表
@property (nonatomic, strong) RefreshTableView *rightTable;

@end

@implementation ReadViewController
@synthesize mSwitcher,
mScrollView,
mTypeArray,
leftTable,
leftArray,
rightTable,
apiArray,
apiDic;

- (void)viewDidLoad {
    self.isHideLeftItem = YES;
    self.isShowTabbar = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    // [self titleLabel:@"健康常识"];
    [self setData];
    [self setUI];
}

- (void)setUI {
    // top
    mSwitcher = [[DVSwitch alloc] initWithStringsArray:@[@"推荐", @"分类"]];
    mSwitcher.frame = CGRectMake(0, 0, 195, 30);
    mSwitcher.backgroundColor = [UIColor clearColor];
    mSwitcher.labelTextColorInsideSlider = [UIColor redColor];
    mSwitcher.labelTextColorOutsideSlider = [UIColor grayColor];
    mSwitcher.layer.cornerRadius = mSwitcher.cornerRadius;
    mSwitcher.layer.borderWidth = 0.5f;
    mSwitcher.layer.borderColor = [UIColor whiteColor].CGColor;
    self.navigationItem.titleView = mSwitcher;
    __weak __typeof(self)weakSelf = self;
    [mSwitcher setPressedHandler:^(NSUInteger index) {
        // 刷新
        if (index == 0 && (leftArray == nil || [leftArray count] == 0)) {
            [weakSelf.leftTable.header beginRefreshing];
        }else if (index == 1 && (apiDic == nil || [[apiDic allKeys] count] == 0)) {
            [weakSelf.rightTable.header beginRefreshing];
        }
        // 移动
        if(index != mCurrentPage) {
            [weakSelf moveScrollowViewAthIndex:index];
        }
    }];
    // scrollview
    mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, __viewContent_hight3)];
    mScrollView.pagingEnabled = YES;
    mScrollView.delegate = self;
    [mScrollView setContentSize:CGSizeMake(__MainScreen_Width * 2, __viewContent_hight3)];
    [self.view addSubview:mScrollView];
    // 推荐列表
    leftTable = [[RefreshTableView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, __viewContent_hight3) withStyle:UITableViewStylePlain withType:ULE_TableViewTypeAll];
    // 分割线 偏右 ios7
    if ([leftTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [leftTable setSeparatorInset:UIEdgeInsetsZero];
    }
    leftTable.delegate = self;
    leftTable.dataSource = self;
    leftTable.touchDelegate = self;
    leftTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [mScrollView addSubview:leftTable];
    // 分类列表
    rightTable = [[RefreshTableView alloc] initWithFrame:CGRectMake(__MainScreen_Width, 0, __MainScreen_Width, __viewContent_hight3) withStyle:UITableViewStylePlain withType:ULE_TableViewTypeHeader];
    rightTable.delegate = self;
    rightTable.dataSource = self;
    rightTable.touchDelegate = self;
    rightTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [mScrollView addSubview:rightTable];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (leftArray == nil || [leftArray count] == 0) {
        // 刷新
        [leftTable.header beginRefreshing];
    }
}

- (void)setData {
    apiArray = [[NSMutableArray alloc] init];
    apiDic = [[NSMutableDictionary alloc] init];
}

#pragma mark -推荐列表
- (void)requestHotList {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:
                                   @{@"page":[NSString stringWithFormat:@"%@",@(m_indexNum)],
                                     @"limit":@"20",
                                     @"type":@"id"}];
    hotList = [[AFInterfaceAPIExcute alloc] initWithAPI:API_ReadsList retClass:@"HNReadsList" Params:params setDelegate:self];
    [hotList setFlagCommonApi:@"-1"];
    [hotList beginRequest];

}
- (void)requestTypeList {
    typeList = [[AFInterfaceAPIExcute alloc] initWithAPI:API_ReadsTypeList retClass:@"HNNewsTypeList" Params:nil setDelegate:self] ;
    [typeList beginRequest];
}
- (void)requestTypesList {
    [apiArray removeAllObjects];
    [apiDic removeAllObjects];
    downloadGroup = dispatch_group_create();//创建组
    //并行发出请求 发出的顺序不定 不是按照顺序做的
    dispatch_apply([mTypeArray count], dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(size_t i) {
        HNNewsType *mClass = (HNNewsType *)mTypeArray[i];
        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:
                                       @{@"page":[NSString stringWithFormat:@"%@",@(1)],
                                         @"limit":@"2",
                                         @"type":@"id",
                                         @"id":mClass.mId}];
        AFInterfaceAPIExcute *tmpApi = [[AFInterfaceAPIExcute alloc] initWithAPI:API_ReadsList retClass:@"HNReadsList" Params:params setDelegate:self] ;
        [tmpApi setFlagCommonApi:mClass.mId];
        [tmpApi beginRequest];
        [apiArray addObject:tmpApi];
        dispatch_group_enter(downloadGroup);//进入组
    });
    //等待组中任务完成 自动通知
    dispatch_group_notify(downloadGroup, dispatch_get_main_queue(), ^{
        [rightTable reloadData:YES];
    });
}
#pragma mark - AFInterfaceAPIDelegate
- (void)interfaceExcuteSuccess:(id)retObj apiName:(NSString*)ApiName apiFlag:(NSString*) ApiFlag {
    // 推荐列表
    if ([ApiName isEqualToString:API_ReadsList]) {
        if ([ApiFlag isEqualToString:@"-1"]) {
            @try {
                if (m_indexNum == 1) {
                    leftArray = [[NSMutableArray alloc] init];
                }
                HNReadsList *mClass = (HNReadsList *)retObj;
                if ([mClass.success boolValue] && [mClass.yi18 count] != 0) {
                    m_indexNum ++;
                    [leftArray addObjectsFromArray:mClass.yi18];
                    [leftTable reloadData:(([mClass.total integerValue]==[leftArray count])?YES:NO)];
                }
            }
            @catch (NSException *exception) {
                [self HUDShow:@"获取推荐列表异常" delay:kShowTitleAfterDelay];
            }
        }
        else {
            dispatch_group_leave(downloadGroup);//离开组
            for (HNNewsType *mClass1 in mTypeArray) {
                @try {
                    if([mClass1.mId isEqualToString:ApiFlag]) {
                        HNReadsList *mClass = (HNReadsList *)retObj;
                        if ([mClass.success boolValue] && [mClass.yi18 count] != 0) {
                            [apiDic setObject:mClass.yi18 forKey:mClass1.name];
                        }
                    }
                }
                @catch (NSException *exception) {
                    [self HUDShow:@"获取分类列表异常" delay:kShowTitleAfterDelay];
                }
            }
        }
    }
    // 分类
    if ([ApiName isEqualToString:API_ReadsTypeList]) {
        HNNewsTypeList *mClass = (HNNewsTypeList *)retObj;
        if ([mClass.success boolValue] && [mClass.yi18 count] != 0) {
            mTypeArray = nil;
            mTypeArray = [[NSMutableArray alloc] init];
            [mTypeArray addObjectsFromArray:mClass.yi18];
            [self requestTypesList];
        }
    }
}

- (void)interfaceExcuteError:(NSError*)error apiName:(NSString*)ApiName apiFlag:(NSString*) ApiFlag {
    // 推荐列表
    if ([ApiName isEqualToString:API_ReadsList]) {
        if ([ApiFlag isEqualToString:@"-1"]) {
            [leftTable reloadData:NO];
        }else {
            dispatch_group_leave(downloadGroup);//离开组
        }
    }
    if([[error.userInfo objectForKey:NSLocalizedDescriptionKey] length] > 0) {
        [self HUDShow:[error.userInfo objectForKey:NSLocalizedDescriptionKey] delay:kShowTitleAfterDelay];
    }
    else if(HUD) {
        [HUD hide:YES];
    }
}

#pragma mark - CustomerTableViewDelegate
- (void)tableViewHeaderRereshing:(UITableView *)tableView withCompletioned:(void (^)())completioned {
    if (tableView == leftTable) {
        m_indexNum = 1;
        [self requestHotList];
    }
    else if (tableView == rightTable) {
        [self requestTypeList];
    }
}
- (void)tableViewFooterRereshing:(UITableView *)tableView withCompletioned:(void (^)())completioned {
    [self requestHotList];
}

#pragma mark - Table view data source
#pragma mark - tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == rightTable) {
        return 50;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    YSYSectionHeaderView *sectionHead = [[YSYSectionHeaderView alloc] init];
    sectionHead.section = section;
    sectionHead.tableView = tableView;
    ({
        CGFloat offset_x = 10.0f;
        CGFloat offset_y = 6.0f;
        CGFloat icon_size = 30.0f;
        HNNewsType *mClass = (HNNewsType *)mTypeArray[section];
        // back
        UIView *back = [[UIView alloc] initWithFrame:CGRectMake(0, 5, __MainScreen_Width, 45.0)];
        back.backgroundColor = [UIColor whiteColor];
        [sectionHead addSubview:back];
        // line
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, __MainScreen_Width, 0.5)];
        line.image = [UIImage imageNamed:@"cell_dotline"];
        [sectionHead addSubview:line];
        // icon
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(offset_x, (50-offset_y-icon_size), icon_size, icon_size)];
        icon.image = [UIImage imageNamed:mClass.name];
        [sectionHead addSubview:icon];
        // right
        UIImageView *right = [[UIImageView alloc] initWithFrame:CGRectMake(__MainScreen_Width-offset_x-12, (45-13)/2+5, 12, 13)];
        right.image = [UIImage imageNamed:@"header_arrow"];
        [sectionHead addSubview:right];
        // text
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(icon_size+2*offset_x, (45-15)/2+5, 200, 15)];
        title.font = [UIFont boldSystemFontOfSize:14.0f];
        title.text = mClass.name;
        [sectionHead addSubview:title];
        // line
        UIImageView *line2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 49, __MainScreen_Width, 0.5)];
        line2.image = [UIImage imageNamed:@"cell_dotline"];
        [sectionHead addSubview:line2];
        // button
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(0, 0, __MainScreen_Width, 50.0f)];
        [btn addTarget:self action:@selector(headerMethod:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 1000+section;
        [sectionHead addSubview:btn];
    });
    return sectionHead;
}

- (void)headerMethod:(UIButton *)sender {
    NSInteger index = (sender.tag - 1000);
    HNNewsType *mClass = (HNNewsType *)mTypeArray[index];
    // detail info
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return HC_Cell_height;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == rightTable) {
        return [[apiDic allKeys] count];
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == leftTable) {
        return [leftArray count];
    }else if (tableView == rightTable) {
        HNNewsType *mClass = (HNNewsType *)mTypeArray[section];
        return [(NSArray *)apiDic[mClass.name] count];
    }
    return 0;
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
        if (tableView == leftTable) {
            HNReadDetail *mclass = (HNReadDetail *) leftArray[indexPath.row];
            [cell.mIconImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",kImageUrl,mclass.img]] placeholderImage:[UIImage imageNamed:@"hc_cell_icon"]];
            cell.mTitleLab.text = mclass.title;
            cell.mTimeLab.text = [NSString changeTimeMethod:mclass.time];
        }
        else if(tableView == rightTable) {
            HNNewsType *mClass1 = (HNNewsType *)mTypeArray[indexPath.section];
            HNReadDetail *mclass = (HNReadDetail *)(NSArray *)apiDic[mClass1.name][indexPath.row];
            [cell.mIconImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",kImageUrl,mclass.img]] placeholderImage:[UIImage imageNamed:@"hc_cell_icon"]];
            cell.mTitleLab.text = mclass.title;
            cell.mTimeLab.text = [NSString changeTimeMethod:mclass.time];
        }
    }
    @catch (NSException *exception) {
        [self HUDShow:@"初始化信息错误!" delay:kShowTitleAfterDelay];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    @try {
        if (tableView == leftTable) {
            HNReadDetail *mclass = (HNReadDetail *)leftArray[indexPath.row];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:mclass.mId forKey:@"id"];
            [self pushNewViewController:@"DetailReadViewController" isNibPage:NO withData:dic];
        }
        else if (tableView == rightTable) {
            HNNewsType *mClass1 = (HNNewsType *)mTypeArray[indexPath.section];
            HNReadDetail *mclass = (HNReadDetail *)(NSArray *)apiDic[mClass1.name][indexPath.row];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:mclass.mId forKey:@"id"];
            [self pushNewViewController:@"DetailReadViewController" isNibPage:NO withData:dic];
        }
    }
    @catch (NSException *exception) {
        [self HUDShow:@"获取详情错误!" delay:kShowTitleAfterDelay];
    }
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    canUseDelegate = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 点击按钮
    if(!canUseDelegate) {
        return;
    }
    [mSwitcher sliderViewMove:(mScrollView.contentOffset.x/__MainScreen_Width)];
    NSInteger page = (mScrollView.contentOffset.x+__MainScreen_Width/2.0) / __MainScreen_Width;
    if (mCurrentPage == page) {
        return;
    }
    mCurrentPage = page;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 移动
    if (mScrollView.contentOffset.x <= 10 ||
        mScrollView.contentOffset.x >= (__MainScreen_Width-10)) {
        [mSwitcher forceSelectedIndex:mCurrentPage animated:NO];
        canUseDelegate = NO;
    }
}

#pragma mark 移动ScrollView到某个页面
-(void)moveScrollowViewAthIndex:(NSInteger)aIndex {
    canUseDelegate = NO;
    CGRect vMoveRect = CGRectMake(__MainScreen_Width * aIndex, 0, __viewContent_hight3, __MainScreen_Width);
    [mScrollView scrollRectToVisible:vMoveRect animated:YES];
    mCurrentPage = aIndex;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end



@implementation YSYSectionHeaderView
- (void)setFrame:(CGRect)frame {
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    CGRect sectionRect = [self.tableView rectForSection:self.section];
    CGRect newFrame = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(sectionRect), CGRectGetWidth(frame), CGRectGetHeight(frame));
    [super setFrame:newFrame];
    
}
@end


