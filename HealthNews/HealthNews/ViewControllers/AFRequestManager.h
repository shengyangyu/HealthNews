//
//  AFRequestManager.h
//  HealthNews
//
//  Created by yushengyang on 15/4/17.
//  Copyright (c) 2015年 yushengyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

#define kServiceUrl @"api.yi18.net"
#define kMKNetworkKitRequestTimeOutInSeconds 30

#define SUPPRESS_PERFORM_SELECTOR_LEAK_WARNING(code)                    \
_Pragma("clang diagnostic push")                                        \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")     \
code;                                                                   \
_Pragma("clang diagnostic pop")                                         \


@interface AFRequestManager : NSObject

+ (id)decodeJsonStr:(NSString*)jsonStr withClsName:(NSString*)clsName;

+ (id)decodeJsonDic:(NSDictionary *)jsonDic withClsName:(NSString*)clsName;

+ (AFHTTPRequestOperation *)httpRequest:(NSString *)url extraParams:(NSMutableDictionary *)extraParams className:(NSString *)className object:(id)object action:(SEL)action operation:(AFHTTPRequestOperation*)op;

+ (void)httpRequest:(NSString *)url className:(NSString *)className object:(id)object action:(SEL)action operation:(AFHTTPRequestOperation*)op;

@end
