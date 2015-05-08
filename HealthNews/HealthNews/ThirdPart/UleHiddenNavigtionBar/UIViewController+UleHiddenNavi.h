//
//  UIViewController+UleHiddenNavi.h
//  PostLife_new
//
//  Created by yushengyang on 15/5/8.
//  Copyright (c) 2015年 ule. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UleHiddenForScroller;

@interface UIViewController (UleHiddenNavi)
// 当前scroller
@property (nonatomic, strong) UleHiddenForScroller *mScroller;

@end