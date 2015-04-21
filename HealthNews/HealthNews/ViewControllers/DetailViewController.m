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
}

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self titleLabel:@"资讯详情"];
    [self requestNewsDetail];
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
-(void) interfaceExcuteSuccess:(id)retObj apiName:(NSString*)ApiName
{
    [self HUDHidden];
    // 资讯列表
    if ([ApiName isEqualToString:API_NewsDetail]) {
        HNNewsDetailBase *mClass = (HNNewsDetailBase *)retObj;
        
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
