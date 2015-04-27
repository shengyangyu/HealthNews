//
//  RefreshTableView.h
//  HealthNews
//
//  Created by yushengyang on 15/4/17.
//  Copyright (c) 2015年 yushengyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

// 获取键盘大小
#define _UIKeyboardFrameEndUserInfoKey (&UIKeyboardFrameEndUserInfoKey != NULL ? UIKeyboardFrameEndUserInfoKey : @"UIKeyboardBoundsUserInfoKey")

/**
 ULETableViewType:列表类型
 None:无
 Header:带头部
 Footer:带底部
 All:带所有
 */
typedef NS_ENUM(NSInteger,  ULETableViewType) {
    ULE_TableViewTypeNone,
    ULE_TableViewTypeHeader,
    ULE_TableViewTypeFooter,
    ULE_TableViewTypeAll
};

@protocol CustomerTableViewDelegate <NSObject>
@optional
- (void)tableView:(UITableView *)tableView touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)tableViewHeaderRereshing:(UITableView *)tableView withCompletioned:(void (^)())completioned;
- (void)tableViewFooterRereshing:(UITableView *)tableView withCompletioned:(void (^)())completioned;
@end

@interface RefreshTableView : UITableView
{
    ULETableViewType    _viewType;              //TableView类型
    UIEdgeInsets        _priorInset;            //之前inset
    BOOL                _priorInsetSaved;       //之前inset是否被保存
    BOOL                _keyboardVisible;       //键盘是否有效
    CGRect              _keyboardRect;          //键盘frame
    CGSize              _originalContentSize;   //初始ContentSize
}

@property (nonatomic,assign) id<CustomerTableViewDelegate> touchDelegate;
@property (nonatomic,retain) NSMutableArray *mInfoArray;
/**
 *  tableView类型初始化
 */
- (id)initWithFrame:(CGRect)frame
          withStyle:(UITableViewStyle)style
           withType:(ULETableViewType)type;

/**
 *  清除加载动画
 */
- (void)stopAnimationHeaderAndFooter;

/**
 *  刷新表视图数据
 *  dataIsAllLoaded 标识数据是否已全部加载（即“上拖加载更多”是否可用）
 **/
- (void)reloadData:(BOOL)dataIsAllLoaded;

/**
 *  键盘处理
 */
- (void)setup;
- (UIView*)findFirstResponderBeneathView:(UIView*)view;
- (UIEdgeInsets)contentInsetForKeyboard;
- (CGFloat)idealOffsetForView:(UIView *)view withSpace:(CGFloat)space;
- (CGRect)keyboardRect;

@end
