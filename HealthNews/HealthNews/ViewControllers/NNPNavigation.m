//
//  NNPNavigation.m
//  PostLife_new
//
//  Created by yushengyang on 15/4/16.
//  Copyright (c) 2015年 ule. All rights reserved.
//

#import "NNPNavigation.h"
#import <QuartzCore/QuartzCore.h>
#import <math.h>

@interface NNPNavigation ()<UIGestureRecognizerDelegate>
{
    CGPoint mStartTouch;
    UIImageView *mLastScreenShotView;
    UIView *mBlackMask;
}
@property (nonatomic,retain) UIView *mBackgroundView;
@property (nonatomic,retain) NSMutableArray *mScreenShotsList;
@property (nonatomic,assign) BOOL mIsMoving;
@property (nonatomic, strong) NSArray *cancelArrays;

@end

@implementation NNPNavigation

- (void)viewDidLoad {
    [super viewDidLoad];
    // 屏蔽掉iOS7以后自带的滑动返回手势
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    self.cancelArrays = @[@"MapViewShowHotelsViewController",
                          @"NearPostOfficeVC",
                          @"LogisticFirstViewController"];
    self.mScreenShotsList = [[NSMutableArray alloc]initWithCapacity:2];
    mFirstTouch = YES;
    
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(paningGestureReceive:)];
    recognizer.delegate = self;
    [recognizer delaysTouchesBegan];
    [self.view addGestureRecognizer:recognizer];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self.mScreenShotsList addObject:[self capture]];
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    [self.mScreenShotsList removeLastObject];
    return [super popViewControllerAnimated:animated];
}

#pragma mark - Utility Methods -

- (UIImage *)capture
{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

- (void)moveViewWithX:(CGFloat)x
{
    if (x < 0) {
        return;
    }
    float balpha = x < 0 ? -x : x;
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DMakeTranslation(x, 0, 0);
    [self.view.layer setTransform:transform];
    float alpha = 0.4 - (balpha/800);
    mBlackMask.alpha = alpha;
    
}

#pragma mark - Gesture Recognizer -

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    /**
     *  地图、不需要支持动画
     */
    @try {
        NSString *mClass = NSStringFromClass([self.topViewController class]);
        if ([self.cancelArrays containsObject:mClass]) {
            return NO;
        }
    }
    @catch (NSException *exception) {
    }
    return YES;
}

- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer
{
    // rootView 不需要手势支持
    if (self.viewControllers.count <= 1) {
        return;
    }

    CGPoint touchPoint = [recoginzer locationInView:NNPKEY_WINDOW];
    if (recoginzer.state == UIGestureRecognizerStateBegan) {
    
        // 设置锚点
        if (mFirstTouch) {
            CALayer *layer = [self.view layer];
            CGPoint oldAnchorPoint = layer.anchorPoint;
            [layer setAnchorPoint:CGPointMake(0.5, 1.0)];
            [layer setPosition:CGPointMake(layer.position.x + layer.bounds.size.width * (layer.anchorPoint.x - oldAnchorPoint.x), layer.position.y + layer.bounds.size.height * (layer.anchorPoint.y - oldAnchorPoint.y))];
            mFirstTouch = NO;
        }
        _mIsMoving = YES;
        mStartTouch = touchPoint;
        CGRect frame = [UIScreen mainScreen].bounds;
        
        [self.mBackgroundView removeFromSuperview];
        self.mBackgroundView = nil;
        // 初始化
        if (!self.mBackgroundView) {
            self.mBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            [self.view.superview insertSubview:self.mBackgroundView belowSubview:self.view];
            // 灰色背景
            mBlackMask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            mBlackMask.backgroundColor = [UIColor blackColor];
            [self.mBackgroundView addSubview:mBlackMask];
       }
        
        self.mBackgroundView.hidden = NO;
        // 顶部VC 截图
        if (mLastScreenShotView)
            [mLastScreenShotView removeFromSuperview];
        @try {
            UIImage *lastScreenShot = [self.mScreenShotsList lastObject];
            mLastScreenShotView = [[UIImageView alloc]initWithImage:lastScreenShot];
            [mLastScreenShotView setFrame:frame];
            [self.mBackgroundView insertSubview:mLastScreenShotView belowSubview:mBlackMask];
        }
        @catch (NSException *exception) {
        }
        
    }else if (recoginzer.state == UIGestureRecognizerStateEnded){
        
        if (touchPoint.x - mStartTouch.x > NNPViewWidth/2)
        {
            [self popMethod];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:0];
            } completion:^(BOOL finished) {
                _mIsMoving = NO;
                self.mBackgroundView.hidden = YES;
            }];
        }
        return;
        
    }else if (recoginzer.state == UIGestureRecognizerStateCancelled){
        
        [UIView animateWithDuration:0.3 animations:^{
            [self moveViewWithX:0];
        } completion:^(BOOL finished) {
            _mIsMoving = NO;
            self.mBackgroundView.hidden = YES;
        }];
        
        return;
    }
    if (_mIsMoving) {
        [self moveViewWithX:touchPoint.x - mStartTouch.x];
    }
}

- (void)popMethod
{
    [UIView animateWithDuration:0.4 animations:^{
        [self moveViewWithX:NNPViewWidth*2];
        CGRect frame = self.view.bounds;
        frame.origin.x = NNPViewWidth;
        [self.view setFrame:frame];
    } completion:^(BOOL finished){
        [self popViewControllerAnimated:NO];
        CATransform3D transform = CATransform3DIdentity;
        [self.view.layer setTransform:transform];
        CGRect frame = [UIScreen mainScreen].bounds;
        frame.origin.x = 0;
        self.view.frame = frame;
        _mIsMoving = NO;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc
{
    self.mScreenShotsList = nil;
    self.mBackgroundView = nil;
    [self.mBackgroundView removeFromSuperview];
}

@end
