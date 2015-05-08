//
//  UleScrollView.h
//  HealthNews
//
//  Created by yushengyang on 15/5/8.
//  Copyright (c) 2015年 yushengyang. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 初始化滑动view的类型
 */
typedef enum : NSUInteger {
    UleScrollTable,
    UleScrollNormal,
} UleScrollType;
/**
 代理事件
 */
@protocol UleScrollDelegate <NSObject>

-(void)recievedUleScrollEvent;

@optional
-(void)recievedUleScrollButtonClicked;

@end


@interface UleScrollView : UIView<UIScrollViewDelegate, UleScrollDelegate>
/**
 初始化为列表
 */
- (UleScrollView *)initTableViewWithBackgound:(UIImage*)backgroundImage avatarImage:(UIImage *)avatarImage titleString:(NSString *)titleString subtitleString:(NSString *)subtitleString buttonTitle:(NSString *)buttonTitle;
/**
 初始化为普通的滑动view
 */
- (UleScrollView *)initScrollViewWithBackgound:(UIImage*)backgroundImage avatarImage:(UIImage *)avatarImage titleString:(NSString *)titleString subtitleString:(NSString *)subtitleString buttonTitle:(NSString *)buttonTitle contentHeight:(CGFloat)height;
/**
 刷新头的image
 */
-(void)updateHeaderImage:(UIImage*)mImage;
/**
 变量设置
 */
@property (strong, nonatomic) UIImageView *m_avatarImage;
@property (strong, nonatomic) UIView *m_header;
@property (strong, nonatomic) UILabel *m_headerLabel;
@property (strong, nonatomic) UIScrollView *m_scrollView;
@property (strong, nonatomic) UITableView *m_tableView;
@property (strong, nonatomic) UIImageView *m_headerImageView;
@property (strong, nonatomic) UIButton *m_headerButton;
@property (strong, nonatomic) UILabel *m_subtitleLabel;
@property (strong, nonatomic) UILabel *m_titleLabel;
@property (nonatomic, strong) NSMutableArray *m_blurImages;
@property (nonatomic, assign) id<UleScrollDelegate>delegate;

@end
