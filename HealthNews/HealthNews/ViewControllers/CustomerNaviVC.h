//
//  CustomerNaviVC.h
//  HealthNews
//
//  Created by yushengyang on 15/4/17.
//  Copyright (c) 2015年 yushengyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NNPNavigation.h"

#ifndef IOS_VERSION
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#endif

#define UINavi_Image @"navi_background"

@interface UINavigationBar (MyCustomNaviBar)

@end

@implementation UINavigationBar (MyCustomNaviBar)

- (void)drawRect:(CGRect)rect
{
    UIImage *barImage = [UIImage imageNamed:UINavi_Image];
    [barImage drawInRect:rect];
}

@end

@interface CustomerNaviVC : NNPNavigation
{
    UIImage *_backgroundImage;
}

@property (nonatomic, retain) UIImage *backgroundImage;

@end
