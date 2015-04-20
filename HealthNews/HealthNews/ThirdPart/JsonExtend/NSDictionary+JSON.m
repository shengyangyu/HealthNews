//
//  NSDictionary+JSON.m
//  JSONTest
//
//  Created by Jay on 1/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSDictionary+JSON.h"

@implementation NSDictionary (JSON)

- (id) dictionaryTo:(Class) responseType
{
    id object = [[responseType alloc]init];
    
    u_int count;
    Ivar* ivars = class_copyIvarList(responseType, &count);
    for (int i = 0; i < count ; i++)
    {
        // get variable's name and type
        const char* ivarCName = ivar_getName(ivars[i]);
        const char* ivarCType = ivar_getTypeEncoding(ivars[i]);
        
        // convert to NSString
        NSString *ivarName = [NSString stringWithCString:ivarCName encoding:NSUTF8StringEncoding];
        NSString *ivarType = [NSString stringWithCString:ivarCType encoding:NSUTF8StringEncoding];
        
        id value = [self valueForKey:[ivarName isEqualToString:@"mId"] ? @"id" : ivarName];
        
        if([value isKindOfClass:[NSString class]] ||
           [value isKindOfClass:[NSNumber class]] ||
           value == nil);
            // do nothing converting.
        else if([value isKindOfClass:[NSNull class]])
            value = nil;
        else if([value isKindOfClass:[NSArray class]] )
        {
            Class genericClass = [[responseType getGenericType] valueForKey:ivarName];
            value = [(NSArray *)value dictionaryArrayToArray:genericClass];
        }
            
        else if([value isKindOfClass:[NSDictionary class]] )
        {
            // convert to NSDictionary
            value = (NSDictionary *)value;
            ivarType = [ivarType stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            ivarType = [ivarType stringByReplacingOccurrencesOfString:@"@" withString:@""];
            value = [value dictionaryTo: NSClassFromString(ivarType)];
        }
        else
            NSLog(@"[NSDictionary+JSON] unknown type: %@",NSStringFromClass([value class]));
        
        // set the value into object
        if (value!=nil) {
            [object setValue:value forKey:ivarName];
        }

    }
    free(ivars);
    return [object autorelease];
        
}
    
@end
