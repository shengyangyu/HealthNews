//
//  AFRequestManager.m
//  HealthNews
//
//  Created by yushengyang on 15/4/17.
//  Copyright (c) 2015年 yushengyang. All rights reserved.
//

#import "AFRequestManager.h"
#import "JSONKit.h"
#import "NSDictionary+JSON.h"
#import "NSString+HXAddtions.h"

@implementation AFRequestManager

static NSMutableArray *infoArray;
/*
 JSON 解析函数
 param: clsName为解析后，所要得到的class类型名
 */
+(id)decodeJsonStr:(NSString*)jsonStr withClsName:(NSString*)clsName
{
    NSDictionary* dic = nil;
    //NSLog(@"json--->%@",jsonStr);
    double version = [[UIDevice currentDevice].systemVersion doubleValue];//判定系统版本。
    if(version >= 5.0f){
        NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError *error = nil;
        
        dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
    }
    else
    {
        dic = [jsonStr objectFromJSONString];
    }
    
    Class retClass = NSClassFromString(clsName);
    
    retClass = [dic dictionaryTo:retClass];
    return retClass;
}

/*
 JSON 解析函数
 param: clsName为解析后，所要得到的class类型名
 */
+(id)decodeJsonDic:(NSDictionary *)jsonDic withClsName:(NSString*)clsName
{
    Class retClass = NSClassFromString(clsName);
    retClass = [jsonDic dictionaryTo:retClass];
    return retClass;
}

/*
 JSON 解析函数
 param: clsName为解析后，所要得到的class类型名。不带returncode的，为做表情特殊处理的
 */
+(id)decodeJsonStrNotReturnCode:(NSString*)jsonStr withClsName:(NSString*)clsName
{
    NSDictionary* dic = nil;
    //NSLog(@"json--->%@",jsonStr);
    double version = [[UIDevice currentDevice].systemVersion doubleValue];//判定系统版本。
    if(version >= 5.0f){
        NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError *error = nil;
        
        dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves  error:&error];
    }
    else
    {
        dic = [jsonStr objectFromJSONString];
    }
    
    Class retClass = NSClassFromString(clsName);
    
    retClass = [dic dictionaryTo:retClass];
    return retClass;
}


/*
 Http请求函数
 param: url         --API名
 param: extraParams --API请求参数
 param: className   --JSON解析后，所要得到的class类型名
 param: object      --调用的界面句柄
 param: action      --回调函数方法
 param: op          --请求操作
 */
+(AFHTTPRequestOperation *)httpRequest:(NSString *)url
                           extraParams:(NSMutableDictionary *)extraParams
                             className:(NSString *)className
                                object:(id)object
                                action:(SEL)action
                             operation:(AFHTTPRequestOperation*)op
{
    
    AFHTTPRequestOperationManager* client = [AFHTTPRequestOperationManager manager];
    client.requestSerializer.timeoutInterval = kMKNetworkKitRequestTimeOutInSeconds;
    client.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    /*
    NSMutableDictionary *dic=[Ule_MemoryData commonParam:AFNETWORK_ENGINE_DIC];
    [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {[client.requestSerializer setValue:obj forHTTPHeaderField:key];}];
    [client.requestSerializer setValue:[uleUserUtility userToken] forHTTPHeaderField:(NSString *)HEAD_KEY_USERTOKEN];
    [client.requestSerializer setValue:[uleUserUtility uuid] forHTTPHeaderField:(NSString *)HEAD_KEY_UUID];
    */
    NSString *urlString = [NSString stringWithFormat:@"http://%@/%@",kServiceUrl,url];
    // 为了防止循环引用object＋1设置的
    __weak id _object = object;
    op = [client POST:urlString parameters:extraParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *tmpJason = [NSString jsonStringWithObject:responseObject];
        SEL failedMethod = NSSelectorFromString(@"failWithErrorText:");
        if (tmpJason == nil && [_object respondsToSelector:failedMethod]) {
            SUPPRESS_PERFORM_SELECTOR_LEAK_WARNING([_object performSelector:failedMethod withObject:@"返回数据为空"]; return; );
        }
        if ([_object respondsToSelector:action]) {
            SUPPRESS_PERFORM_SELECTOR_LEAK_WARNING([_object performSelector:action withObject:[AFRequestManager decodeJsonStr:tmpJason withClsName:className]];);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        SEL failedMethod = NSSelectorFromString(@"failWithErrorText:");
        if ([_object respondsToSelector:failedMethod]) {
            SUPPRESS_PERFORM_SELECTOR_LEAK_WARNING( [_object performSelector:failedMethod withObject:@"请求异常"]; return ; );
        }
    }];
    
    return op;
}


