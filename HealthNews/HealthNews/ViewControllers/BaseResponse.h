//
//  BaseResponse.h
//  HealthNews
//
//  Created by yushengyang on 15/4/17.
//  Copyright (c) 2015年 yushengyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionary+JSON.h"

//*****************资讯分类*****************//
/*
 *  资讯分类列表类
 */
@interface HNNewsListClass : NSObject
{
    NSString *success;
    NSString *total;
    NSMutableArray *yi18;
}

@property(nonatomic,retain) NSString *success;
@property(nonatomic,retain) NSString *total;
@property(nonatomic,retain) NSMutableArray *yi18;

@end

/*
 *  资讯分类列表详细类
 */
@interface HNNewsClass : NSObject
{
    NSString *name;
    NSString *mId;
}
@property(nonatomic,retain) NSString *name;
@property(nonatomic,retain) NSString *mId;

@end