//
//  CustomerTabBarVC.m
//  HealthNews
//
//  Created by yushengyang on 15/4/17.
//  Copyright (c) 2015年 yushengyang. All rights reserved.
//

#import "CustomerTabBarVC.h"
#import "RDVTabBarItem.h"

#import "HomeViewController.h"
#import "ReadViewController.h"
#import "FoodViewController.h"
#import "UserViewController.h"

@interface CustomerTabBarVC ()

@end

@implementation CustomerTabBarVC

- (id)init
{
    self = [super init];
    if (self) {
        [self initWithRootViewController];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
 *  初始化
 */
- (void)initWithRootViewController {
    
    CustomerNaviVC *nvai1 = [[CustomerNaviVC alloc] initWithRootViewController:[[HomeViewController alloc] init]];
    CustomerNaviVC *nvai2 = [[CustomerNaviVC alloc] initWithRootViewController:[[ReadViewController alloc] init]];
    CustomerNaviVC *nvai3 = [[CustomerNaviVC alloc] initWithRootViewController:[[FoodViewController alloc] init]];
    CustomerNaviVC *nvai4 = [[CustomerNaviVC alloc] initWithRootViewController:[[UserViewController alloc] init]];

    [self setViewControllers:@[nvai1,nvai2,nvai3,nvai4]];
    [self customerTabBarItem:self];
}

/*
 *  自定义图片
 */
- (void)customerTabBarItem:(RDVTabBarController *)tabBarController {
    
    UIImage *finishedImage = [UIImage imageNamed:@"tb_normal_background"];
    UIImage *unfinishedImage = [UIImage imageNamed:@"tb_normal_background"];
    NSArray *tabBarItemImages = @[@"tb_news", @"tb_reader", @"tb_me", @"tb_found"];
    NSArray *tabBarTitles = @[@"资讯",@"阅读",@"食谱",@"我"];
    
    for (NSInteger index = 0; index < [tabBarTitles count]; index ++) {
        
        RDVTabBarItem *item = [[tabBarController tabBar] items][index];
        // image
        [item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage];
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_highlight",[tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",[tabBarItemImages objectAtIndex:index]]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        // title
        [item setTitle:tabBarTitles[index]];
        item.titlePositionAdjustment =UIOffsetMake(0.0f, 5.0f);
        if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
            item.unselectedTitleAttributes = @{
                                           NSFontAttributeName: [UIFont systemFontOfSize:12],
                                           NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                           };
            item.selectedTitleAttributes = @{
                                               NSFontAttributeName: [UIFont systemFontOfSize:12], NSForegroundColorAttributeName: [UIColor redColor],
                                               };
        } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
           item.unselectedTitleAttributes = @{
                                           UITextAttributeFont: [UIFont systemFontOfSize:12],
                                           UITextAttributeTextColor: [UIColor lightGrayColor],
                                           };
            item.selectedTitleAttributes = @{
                                             NSFontAttributeName: [UIFont systemFontOfSize:12],
                                             NSForegroundColorAttributeName: [UIColor redColor],
                                             };
#endif
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
