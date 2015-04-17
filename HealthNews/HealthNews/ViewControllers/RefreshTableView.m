//
//  RefreshTableView.m
//  HealthNews
//
//  Created by yushengyang on 15/4/17.
//  Copyright (c) 2015年 yushengyang. All rights reserved.
//

#import "RefreshTableView.h"

@implementation RefreshTableView
#pragma marktableView类型初始化
- (id)initWithFrame:(CGRect)frame
          withStyle:(UITableViewStyle)style
           withType:(ULETableViewType)type {
    
    self = [super initWithFrame:frame style:style];
    _viewType = type;
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        switch (_viewType) {
            case ULE_TableViewTypeNone:
            {
                break;
            }
                // 1.下拉刷新
            case ULE_TableViewTypeHeader:
            {
                [self addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
                break;
            }
                // 2.上拉加载更多
            case ULE_TableViewTypeFooter:
            {
                [self addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
                break;
            }
                // 2.都包含
            case ULE_TableViewTypeAll:
            {
                [self addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
                [self addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
                break;
            }
            default:
                break;
        }
    }
    return self;
}

- (void)reSetMethod
{
    [self.footer setRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    [self.footer resetNoMoreData];
}

#pragma mark -清除加载动画

- (void)stopAnimationHeaderAndFooter
{
    [self.header endRefreshing];
    [self.footer endRefreshing];
}

#pragma mark-键盘处理

- (void)setup {
    _priorInsetSaved = NO;
    if ( CGSizeEqualToSize(self.contentSize, CGSizeZero) ) {
        self.contentSize = self.bounds.size;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)setContentSize:(CGSize)contentSize {
    _originalContentSize = contentSize;
    
    contentSize.width = MAX(contentSize.width, self.frame.size.width);
    contentSize.height = MAX(contentSize.height, self.frame.size.height);
    [super setContentSize:contentSize];
    
    if ( _keyboardVisible ) {
        self.contentInset = [self contentInsetForKeyboard];
    }
}

- (void)keyboardWillShow:(NSNotification*)notification {
    _keyboardRect = [[[notification userInfo] objectForKey:_UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _keyboardVisible = YES;
    
    UIView *firstResponder = [self findFirstResponderBeneathView:self];
    if ( !firstResponder ) {
        // No child view is the first responder - nothing to do here
        return;
    }
    
    if (!_priorInsetSaved) {
        _priorInset = self.contentInset;
        _priorInsetSaved = YES;
    }
    
    // Shrink view's inset by the keyboard's height, and scroll to show the text field/view being edited
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:[[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
    [UIView setAnimationDuration:[[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]];
    
    self.contentInset = [self contentInsetForKeyboard];
    [self setContentOffset:CGPointMake(self.contentOffset.x,
                                       [self idealOffsetForView:firstResponder withSpace:[self keyboardRect].origin.y - self.bounds.origin.y])
                  animated:YES];
    
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification*)notification {
    
    _keyboardRect = CGRectZero;
    _keyboardVisible = NO;
    // Restore dimensions to prior size
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:[[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
    [UIView setAnimationDuration:[[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]];
    self.contentInset = _priorInset;
    _priorInsetSaved = NO;
    [UIView commitAnimations];
}

- (UIView*)findFirstResponderBeneathView:(UIView*)view {
    // Search recursively for first responder
    for (UIView *childView in view.subviews) {
        if ([childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder] ){
            return childView;
        }
        UIView *result = [self findFirstResponderBeneathView:childView];
        if (result){
            return result;
        }
    }
    return nil;
}

- (CGRect)keyboardRect {
    
    CGRect keyboardRect = [self convertRect:_keyboardRect fromView:nil];
    if ( keyboardRect.origin.y == 0 ) {
        CGRect screenBounds = [self convertRect:[UIScreen mainScreen].bounds fromView:nil];
        keyboardRect.origin = CGPointMake(0, screenBounds.size.height - keyboardRect.size.height);
    }
    return keyboardRect;
}

-(CGFloat)idealOffsetForView:(UIView *)view withSpace:(CGFloat)space {
    
    // Convert the rect to get the view's distance from the top of the scrollView.
    CGRect rect = [view convertRect:view.bounds toView:self];
    // Set starting offset to that pointonClickPayment
    CGFloat offset = rect.origin.y;
    
    if (self.contentSize.height - offset < space) {
        // Scroll to the bottom
        offset = self.contentSize.height - space;
    } else {
        if ( view.bounds.size.height < space ) {
            // Center vertically if there's room
            offset -= floor((space-view.bounds.size.height)/2.0);
        }
        if ( offset + space > self.contentSize.height ) {
            // Clamp to content size
            offset = self.contentSize.height - space;
        }
    }
    if (offset < 0) {
        offset = 0;
    }
    return offset;
}

- (UIEdgeInsets)contentInsetForKeyboard {
    
    UIEdgeInsets newInset = self.contentInset;
    CGRect keyboardRect = [self keyboardRect];
    newInset.bottom = keyboardRect.size.height - ((keyboardRect.origin.y+keyboardRect.size.height) - (self.bounds.origin.y+self.bounds.size.height));
    return newInset;
}

#pragma mark -触摸、单击代理
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    if ([self.touchDelegate conformsToProtocol:@protocol(CustomerTableViewDelegate)] &&
        [self.touchDelegate respondsToSelector:@selector(tableView:touchesBegan:withEvent:)]) {
        [self.touchDelegate tableView:self touchesBegan:touches withEvent:event];
    }
}


#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    if ([self.touchDelegate conformsToProtocol:@protocol(CustomerTableViewDelegate)] &&
        [self.touchDelegate respondsToSelector:@selector(tableViewHeaderRereshing: withCompletioned:)])
    {
        [self.touchDelegate tableViewHeaderRereshing:self withCompletioned:^() {
            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            [self.header endRefreshing];
        }];
    }
}

- (void)footerRereshing
{
    if ([self.touchDelegate conformsToProtocol:@protocol(CustomerTableViewDelegate)] &&
        [self.touchDelegate respondsToSelector:@selector(tableViewFooterRereshing: withCompletioned:)])
    {
        [self.touchDelegate tableViewFooterRereshing:self withCompletioned:^() {
            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            [self.footer endRefreshing];
        }];
    }
}

#pragma mark -加载完毕
- (void)reloadData:(BOOL)dataIsAllLoaded
{
    __weak __typeof(self)weakSelf = self;
    // 0.5秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf reloadData];
        weakSelf.contentInset = UIEdgeInsetsZero;
        [weakSelf stopAnimationHeaderAndFooter];
        //是否需要隐藏 上拉加载动画
        weakSelf.footer.hidden = dataIsAllLoaded;
    });
}

#pragma mark -

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
