//
//  DetailViewController.m
//  HealthNews
//
//  Created by yushengyang on 15/4/17.
//  Copyright (c) 2015年 yushengyang. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
{
    AFInterfaceAPIExcute *apiNewsDetail;//资讯详情
    UIWebView *mWebView;
}

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self titleLabel:@"资讯详情"];
    [self setUI];
    
    
    [self requestNewsDetail];
}

- (void)setUI {
    
    mWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, __viewContent_hight1)];
    mWebView.backgroundColor = [UIColor whiteColor];
    mWebView.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:mWebView];
}

- (void)requestNewsDetail {
    @try {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary: @{@"id":m_Params[@"id"]}];
        apiNewsDetail = [[AFInterfaceAPIExcute alloc] initWithAPI:API_NewsDetail retClass:@"HNNewsDetailBase" Params:params setDelegate:self] ;
        [apiNewsDetail beginRequest];
    }
    @catch (NSException *exception) {
        [self HUDShow:@"请求资讯详情错误" delay:kShowTitleAfterDelay];
    }
    
}
#pragma mark - AFInterfaceAPIDelegate
-(void) interfaceExcuteSuccess:(id)retObj apiName:(NSString*)ApiName {
    
    [self HUDHidden];
    // 资讯列表
    if ([ApiName isEqualToString:API_NewsDetail]) {
        HNNewsDetailBase *mClass = (HNNewsDetailBase *)retObj;
        if (mClass.yi18.img.length != 0) {
            NSString *htmlStr=[NSString stringWithFormat:@"<p><strong>%@</strong></p><p>%@</p><p></p> <img src='%@/%@' width=\"305\" height=\"241\"/>%@",mClass.yi18.title,[NSString changeTimeMethod:mClass.yi18.time],kImageUrl, mClass.yi18.img,mClass.yi18.message];
            [mWebView loadHTMLString:htmlStr baseURL:nil];
        }else {
            NSString *htmlStr=[NSString stringWithFormat:@"%@", mClass.yi18.message];
            [mWebView loadHTMLString:htmlStr baseURL:nil];
        }
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
