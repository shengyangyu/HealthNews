//
//  CustomerNaviVC.m
//  HealthNews
//
//  Created by yushengyang on 15/4/17.
//  Copyright (c) 2015年 yushengyang. All rights reserved.
//

#import "CustomerNaviVC.h"

@interface CustomerNaviVC ()

@end

@implementation CustomerNaviVC

@synthesize backgroundImage;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enteredForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)enteredForeground
{
    [self viewWillAppear:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    if ([self.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [[self navigationBar] setTintColor:[UIColor colorWithRed:227.0/255.f green:6.0/255.f blue:21.0/255.f alpha:1.0f]];
        if (IOS_VERSION >= 5.0) {
            
            if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
            {
                [[self navigationBar] setBackgroundImage:[[UIImage imageNamed:UINavi_Image] stretchableImageWithLeftCapWidth:5 topCapHeight:20] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
            }
            else
            {
                [[self navigationBar] setBackgroundImage:[[UIImage imageNamed:UINavi_Image] stretchableImageWithLeftCapWidth:5 topCapHeight:20] forBarMetrics:UIBarMetricsDefault];
            }
        }
    }
    else
    {
        [[self navigationBar] setTintColor:nil];
    }
    [super viewWillAppear:animated];
}

- (UIModalPresentationStyle)modalPresentationStyle {
    UIModalPresentationStyle style = [super modalPresentationStyle];
    
    if (style != UIModalPresentationFullScreen) {
        return style;
    } else if ([self topViewController]) {
        return [[self topViewController] modalPresentationStyle];
    } else {
        return style;
    }
}

#pragma mark 控制状态栏的样式
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
