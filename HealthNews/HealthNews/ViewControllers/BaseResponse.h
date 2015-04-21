//
//  BaseResponse.h
//  HealthNews
//
//  Created by yushengyang on 15/4/17.
//  Copyright (c) 2015年 yushengyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionary+JSON.h"

//*****************base*****************//
/*
 *  资讯分类列表类
 */
@interface HNBsae : NSObject
{
    NSString *success;
    NSString *total;
    NSMutableArray *yi18;
}

@property(nonatomic,retain) NSString *success;
@property(nonatomic,retain) NSString *total;
@property(nonatomic,retain) NSMutableArray *yi18;

@end

//*****************资讯分类*****************//
/*
 *  资讯分类列表类
 */
@interface HNNewsTypeList : NSObject
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
@interface HNNewsType : NSObject
{
    NSString *name;
    NSString *mId;
}
@property(nonatomic,retain) NSString *name;
@property(nonatomic,retain) NSString *mId;

@end

//*****************资讯信息*****************//
/*
 *  资讯信息列表类
 */
@interface HNNewsList : NSObject
{
    NSString *success;
    NSString *total;
    NSMutableArray *yi18;
}

@property(nonatomic,retain) NSString *success;
@property(nonatomic,retain) NSString *total;
@property(nonatomic,retain) NSMutableArray *yi18;

@end

/*  公用
 *  资讯信息类、资讯信息详情类
 */
@interface HNNewsDetail : NSObject
{
    NSString *title;
    NSString *tag;
    NSString *message;
    NSString *count;
    NSString *fcount;
    NSString *rcount;
    NSString *author;
    NSString *focal;
    NSString *time;
    NSString *mId;
    NSString *img;
    NSString *md;
}
@property(nonatomic,retain) NSString *title;
@property(nonatomic,retain) NSString *tag;
@property(nonatomic,retain) NSString *message;
@property(nonatomic,retain) NSString *count;
@property(nonatomic,retain) NSString *fcount;
@property(nonatomic,retain) NSString *rcount;
@property(nonatomic,retain) NSString *author;
@property(nonatomic,retain) NSString *focal;
@property(nonatomic,retain) NSString *time;
@property(nonatomic,retain) NSString *mId;
@property(nonatomic,retain) NSString *img;
@property(nonatomic,retain) NSString *md;

@end

/*
 *  资讯详情类
 */
@interface HNNewsDetailBase : NSObject
{
    NSString *success;
    HNNewsDetail *yi18;
}

@property(nonatomic,retain) NSString *success;
@property(nonatomic,retain) HNNewsDetail *yi18;

@end
