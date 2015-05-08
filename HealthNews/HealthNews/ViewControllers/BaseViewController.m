//
//  BaseViewController.m
//  HealthNews
//
//  Created by yushengyang on 15/4/17.
//  Copyright (c) 2015年 yushengyang. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController
@synthesize m_Params,isShowTabbar,isHideLeftItem;


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    // Do any additional setup after loading the view.
    // 针对ios7以上的处理
#ifdef __IPHONE_7_0
    if (IOS7_OR_LATER)
    {
        self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeRight | UIRectEdgeBottom;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
#endif
    
    [self addBackNavigationButton];
}

- (void)viewWillAppear:(BOOL)animated {
    
    if (!self.isShowTabbar && self.rdv_tabBarController.tabBar.hidden==NO) {
        [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
    }
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    if (self.rdv_tabBarController.tabBar.hidden == YES) {
        [[self rdv_tabBarController] setTabBarHidden:NO];
    }
    [super viewWillDisappear:animated];
}

#pragma mark -
#pragma mark - MBProgressHUD Delegate
- (void)initHUD
{
    if (HUD == nil ) {
        HUD = [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.delegate = self;
    }
}
- (void)HUDShow:(NSString*)text
{
    [self initHUD];
    HUD.labelText = text;
    HUD.mode = MBProgressHUDModeIndeterminate;
    [HUD show:YES];
}
- (void)HUDShow:(NSString*)text delay:(float)second
{
    [self initHUD];
    HUD.labelText = text;
    HUD.mode = MBProgressHUDModeText;
    [HUD show:YES];
    [HUD hide:YES afterDelay:second];
}
- (void)HUDShow:(NSString*)text delay:(float)second dothing:(BOOL)bDo
{
    [self initHUD];
    HUD.labelText = text;
    HUD.mode = MBProgressHUDModeText;
    [HUD show:YES];
    [HUD hide:YES afterDelay:second dothing:bDo];
}
- (void)HUDdelayDo
{
}
- (void)hudWasHidden:(MBProgressHUD *)hud{
    [HUD removeFromSuperview];
    HUD = nil;
}
- (void)HUDHidden{
    [HUD hide:YES];
}

#pragma mark - 通用请求方法
- (void)apiRequest:(NSString *)_apiUrl
             class:(NSString *)_className
            params:(NSMutableDictionary*) _paras
{
    api = [[AFInterfaceAPIExcute alloc] initWithAPI:_apiUrl retClass:_className Params:_paras setDelegate:self] ;
    [api beginRequest];
}
- (void)interfaceExcuteError:(NSError *)error apiName:(NSString *)ApiName apiFlag:(NSString*) ApiFlag
{
    if([[error.userInfo objectForKey:NSLocalizedDescriptionKey] length] > 0) {
        [self HUDShow:[error.userInfo objectForKey:NSLocalizedDescriptionKey] delay:kShowTitleAfterDelay];
    }
    else if(HUD) {
        [HUD hide:YES];
    }
}

- (void)failWithErrorText:(NSString *)text
{
    NSError * error = [NSError errorWithDomain:@"errormessage" code:0 userInfo:[NSDictionary dictionaryWithObject:text forKey:NSLocalizedDescriptionKey]];
    
    [self HUDShow:[error.userInfo objectForKey:NSLocalizedDescriptionKey] delay:kShowTitleAfterDelay];
}

#pragma mark -
#pragma mark - push跳转
/**  参数说明
 *  controllerName : push的目标页 例：@“testcontroll”    ---注意不带.h
 *  isNibPage     : 目标页是否带 xib 文件
 *  setHideTabBar : 当前页是否隐藏 tabBar      -----注意 是当前页 非目标页
 *  mData:传递值
 */
- (void)pushNewViewController:(NSString *)controllerName
                    isNibPage:(BOOL)isNib
                     withData:(NSMutableDictionary *)mData {
    
    if (controllerName.length <= 0)
        return;
    // 保存截图
    CustomerNaviVC *mNavi = (CustomerNaviVC *)self.navigationController;
    [mNavi addScreenshot];
    
    Class class_Page = NSClassFromString((NSString *)controllerName);
    if (class_Page != nil) {
        
        id viewCtrl_Page = isNib ? [[class_Page alloc] initWithNibName:controllerName bundle:nil]
        : [[class_Page alloc] init];
        if (!m_Params) {
            m_Params = [[NSMutableDictionary alloc]init];
        }
        [viewCtrl_Page setM_Params:m_Params];
        // 传递值
        if (mData) {
            NSMutableDictionary *tmpParams = [[NSMutableDictionary alloc]initWithDictionary:m_Params];
            [tmpParams setValuesForKeysWithDictionary:mData];
            [viewCtrl_Page setM_Params:nil];
            [viewCtrl_Page setM_Params:tmpParams];
        }        
        SEL delegateMethod = NSSelectorFromString(@"setM_delegate:");
        if ([viewCtrl_Page respondsToSelector:delegateMethod]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [viewCtrl_Page performSelector:delegateMethod withObject:self];
#pragma clang diagnostic pop
        }
        [self.navigationController pushViewController:viewCtrl_Page animated:YES];
    }
}


#pragma mark -设置页面标题
- (void)titleLabel:(NSString *)labelText {
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    lab.text = labelText;
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:18];
    lab.backgroundColor = [UIColor clearColor];
    lab.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = lab;
}
#pragma mark - 弹出框
- (void)showAlert:(NSString *)message{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil, nil];
    [alert show];
}
#pragma mark - 设置导航栏左边按钮
- (void)addBackNavigationButton{
    //若为主页，则不增加返回按钮
    if (self.isHideLeftItem) {
        self.navigationItem.hidesBackButton = YES;
        return;
    }
    UIButton *l_backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.0, 0.0, 45, 44)];
    [l_backBtn setBackgroundColor:[UIColor clearColor]];
    [l_backBtn setBackgroundImage:[UIImage imageNamed:@"navi_back"] forState:UIControlStateNormal];
    [l_backBtn setBackgroundImage:[UIImage imageNamed:@"bobo_navi_back_highlighted"] forState:UIControlStateHighlighted];
    [l_backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar_Btn = [[UIBarButtonItem alloc]initWithCustomView:l_backBtn];
    
    UIBarButtonItem *bar_Btn_l = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    /**
     *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-5时，间距正好调整
     *  为0；width为正数时，正好相反，相当于往左移动width数值个像素
     */
    bar_Btn_l.width = -5;
    
    self.navigationItem.leftBarButtonItems = @[bar_Btn_l,bar_Btn];
}
- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 导航条右按钮
- (void)setRightImageButton:(NSString*)imgUrl {
    
    UIView* rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    rightView.backgroundColor = [UIColor clearColor];
    UIButton *opinion = [UIButton buttonWithType:UIButtonTypeCustom];
    [opinion setImage:[UIImage imageNamed:imgUrl] forState:UIControlStateNormal];
    opinion.frame = CGRectMake(0, 8, 30, 30);
    [opinion addTarget:self
                action:@selector(rightBtn1Click:)
      forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:opinion];
    UIBarButtonItem *r_barButtonItem = [[UIBarButtonItem alloc]
                                        initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItem = r_barButtonItem;
}
- (void)rightBtn1Click:(id)sender{}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
