//
//  FoodViewController.m
//  HealthNews
//
//  Created by yushengyang on 15/4/17.
//  Copyright (c) 2015年 yushengyang. All rights reserved.
//

#import "FoodViewController.h"
#import "RefreshTableView.h"

@interface FoodViewController ()<UIScrollViewDelegate,CustomerTableViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    AFInterfaceAPIExcute *typeList;//分类列表
    // 控制刷新
    dispatch_group_t downloadGroup;
    BOOL canUpdate;
}
// 大分类列表
@property (nonatomic, strong) RefreshTableView *typeTable;
@property (nonatomic, strong) NSMutableArray *typeArray;
@property (nonatomic, strong) NSMutableArray *typeSubArray;
//请求数组
@property (strong, nonatomic) NSMutableArray *apiArray;
@property (strong, nonatomic) NSMutableDictionary *apiDic;

@end

@implementation FoodViewController
@synthesize typeTable,
typeArray,
apiArray,
apiDic,
typeSubArray;

- (void)viewDidLoad {
    self.isHideLeftItem = YES;
    self.isShowTabbar = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self titleLabel:@"健康食谱"];
    typeArray = [[NSMutableArray alloc] init];
    apiArray = [[NSMutableArray alloc] init];
    apiDic = [[NSMutableDictionary alloc] init];
    [self setUI];
}

- (void)setUI {
    // 推荐列表
    typeTable = [[RefreshTableView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, __viewContent_hight3) withStyle:UITableViewStylePlain withType:ULE_TableViewTypeHeader];
    // 分割线 偏右 ios7
    if ([typeTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [typeTable setSeparatorInset:UIEdgeInsetsZero];
    }
    typeTable.delegate = self;
    typeTable.dataSource = self;
    typeTable.touchDelegate = self;
    typeTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:typeTable];
    [typeTable.header beginRefreshing];
}
#pragma mark -分类列表
- (void)requestTypeList {
    
    typeList = [[AFInterfaceAPIExcute alloc] initWithAPI:API_CookTypeList retClass:@"HNCookTypeList" Params:nil setDelegate:self] ;
    [typeList setFlagCommonApi:@"-1"];
    [typeList beginRequest];
}
- (void)requestTypeSubList {
    
    [apiArray removeAllObjects];
    [apiDic removeAllObjects];
    downloadGroup = dispatch_group_create();//创建组
    //并行发出请求 发出的顺序不定 不是按照顺序做的
    dispatch_apply([typeArray count], dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(size_t i) {
        HNCookType *mClass = (HNCookType *)typeArray[i];
        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:
                                       @{@"id":mClass.mId}];
        AFInterfaceAPIExcute *tmpApi = [[AFInterfaceAPIExcute alloc] initWithAPI:API_CookTypeList retClass:@"HNCookTypeList" Params:params setDelegate:self] ;
        [tmpApi setFlagCommonApi:mClass.mId];
        [tmpApi beginRequest];
        [apiArray addObject:tmpApi];
        dispatch_group_enter(downloadGroup);//进入组
    });
    //等待组中任务完成 自动通知
    dispatch_group_notify(downloadGroup, dispatch_get_main_queue(), ^{
        [typeTable reloadData:YES];
    });
}

#pragma mark - CustomerTableViewDelegate
- (void)tableViewHeaderRereshing:(UITableView *)tableView withCompletioned:(void (^)())completioned {
    [self requestTypeList];
}
#pragma mark - Table view data source
#pragma mark - tableViewDelegate
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[apiDic allKeys] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"HomeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    @try {
        cell.textLabel.text = [apiDic allKeys][indexPath.row];
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
        NSLog(@"%@",apiDic[[apiDic allKeys][indexPath.row]]);
    }
    @catch (NSException *exception) {
        [self HUDShow:@"获取详情错误!" delay:kShowTitleAfterDelay];
    }
    
}
#pragma mark - AFInterfaceAPIDelegate
- (void)interfaceExcuteSuccess:(id)retObj apiName:(NSString*)ApiName apiFlag:(NSString*) ApiFlag {
    // 推荐列表
    if ([ApiName isEqualToString:API_CookTypeList]) {
        if ([ApiFlag isEqualToString:@"-1"]) {
            @try {
                [typeArray removeAllObjects];
                HNCookTypeList *mClass = (HNCookTypeList *)retObj;
                if ([mClass.success boolValue] && [mClass.yi18 count] != 0) {
                    [typeArray addObjectsFromArray:mClass.yi18];
                    [self requestTypeSubList];
                }
            }
            @catch (NSException *exception) {
                [self HUDShow:@"获取分类列表异常!" delay:kShowTitleAfterDelay];
            }
        }
        else {
            dispatch_group_leave(downloadGroup);//离开组
            for (HNCookType *mClass1 in typeArray) {
                @try {
                    if([mClass1.mId isEqualToString:ApiFlag]) {
                        HNCookTypeList *mClass = (HNCookTypeList *)retObj;
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
//        HNNewsTypeList *mClass = (HNNewsTypeList *)retObj;
//        if ([mClass.success boolValue] && [mClass.yi18 count] != 0) {
//            mTypeArray = nil;
//            mTypeArray = [[NSMutableArray alloc] init];
//            [mTypeArray addObjectsFromArray:mClass.yi18];
//            [self requestTypesList];
//        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
