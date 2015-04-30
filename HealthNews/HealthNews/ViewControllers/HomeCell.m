//
//  HomeCell.m
//  HealthNews
//
//  Created by yushengyang on 15/4/22.
//  Copyright (c) 2015年 yushengyang. All rights reserved.
//

#import "HomeCell.h"

@implementation HomeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self loadView];
    }
    return self;
}

- (void)loadView
{
    self.mIconImg = ({
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(HC_Cell_Offset, HC_Cell_Offset, HC_Cell_height, HC_Cell_height-2*HC_Cell_Offset)];
        img.clipsToBounds = YES;
        img.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:img];
        img;
    });
    self.mTitleLab = ({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(2*HC_Cell_Offset+HC_Cell_height, HC_Cell_Offset, __MainScreen_Width-(2*HC_Cell_Offset+HC_Cell_height), HC_Cell_Title_height)];
        label.font = [UIFont systemFontOfSize:15];
        label.numberOfLines = 2;
        label.textColor = [UIColor convertHexToRGB:@"171717"];
        [self addSubview:label];
        label;
    });
    self.mTimeLab = ({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, HC_Cell_height-HC_Cell_Text_height-HC_Cell_Offset, __MainScreen_Width-HC_Cell_Offset, HC_Cell_Text_height)];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor convertHexToRGB:@"A6A6A6"];
        label.textAlignment = NSTextAlignmentRight;
        [self addSubview:label];
        label;
    });
    ({
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, HC_Cell_height-1, __MainScreen_Width, 0.5)];
        line.image = [UIImage imageNamed:@"cell_dotline"];
        [self addSubview:line];
    });
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
