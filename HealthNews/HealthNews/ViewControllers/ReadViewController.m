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

@interface ReadViewController ()<UIScrollViewDelegate,CustomerTableViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    AFInterfaceAPIExcute *hotList;//推荐列表
    AFInterfaceAPIExcute *typeList;//资讯分类列表
    AFInterfaceAPIExcute *typeDetailList;//资讯分类列表
    NSInteger m_indexNum;
    // 控制刷新
    dispatch_group_t downloadGroup;
    BOOL canUpdate;
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
        if (index == 0) {
            if (leftArray == nil || [leftArray count] == 0) {
                // 刷新
                [weakSelf.leftTable.header beginRefreshing];
            }
        }else if (index == 1) {
            if (apiDic == nil || [[apiDic allKeys] count] == 0) {
                // 刷新
                [weakSelf.rightTable.header beginRefreshing];
            }
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

}

#pragma mark -推荐列表
- (void)requestHotList {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:
                                   @{@"page":[NSString stringWithFormat:@"%@",@(m_indexNum)],
                                     @"limit":@"20",
                                     @"type":@"id"}];
    hotList = [[AFInterfaceAPIExcute alloc] initWithAPI:API_ReadsList retClass:@"HNReadDetailBase" Params:params setDelegate:self];
    [hotList setFlagCommonApi:@"-1"];
    [hotList beginRequest];

}
- (void)requestTypeList {
    typeList = [[AFInterfaceAPIExcute alloc] initWithAPI:API_ReadsTypeList retClass:@"HNNewsTypeList" Params:nil setDelegate:self] ;
    [typeList beginRequest];
}
- (void)requestTypesList {
    apiArray = [[NSMutableArray alloc] init];
    apiDic = [[NSMutableDictionary alloc] init];
    downloadGroup = dispatch_group_create();//创建组
    //并行发出请求 发出的顺序不定 不是按照顺序做的
    dispatch_apply([mTypeArray count], dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(size_t i) {
        HNNewsType *mClass = (HNNewsType *)mTypeArray[i];
        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:
                                       @{@"page":[NSString stringWithFormat:@"%@",@(1)],
                                         @"limit":@"2",
                                         @"type":@"id",
                                         @"id":mClass.mId}];
        AFInterfaceAPIExcute *tmpApi = [[AFInterfaceAPIExcute alloc] initWithAPI:API_ReadsList retClass:@"HNReadDetailBase" Params:params setDelegate:self] ;
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
                HNReadDetailBase *mClass = (HNReadDetailBase *)retObj;
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
                        HNReadDetailBase *mClass = (HNReadDetailBase *)retObj;
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
    return sectionHead;
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
            HNNewsDetail *mclass = (HNNewsDetail *) leftArray[indexPath.row];
            [cell.mIconImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",kImageUrl,mclass.img]] placeholderImage:[UIImage imageNamed:@"hc_cell_icon"]];
            cell.mTitleLab.text = mclass.title;
            cell.mTimeLab.text = [NSString changeTimeMethod:mclass.time];
        }
        else if(tableView == rightTable) {
            HNNewsType *mClass1 = (HNNewsType *)mTypeArray[indexPath.section];
            HNNewsDetail *mclass = (HNNewsDetail *)(NSArray *)apiDic[mClass1.name][indexPath.row];
            [cell.mIconImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",kImageUrl,mclass.img]] placeholderImage:[UIImage imageNamed:@"hc_cell_icon"]];
            cell.mTitleLab.text = mclass.title;
            cell.mTimeLab.text = [NSString changeTimeMethod:mclass.time];
        }
        
    }
    @catch (NSException *exception) {
        
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == leftTable) {
        @try {
//            SPTableView *tmp = (SPTableView *)tableView;
//            HNNewsDetail *mclass = (HNNewsDetail *)tmp.mInfoArray[indexPath.row];
//            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//            [dic setObject:mclass.mId forKey:@"id"];
//            [self.supVC pushNewViewController:@"DetailViewController" isNibPage:NO withData:dic];
        }
        @catch (NSException *exception) {
            //[self HUDShow:@"获取详情错误!" delay:kShowTitleAfterDelay];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end



@implementation YSYSectionHeaderView
- (void)setFrame:(CGRect)frame {
    CGRect sectionRect = [self.tableView rectForSection:self.section];
    CGRect newFrame = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(sectionRect), CGRectGetWidth(frame), CGRectGetHeight(frame));
    [super setFrame:newFrame];
}
@end


