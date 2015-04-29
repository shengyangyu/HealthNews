//
//  ReadViewController.h
//  HealthNews
//
//  Created by yushengyang on 15/4/17.
//  Copyright (c) 2015年 yushengyang. All rights reserved.
//

#import "BaseViewController.h"

@interface ReadViewController : BaseViewController

@end


@interface YSYSectionHeaderView : UIView
@property NSUInteger section;
@property (nonatomic, weak) UITableView *tableView;
@end



