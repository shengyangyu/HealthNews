//
//  AFInterfaceAPIExcute.h
//  HealthNews
//
//  Created by yushengyang on 15/4/17.
//  Copyright (c) 2015年 yushengyang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFRequestManager.h"
Class object_getClass(id object);

@protocol AFInterfaceAPIDelegate <NSObject>
@optional

-(void) interfaceExcuteError:(NSError*)error apiName:(NSString*)ApiName apiFlag:(NSString*) ApiFlag;
-(void) interfaceExcuteSuccess:(id)retObj apiName:(NSString*)ApiName apiFlag:(NSString*) ApiFlag;

@end

@interface AFInterfaceAPIExcute : NSObject
{
    NSString*  m_apiName;
    NSString*  m_retClass;
    NSInteger m_requestType;
    
    NSMutableDictionary* m_params;
    AFHTTPRequestOperation* mOperation;
    
    Class _originalClass;
    __unsafe_unretained id<AFInterfaceAPIDelegate>   delegate;
}

@property   (nonatomic,strong)  NSString *flagCommonApi;//--用于一个页面请求相同API时标记
@property   (nonatomic,strong)  AFHTTPRequestOperation* mOperation;
@property   (nonatomic,assign)  id<AFInterfaceAPIDelegate> delegate;

- (id)initWithAPI:(NSString*)apiName retClass:(NSString*)retClass  Params:(NSMutableDictionary *)params setDelegate:(id)thedelegate;

- (id)initWithAPI_GET:(NSString*)apiName retClass:(NSString*)retClass Params:(NSMutableDictionary *)params setDelegate:(id)thedelegate;

-(void)beginRequest;
-(void)cancelRequest;
// get请求方法
-(void)beginRequestWithUrl;

@end
