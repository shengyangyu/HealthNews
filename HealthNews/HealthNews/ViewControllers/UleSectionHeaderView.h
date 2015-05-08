//
//  UleSectionHeaderView.h
//  HealthNews
//
//  Created by yushengyang on 15/5/8.
//  Copyright (c) 2015年 yushengyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UleSectionHeaderView : UIView
@property NSUInteger section;
@property (nonatomic, weak) UITableView *tableView;
@end