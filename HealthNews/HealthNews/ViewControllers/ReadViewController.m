//
//  ReadViewController.m
//  HealthNews
//
//  Created by yushengyang on 15/4/17.
//  Copyright (c) 2015年 yushengyang. All rights reserved.
//

#import "ReadViewController.h"

@interface ReadViewController ()

@end

@implementation ReadViewController

- (void)viewDidLoad {
    self.isHideLeftItem = YES;
    self.isShowTabbar = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self titleLabel:@"健康常识"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end