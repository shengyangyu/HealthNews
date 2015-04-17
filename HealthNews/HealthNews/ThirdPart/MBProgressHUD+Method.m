//
//  MBProgressHUD+Method.m
//  HealthNews
//
//  Created by yushengyang on 15/4/17.
//  Copyright (c) 2015年 yushengyang. All rights reserved.
//

#import "MBProgressHUD+Method.h"

@implementation MBProgressHUD (Method)

- (void)hide:(BOOL)animated afterDelay:(NSTimeInterval)delay dothing:(BOOL)b {
    [self performSelector:@selector(dohideDelayed:) withObject:[NSNumber numberWithBool:animated] afterDelay:delay];
}

@end
