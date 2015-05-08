//
//  UleHiddenForScroller.m
//  PostLife_new
//
//  Created by yushengyang on 15/5/8.
//  Copyright (c) 2015年 ule. All rights reserved.
//

#import "UleHiddenForScroller.h"
#import <objc/runtime.h>

static char __UleHiddenForScrollerContext;

@interface UleHiddenForScroller () {

    CGFloat startContentOffset;// 起点位置
    CGFloat lastContentOffset;// 终点位置
    BOOL hidden;// 是否隐藏
    BOOL isAnimating;// 是否动画
    __weak UINavigationController *mNavigationController;// 当前导航
}

@end

@implementation UleHiddenForScroller

#pragma mark -
#pragma mark Init/Dealloc
- (id)initWithViewController:(UIViewController *)viewController
                  scrollView:(UIScrollView *)scrollView {
    
    return [self initWithViewController:viewController
                             scrollView:scrollView
                     ignoresTranslucent:YES];
}

- (id)initWithViewController:(UIViewController *)viewController
                  scrollView:(UIScrollView *)scrollView
          ignoresTranslucent:(BOOL)ignoresTranslucent {
    
    self = [super init];
    if (self) {
        _mViewController = viewController;
        _shouldHideNavigationBarOnScroll = YES;
        _shouldHideUIBarsWhenNotDragging = NO;
        self.mScrollView = scrollView;
        hidden = NO;
        isAnimating = NO;
    }
    return self;
}

- (void)dealloc {
    self.mScrollView = nil;
}

#pragma mark -
#pragma mark Accessors
- (void)setMScrollView:(UIScrollView *)mScrollView {
    if (mScrollView != _mScrollView) {
        // 移除
        if (_mScrollView) {
            [_mScrollView removeObserver:self forKeyPath:@"contentOffset" context:&__UleHiddenForScrollerContext];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
        }
        _mScrollView = mScrollView;
        // 添加
        if (_mScrollView) {
            [_mScrollView addObserver:self forKeyPath:@"contentOffset" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:&__UleHiddenForScrollerContext];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onWillEnterForegroundNotification:) name:UIApplicationWillEnterForegroundNotification object:nil];
        }
    }
}

#pragma mark - 执行操作 隐藏导航栏
- (void)expand {
    [self expand:YES];
}

- (void)expand:(BOOL)animated {
    
    @synchronized(self) {
        if(hidden)
            return;
        hidden = YES;
        isAnimating = animated;
    }
    if (_shouldHideNavigationBarOnScroll && self.isNavigationBarExisting){
        [self.navigationController setNavigationBarHidden:YES
                                                 animated:animated];
    }
    @synchronized(self){
        if (animated){
            [self performSelector:@selector(endAnimation:) withObject:nil afterDelay:0.2];
        }
    }
}
#pragma mark - 执行操作 显示导航栏
- (void)contract {
    [self contract:YES];
}

-(void)contract:(BOOL)animated {
    
    @synchronized(self) {
        if(!hidden)
            return;
        hidden = NO;
        isAnimating = animated;
    }
    if (_shouldHideNavigationBarOnScroll && !self.isNavigationBarExisting) {
        [self.navigationController setNavigationBarHidden:NO
                                                 animated:animated];
    }
    @synchronized(self) {
        if (animated) {
            [self performSelector:@selector(endAnimation:) withObject:nil afterDelay:0.2];
        }
    }
}

-(void)endAnimation:(id)sender {
    @synchronized(self){
        isAnimating = NO;
    }
}

#pragma mark -
#pragma mark Public
- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:hidden
                                             animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
}

- (void)viewWillDisappear:(BOOL)animated {
    [self contract:NO];
}

- (void)viewDidDisappear:(BOOL)animated {
    
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    [self contract];
}

#pragma mark -KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == &__UleHiddenForScrollerContext) {
        if ([keyPath isEqualToString:@"contentOffset"]) {
            CGPoint newPoint = [change[NSKeyValueChangeNewKey] CGPointValue];
            CGPoint oldPoint = [change[NSKeyValueChangeOldKey] CGPointValue];
            CGFloat deltaY = newPoint.y - oldPoint.y;
            if (deltaY == 0.0)
                return;
            // return if user hasn't dragged but trying to hide UI-bars (e.g. orientation change)
            if (deltaY > 0 &&
                !self.mScrollView.isDragging &&
                !self.shouldHideUIBarsWhenNotDragging)
                return;
            if (newPoint.y <= 0) {
                @synchronized(self){
                    if(!hidden)
                        return;
                }
                [self contract:NO];
                return;
            }
            @synchronized(self) {
                if (isAnimating) {
                    return;
                }
            }
            if (newPoint.y > oldPoint.y /* && (differenceFromStart) < 0*/){
                if(_mScrollView.isTracking && _mScrollView.isDragging /* && (abs(differenceFromLast)>1)*/ ){
                    @synchronized(self){
                        if(hidden)
                            return;
                    }
                    [self expand];
                }
            }
            else {
                if(_mScrollView.isTracking && _mScrollView.isDragging /* && (abs(differenceFromLast)>1) */){
                    @synchronized(self){
                        if(!hidden)
                            return;
                    }
                    [self contract];
                }
            }
        }
    }
}



#pragma mark Notifications
- (void)onWillEnterForegroundNotification:(NSNotification*)notification {
    [self contract];
}

#pragma mark -
#pragma mark UIBars
- (UINavigationController *)navigationController {
    if (!mNavigationController) {
        mNavigationController = _mViewController.navigationController;
    }
    return mNavigationController;
}

- (UINavigationBar *)navigationBar {
    return self.navigationController.navigationBar;
}
// 是否存在导航栏 且未被隐藏
- (BOOL)isNavigationBarExisting {
    UINavigationBar *navBar = self.navigationBar;
    return navBar && navBar.superview && !navBar.hidden && !self.navigationController.navigationBarHidden;
}

@end
