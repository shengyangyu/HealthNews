//
//  NNPNavigation.h
//  PostLife_new
//
//  Created by yushengyang on 15/4/16.
//  Copyright (c) 2015年 ule. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NNPKEY_WINDOW       [[UIApplication sharedApplication]keyWindow]
#define NNPViewHeight       [UIScreen mainScreen].bounds.size.height
#define NNPViewWidth        [UIScreen mainScreen].bounds.size.width

@interface NNPNavigation : UINavigationController
{
    BOOL mFirstTouch;
}

@end
