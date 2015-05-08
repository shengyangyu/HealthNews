//
//  UIViewController+UleHiddenNavi.m
//  PostLife_new
//
//  Created by yushengyang on 15/5/8.
//  Copyright (c) 2015年 ule. All rights reserved.
//

#import "UIViewController+UleHiddenNavi.h"
#import "JRSwizzle.h"
#import <objc/runtime.h>
#import "UleHiddenForScroller.h"

static const char __UleHiddenForScrollerKey;

@implementation UIViewController (UleHiddenNavi)

#pragma mark Accessors
- (UleHiddenForScroller*)mScroller {
    return objc_getAssociatedObject(self, &__UleHiddenForScrollerKey);
}

- (void)setMScroller:(UleHiddenForScroller *)mScroller {
    objc_setAssociatedObject(self, &__UleHiddenForScrollerKey, mScroller, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark -Swizzling
+ (void)load {
    [UIViewController jr_swizzleMethod:@selector(viewWillAppear:)
                            withMethod:@selector(UleScroll_viewWillAppear:)
                                 error:NULL];
    
    [UIViewController jr_swizzleMethod:@selector(viewDidAppear:)
                            withMethod:@selector(UleScroll_viewDidAppear:)
                                 error:NULL];
    
    [UIViewController jr_swizzleMethod:@selector(viewWillDisappear:)
                            withMethod:@selector(UleScroll_viewWillDisappear:)
                                 error:NULL];
    
    [UIViewController jr_swizzleMethod:@selector(viewDidDisappear:)
                            withMethod:@selector(UleScroll_viewDidDisappear:)
                                 error:NULL];
    
    [UIViewController jr_swizzleMethod:@selector(willRotateToInterfaceOrientation:duration:)
                            withMethod:@selector(UleScroll_willRotateToInterfaceOrientation:duration:)
                                 error:NULL];
}

- (void)UleScroll_viewWillAppear:(BOOL)animated {
    [self UleScroll_viewWillAppear:animated];
    [self.mScroller viewWillAppear:animated];
}

- (void)UleScroll_viewDidAppear:(BOOL)animated {
    [self UleScroll_viewDidAppear:animated];
    [self.mScroller viewDidAppear:animated];
}

- (void)UleScroll_viewWillDisappear:(BOOL)animated {
    [self UleScroll_viewWillDisappear:animated];
    [self.mScroller viewWillDisappear:animated];
}

- (void)UleScroll_viewDidDisappear:(BOOL)animated {
    [self UleScroll_viewDidDisappear:animated];
    [self.mScroller viewDidDisappear:animated];
}

- (void)UleScroll_willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self UleScroll_willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self.mScroller willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}


@end
