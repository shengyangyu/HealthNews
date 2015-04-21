//
//  BaseResponse.m
//  HealthNews
//
//  Created by yushengyang on 15/4/17.
//  Copyright (c) 2015年 yushengyang. All rights reserved.
//

#import "BaseResponse.h"

@implementation HNBsae
@synthesize success,
total,
yi18;

@end

@implementation HNNewsTypeList
@synthesize success,
total,
yi18;

- (NSMutableArray *)yi18
{
    for (int i = 0; i < yi18.count; i++) {
        if([[yi18 objectAtIndex:i] class] != [HNNewsType class]) {
            NSDictionary * _dic = (NSDictionary *)[yi18 objectAtIndex:i];
            [yi18 replaceObjectAtIndex:i withObject:[_dic dictionaryTo:NSClassFromString(@"HNNewsType")]];
        }
    }
    return yi18;
}

@end


@implementation HNNewsType
@synthesize name,
            mId;
@end


@implementation HNNewsList
@synthesize success,
total,
yi18;

- (NSMutableArray *)yi18
{
    for (int i = 0; i < yi18.count; i++) {
        if([[yi18 objectAtIndex:i] class] != [HNNews class]) {
            NSDictionary * _dic = (NSDictionary *)[yi18 objectAtIndex:i];
            [yi18 replaceObjectAtIndex:i withObject:[_dic dictionaryTo:NSClassFromString(@"HNNews")]];
        }
    }
    return yi18;
}

@end

@implementation HNNews

@synthesize title,
tag,
count,
fcount,
rcount,
author,
focal,
md,
time,
mId;

@end
