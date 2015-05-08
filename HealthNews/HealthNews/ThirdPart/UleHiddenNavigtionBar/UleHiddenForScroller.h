//
//  UleHiddenForScroller.h
//  PostLife_new
//
//  Created by yushengyang on 15/5/8.
//  Copyright (c) 2015年 ule. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UleHiddenForScroller : NSObject
/**
 需要隐藏导航栏的VC
 */
@property (nonatomic, weak) UIViewController *mViewController;
/**
 可通过滑动隐藏导航栏
 */
@property (nonatomic, strong) UIScrollView *mScrollView;
/**
 滑动中隐藏导航栏
 default = YES
 */
@property (nonatomic) BOOL shouldHideNavigationBarOnScroll;
/**
 if YES, UI-bars can also be hidden via UIWebView's JavaScript calling window.scrollTo(0,1))
 default = NO
 */
@property (nonatomic) BOOL shouldHideUIBarsWhenNotDragging;
/**
 初始化
 */
- (id)initWithViewController:(UIViewController*)viewController
                  scrollView:(UIScrollView*)scrollView;
/**
 重载方法 
 实现隐藏
 */
- (void)viewWillAppear:(BOOL)animated;
- (void)viewDidAppear:(BOOL)animated;
- (void)viewWillDisappear:(BOOL)animated;
- (void)viewDidDisappear:(BOOL)animated;
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;
- (void)expand;
- (void)contract;
@end
