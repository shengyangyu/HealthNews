//
//  UleSectionHeaderView.m
//  HealthNews
//
//  Created by yushengyang on 15/5/8.
//  Copyright (c) 2015年 yushengyang. All rights reserved.
//

#import "UleSectionHeaderView.h"

@implementation UleSectionHeaderView
- (void)setFrame:(CGRect)frame {
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    CGRect sectionRect = [self.tableView rectForSection:self.section];
    CGRect newFrame = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(sectionRect), CGRectGetWidth(frame), CGRectGetHeight(frame));
    [super setFrame:newFrame];
    
}
@end