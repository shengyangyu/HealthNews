//
//  FoodDetailViewController.m
//  HealthNews
//
//  Created by yushengyang on 15/4/30.
//  Copyright (c) 2015年 yushengyang. All rights reserved.
//

#import "FoodDetailViewController.h"

@interface FoodDetailViewController ()
{
    AFInterfaceAPIExcute *apiNewsDetail;//资讯详情
    UIWebView *mWebView;
}

@end

@implementation FoodDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self titleLabel:@"食谱详情"];
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
        apiNewsDetail = [[AFInterfaceAPIExcute alloc] initWithAPI:API_CooksDetail retClass:@"HNCookDetail" Params:params setDelegate:self] ;
        [apiNewsDetail beginRequest];
    }
    @catch (NSException *exception) {
        [self HUDShow:@"请求食谱详情错误!" delay:kShowTitleAfterDelay];
    }
    
}
#pragma mark - AFInterfaceAPIDelegate
-(void) interfaceExcuteSuccess:(id)retObj apiName:(NSString*)ApiName apiFlag:(NSString*) ApiFlag {
    
    [self HUDHidden];
    // 资讯列表
    if ([ApiName isEqualToString:API_ReadsDetail]) {
        HNCookDetail *mClass = (HNCookDetail *)retObj;
        if (mClass.yi18.img.length != 0) {
            NSString *htmlStr=[NSString stringWithFormat:@"<p><strong>%@</strong></p><p>%@</p><p></p> <img src='%@/%@' width=\"305\" height=\"241\"/>%@",mClass.yi18.name,[NSString changeTimeMethod:mClass.yi18.food],kImageUrl, mClass.yi18.img,mClass.yi18.message];
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
