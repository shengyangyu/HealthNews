//
//  BaseResponse.m
//  HealthNews
//
//  Created by yushengyang on 15/4/17.
//  Copyright (c) 2015年 yushengyang. All rights reserved.
//

#import "BaseResponse.h"

@implementation HNNewsListClass
@synthesize success,
            total,
            yi18;

- (NSMutableArray *)yi18
{
    for (int i = 0; i < yi18.count; i++) {
        if([[yi18 objectAtIndex:i] class] != [HNNewsClass class]) {
            NSDictionary * _dic = (NSDictionary *)[yi18 objectAtIndex:i];
            [yi18 replaceObjectAtIndex:i withObject:[_dic dictionaryTo:NSClassFromString(@"HNNewsClass")]];
        }
    }
    return yi18;
}

@end


@implementation HNNewsClass
@synthesize name,
            mId;
@end