/*
 Http请求函数:不需要传递参数，获取表情需要  by yuki
 */
+(void)httpRequest:(NSString *)url
         className:(NSString *)className
            object:(id)object action:(SEL)action
         operation:(AFHTTPRequestOperation*)op
{
    
    AFHTTPRequestOperationManager* client = [AFHTTPRequestOperationManager manager];
    client.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    /*
    NSMutableDictionary *dic=[Ule_MemoryData commonParam:AFNETWORK_ENGINE_DIC];
    [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {[client.requestSerializer setValue:obj forHTTPHeaderField:key];}];
    [client.requestSerializer setValue:[uleUserUtility userToken] forHTTPHeaderField:(NSString *)HEAD_KEY_USERTOKEN];
    [client.requestSerializer setValue:[uleUserUtility uuid] forHTTPHeaderField:(NSString *)HEAD_KEY_UUID];
    if (![[uleUserUtility userToken] isEqualToString:@""] && [uleUserUtility userToken] != nil) {
        [client.requestSerializer setValue:[uleUserUtility userToken] forHTTPHeaderField:(NSString *)HEAD_KEY_USERTOKEN];
    }else
        [client.requestSerializer setValue:@"" forKey:(NSString *)HEAD_KEY_USERTOKEN];
    
    if (![[uleUserUtility uuid] isEqualToString:@""] && [uleUserUtility uuid] != nil) {
        [client.requestSerializer setValue:[uleUserUtility uuid] forHTTPHeaderField:(NSString *)HEAD_KEY_UUID];
    }else
        [client.requestSerializer setValue:@"" forHTTPHeaderField:(NSString *)HEAD_KEY_UUID];
    */
    NSString *urlString = [NSString stringWithFormat:@"http://%@/%@",kServiceUrl,url];
    op = [client GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
            NSString *tmpJason = [NSString jsonStringWithObject:responseObject];
            SEL failedMethod = NSSelectorFromString(@"failWithErrorText:");
            if (tmpJason == nil && [object respondsToSelector:failedMethod]) {
                SUPPRESS_PERFORM_SELECTOR_LEAK_WARNING([object performSelector:failedMethod withObject:@"数据为空"];);
            }
            if([object respondsToSelector:action]){
                SUPPRESS_PERFORM_SELECTOR_LEAK_WARNING([object performSelector:action withObject:[AFRequestManager decodeJsonStr:tmpJason withClsName:className]];);
            }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              SEL failedMethod = NSSelectorFromString(@"failWithErrorText:");
              SUPPRESS_PERFORM_SELECTOR_LEAK_WARNING([object performSelector:failedMethod withObject:@"请求异常"];);
    }];
}


#pragma mark -
#pragma mark - 解析数据结构

+ (void)describeDictionary:(NSDictionary *)dict ClassName:(NSString *)classname count:(int)icount
{
    NSArray *keys;
    int i,count;
    id key,value;
    
    keys = [dict allKeys];
    count = [keys count];
    for (i = 0; i < count; i++) {
        key = [keys objectAtIndex:i];
        value = [dict objectForKey:key];
        [self checkType:value ClassName:classname fieldName:key count:icount];
    }
}

