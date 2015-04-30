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


//*****************健康知识*****************//
/*  公用
 *  健康知识信息类、健康知识信息详情类
 */
@interface HNReadDetail : NSObject
{
    NSString *title;
    NSString *loreclass;
    NSString *message;
    NSString *count;
    NSString *className;
    NSString *author;
    NSString *time;
    NSString *mId;
    NSString *img;
    NSString *fcount;
    NSString *rcount;
}
@property(nonatomic,retain) NSString *title;
@property(nonatomic,retain) NSString *loreclass;
@property(nonatomic,retain) NSString *message;
@property(nonatomic,retain) NSString *count;
@property(nonatomic,retain) NSString *className;
@property(nonatomic,retain) NSString *author;
@property(nonatomic,retain) NSString *time;
@property(nonatomic,retain) NSString *mId;
@property(nonatomic,retain) NSString *img;
@property(nonatomic,retain) NSString *fcount;
@property(nonatomic,retain) NSString *rcount;

@end

/*
 *  知识详情列表类
 */
@interface HNReadsList : NSObject
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
 *  知识详情类
 */
@interface HNReadDetailBase : NSObject
{
    NSString *success;
    HNReadDetail *yi18;
}

@property(nonatomic,retain) NSString *success;
@property(nonatomic,retain) HNReadDetail *yi18;

@end

//*****************食谱分类*****************//
/*
 *  食谱分类列表详细类
 */
@interface HNCookType : NSObject
{
    NSString *name;
    NSString *mId;
    NSString *cookclass;
}
@property(nonatomic,retain) NSString *name;
@property(nonatomic,retain) NSString *mId;
@property(nonatomic,retain) NSString *cookclass;

@end

/*
 *  食谱分类列表类
 */
@interface HNCookTypeList : NSObject
{
    NSString *success;
    NSMutableArray *yi18;
    NSString *total;
}
@property(nonatomic,retain) NSString *success;
@property(nonatomic,retain) NSMutableArray *yi18;
@property(nonatomic,retain) NSString *total;

@end

/*  公用
 *  食谱信息类、食谱信息详情类
 */
@interface HNCookDetailBase : NSObject
{
    NSString *name;
    NSString *img;
    NSString *tag;
    NSString *food;
    NSString *message;
    NSString *count;
    NSString *mId;
    NSString *fcount;
    NSString *rcount;
}
@property(nonatomic,retain) NSString *name;
@property(nonatomic,retain) NSString *img;
@property(nonatomic,retain) NSString *tag;
@property(nonatomic,retain) NSString *food;
@property(nonatomic,retain) NSString *message;
@property(nonatomic,retain) NSString *count;
@property(nonatomic,retain) NSString *mId;
@property(nonatomic,retain) NSString *fcount;
@property(nonatomic,retain) NSString *rcount;

@end

/*
 *  食谱详情类
 */
@interface HNCookDetail : NSObject
{
    NSString *success;
    HNCookDetailBase *yi18;
}

@property(nonatomic,retain) NSString *success;
@property(nonatomic,retain) HNCookDetailBase *yi18;

@end

/*
 *  食谱列表类
 */
@interface HNCookList : NSObject
{
    NSString *success;
    NSString *total;
    NSMutableArray *yi18;
}

@property(nonatomic,retain) NSString *success;
@property(nonatomic,retain) NSString *total;
@property(nonatomic,retain) NSMutableArray *yi18;

@end
