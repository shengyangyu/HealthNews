//
//  ScrollPageView.h
//  ShowProduct
//
//  Created by lin on 14-5-23.
//  Copyright (c) 2014年 @"". All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNHeaderFile.h"
#import "SPTableView.h"

@class HomeViewController;
@protocol ScrollPageViewDelegate <NSObject>
@optional
-(void)didScrollPageViewChangedPage:(NSInteger)aPage;
@end

@interface ScrollPageView : UIView<UIScrollViewDelegate,UITableViewDataSource,
UITableViewDelegate,SGFocusImageFrameDelegate>
{
    NSInteger mCurrentPage;
    BOOL mNeedUseDelegate;
}
@property (nonatomic,retain) UIScrollView *scrollView;
@property (nonatomic,retain) NSMutableArray *contentItems;
@property (nonatomic,assign) id<ScrollPageViewDelegate> delegate;
@property (nonatomic,retain) HomeViewController *supVC;
@property (nonatomic,retain) NSMutableArray *typeArray;

#pragma mark 添加ScrollowViewd的ContentView
-(void)setContentOfTables:(NSInteger)aNumerOfTables;
#pragma mark 滑动到某个页面
-(void)moveScrollowViewAthIndex:(NSInteger)aIndex;
#pragma mark 刷新某个页面
-(void)freshContentTableAtIndex:(NSInteger)aIndex;

@end
