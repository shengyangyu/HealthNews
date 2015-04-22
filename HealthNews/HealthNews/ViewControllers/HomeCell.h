//
//  HomeCell.h
//  HealthNews
//
//  Created by yushengyang on 15/4/22.
//  Copyright (c) 2015年 yushengyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"
#import "HNHeaderFile.h"

#define HC_Cell_height          80.0f
#define HC_Cell_Offset          10.0f
#define HC_Cell_Title_height    45.0f
#define HC_Cell_Text_height     20.0f

@interface HomeCell : UITableViewCell

// icon
@property (nonatomic, strong) UIImageView *mIconImg;
// title
@property (nonatomic, strong) UILabel *mTitleLab;
// time
@property (nonatomic, strong) UILabel *mTimeLab;

@end
