//
//  NSObject+JSON.m
//  JSONTest
//
//  Created by Jay on 1/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSObject+JSON.h"
static const char *GenericTypeKey = "genericTypeKey";

@implementation NSObject (JSON)

- (NSMutableDictionary *) objectToDictionary
{
    Class clazz = [self class];
    u_int count;
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    Ivar* ivars = class_copyIvarList(clazz, &count);
    for (int i = 0; i < count ; i++)
    {
        // get variable's name and type
        const char* ivarCName = ivar_getName(ivars[i]);
        const char* ivarCType = ivar_getTypeEncoding(ivars[i]);
        
        // convert to NSString
        NSString *ivarName = [NSString stringWithCString:ivarCName encoding:NSUTF8StringEncoding];
        NSString *ivarType = [NSString stringWithCString:ivarCType encoding:NSUTF8StringEncoding];
        
        
        id value = nil;
        //if ivarType equal to NSArray, convert it. 
        if ([ivarType compare:@"@\"NSArray\""] == NSOrderedSame)
            value = [(NSArray *)[self valueForKey:ivarName] arrayToDictonaryArray];
        
        //if ivarType equal to basic json object, nothing
        else if([ivarType compare:@"@\"NSString\""] == NSOrderedSame ||
           [ivarType compare:@"@\"NSNumber\""] == NSOrderedSame ||
           [ivarType compare:@"@\"NSDictionary\""] == NSOrderedSame)
        {
            value = [self valueForKey:ivarName]; 
        }
        
        // if ivarType equal to other object, convert to dictonary
        else
             value = [[self valueForKey:ivarName] objectToDictionary];
            
        
        // add to dictionary
        [dictionary setValue:value forKey:ivarName];
        
    }
    free(ivars);
    return dictionary;
}

+ (void) setGenericType: (NSDictionary* )type
{
    objc_setAssociatedObject([self class], GenericTypeKey, type, OBJC_ASSOCIATION_COPY);
}


+ (NSDictionary *) getGenericType
{
    return (NSDictionary *)objc_getAssociatedObject([self class], GenericTypeKey);
}


@end
