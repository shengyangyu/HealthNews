//
//  AFInterfaceAPIExcute.m
//  HealthNews
//
//  Created by yushengyang on 15/4/17.
//  Copyright (c) 2015年 yushengyang. All rights reserved.
//

#import "AFInterfaceAPIExcute.h"
#import "BaseResponse.h"
#import "AFRequestManager.h"

@implementation AFInterfaceAPIExcute
@synthesize delegate;
@synthesize mOperation;
@synthesize flagCommonApi;

- (id)initWithAPI:(NSString*)apiName retClass:(NSString*)retClass Params:(NSMutableDictionary *)params setDelegate:(id)thedelegate
{
    self = [super init];
    if (self) {
        m_apiName = apiName;
        m_retClass = retClass;
        m_params = params;
        
        self.delegate = thedelegate;
        _originalClass = object_getClass(thedelegate);
    }
    
    return self;
}



- (id)initWithAPI_GET:(NSString*)apiName retClass:(NSString*)retClass Params:(NSMutableDictionary *)params setDelegate:(id)thedelegate
{
    self = [super init];
    if (self) {
        m_apiName = apiName;
        m_retClass = retClass;
        m_params = params;
        
        self.delegate = thedelegate;
        _originalClass = object_getClass(thedelegate);
    }
    m_requestType = 1;
    return self;
}


-(void)excuteSuccess:(id)retObj
{
    Class currentClass = object_getClass(self.delegate);
    if (currentClass == _originalClass) {
        if ([delegate respondsToSelector:@selector(interfaceExcuteSuccess: apiName: apiFlag:)])
            [delegate interfaceExcuteSuccess:retObj apiName:m_apiName apiFlag:self.flagCommonApi];
    }
}

- (void)failWithError:(NSError *)error
{
    Class currentClass = object_getClass(self.delegate);
    if (currentClass == _originalClass) {
        if ([delegate respondsToSelector:@selector(interfaceExcuteError: apiName:  apiFlag:)])
            [delegate interfaceExcuteError:error apiName:m_apiName apiFlag:self.flagCommonApi];
    }
}

- (void)failWithErrorText:(NSString *)text
{
    NSError *error = [NSError errorWithDomain:@"errormessage" code:0 userInfo:[NSDictionary dictionaryWithObject:text forKey:NSLocalizedDescriptionKey]];
    
    [self failWithError:error];
}

- (void)backCall:(id)jsonObject
{
    HNBsae* retObj = (HNBsae*)jsonObject;
    
    NSLog(@"api=%@",m_apiName);
    
    if (retObj == nil) {
        [self failWithErrorText:@"数据为空"];
        return;
    }
    else if (!retObj.success || ![retObj.success boolValue]) {
        
        [self failWithErrorText:@"请求错误!"];
    }
    else{
        [self  excuteSuccess:jsonObject];
    }
}

// 不带returncode的网络回调处理
- (void)backCallNotReturnCode:(id)jsonObject
{
    HNBsae* retObj = (HNBsae*)jsonObject;
    
    if (retObj == nil) {
        [self failWithErrorText:@""];
        return;
    }
    
    [self  excuteSuccess:jsonObject];
}


-(void)beginRequest
{
    mOperation = [AFRequestManager httpRequest:m_apiName extraParams:m_params className:m_retClass object:self action:@selector(backCall:) operation:mOperation];
}

-(void)cancelRequest
{
    if (mOperation)
    {
        [mOperation cancel];
    }
}

// get请求方法
-(void)beginRequestWithUrl
{
    [AFRequestManager httpRequest:m_apiName className:m_retClass object:self action:@selector(backCallNotReturnCode:) operation:mOperation];
}


@end