+ (void)checkType:(id)input ClassName:(NSString *)classname fieldName:(id)field count:(int)icount
{
    if ([[NSString stringWithFormat:@"%@",[input class]] isEqualToString:@"__NSCFString"]) {
        [infoArray addObject:[self formateDicWithName:[NSString stringWithFormat:@"%d",icount] ClassName:[self stringCompare:classname] Type:@"NSString" FieldName:field]];
    }
    else if ([[NSString stringWithFormat:@"%@",[input class]] isEqualToString:@"__NSCFNumber"]){
        [infoArray addObject:[self formateDicWithName:[NSString stringWithFormat:@"%d",icount] ClassName:[self stringCompare:classname] Type:@"NSInteger" FieldName:field]];
    }
    else if ([[NSString stringWithFormat:@"%@",[input class]] isEqualToString:@"JKDictionary"]){
        [infoArray addObject:[self formateDicWithName:[NSString stringWithFormat:@"%d",icount] ClassName:[self stringCompare:classname] Type:[NSString stringWithFormat:@"Ule_%@",field] FieldName:[NSString stringWithFormat:@"%@",field]]];
        
        [self describeDictionary:input ClassName:field count:icount+1];
    }
    else if ([[NSString stringWithFormat:@"%@",[input class]] isEqualToString:@"JKArray"]){
        [infoArray addObject:[self formateDicWithName:[NSString stringWithFormat:@"%d",icount] ClassName:[self stringCompare:classname] Type:@"NSMutableArray" FieldName:[NSString stringWithFormat:@"%@",field]]];
        
        for (NSDictionary *__dic in input) {
            [self describeDictionary:__dic ClassName:field count:icount+1];
            break;
        }
    }else if ([[NSString stringWithFormat:@"%@",[input class]] isEqualToString:@"__NSArrayM"]){
        [infoArray addObject:[self formateDicWithName:[NSString stringWithFormat:@"%d",icount] ClassName:[self stringCompare:classname] Type:@"NSMutableArray" FieldName:[NSString stringWithFormat:@"%@",field]]];
        
        for (NSDictionary *__dic in input) {
            [self describeDictionary:__dic ClassName:field count:icount+1];
            break;
        }
    }
    
    else{
        [infoArray addObject:[self formateDicWithName:[NSString stringWithFormat:@"%d",icount] ClassName:[self stringCompare:classname] Type:@"NSString" FieldName:field]];
    }
}

// 对字段的封装
+ (NSDictionary *)formateDicWithName:(NSString *)index ClassName:(NSString *)calssname Type:(NSString *)type FieldName:(NSString *)fieldname
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            index, @"index",
            calssname, @"classname",
            type, @"type",
            fieldname, @"fieldname",nil];
}

// 实现排序
+ (NSMutableArray *)formateDicWithSequence:(NSMutableArray *)result
{
    NSSortDescriptor *sortByDic = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:NO];
    [result sortUsingDescriptors:[NSArray arrayWithObject:sortByDic]];
    
    return result;
}

// 将url解析为 类名
+ (NSString *)formateComponents:(NSString *)input
{
    if (input.length > 0) {
        NSArray *arr = [input componentsSeparatedByString:@"/"];
        if (arr.count > 0) {
            NSString *strString = [arr objectAtIndex:arr.count-1];
            NSArray *newArr = [strString componentsSeparatedByString:@"."];
            if (newArr.count > 0) {
                return [newArr objectAtIndex:0];
            }
            else
                return input;
        }
        else
            return input;
    }
    
    return @"";
}

+ (NSString*)stringCompare:(NSString*)input
{
    if (input.length < 4) {
        return [NSString stringWithFormat:@"Ule_%@",input];
    }
    else if([[input substringToIndex:4] isEqualToString:@"Ule_"]){
        return input;
    }
    else
    {
        return [NSString stringWithFormat:@"Ule_%@",input];
    }
}

@end
