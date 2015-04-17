//
//  BaseResponse.h
//  HealthNews
//
//  Created by yushengyang on 15/4/17.
//  Copyright (c) 2015年 yushengyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseResponse : NSObject
{
    NSString *success;
    NSString *total;
    NSString *yi18;
}

@property(nonatomic,retain) NSString *success;
@property(nonatomic,retain) NSString *total;
@property(nonatomic,retain) NSString *yi18;

@end
