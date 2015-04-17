//
//  NSString+HXAddtions.m
//  ule_flight
//
//  Created by ule_ysy on 14-9-18.
//  Copyright (c) 2014年 lizemeng. All rights reserved.
//

#import "NSString+HXAddtions.h"
#import <Foundation/Foundation.h>

@implementation NSString (HXAddtions)

+(NSString *) jsonStringWithString:(NSString *) string{
    // 当返回的数据有\\'的时候
    if ([string rangeOfString:@"\\'"].location != NSNotFound) {
        string = [string stringByReplacingOccurrencesOfString:@"\\'" withString:@"'"];
    }
    // 当返回的数据有\r的时候
    if ([string rangeOfString:@"\r"].location != NSNotFound) {
        NSString *mString = [NSString stringWithFormat:@"\"%@\"",
                             [[string stringByReplacingOccurrencesOfString:@"\r" withString:@"\\n"] stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""]];
        return [NSString stringWithFormat:@"\"%@\"",
                [[mString stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"] stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""]];
    }
    return [NSString stringWithFormat:@"\"%@\"",
                [[string stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"] stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""]];
}

+ (NSString *) jsonStringWithNumber:(NSNumber *) number
{
    NSString *mString = [NSString stringWithFormat:@"%@",number];
    // 当返回的数据有\r的时候
    if ([mString rangeOfString:@"\r"].location != NSNotFound) {
        NSString *mmString = [NSString stringWithFormat:@"\"%@\"",
                             [[mString stringByReplacingOccurrencesOfString:@"\r" withString:@"\\n"] stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""]];
        return [NSString stringWithFormat:@"\"%@\"",
                [[mmString stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"] stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""]];
    }
    return [NSString stringWithFormat:@"\"%@\"",
            [[mString stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"] stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""]
            ];
}

+(NSString *) jsonStringWithArray:(NSArray *)array{
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"["];
    NSMutableArray *values = [NSMutableArray array];
    for (id valueObj in array) {
        NSString *value = [NSString jsonStringWithObject:valueObj];
        if (value) {
            [values addObject:[NSString stringWithFormat:@"%@",value]];
        }
    }
    [reString appendFormat:@"%@",[values componentsJoinedByString:@","]];
    [reString appendString:@"]"];
    return reString;
}

+(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary{
    NSArray *keys = [dictionary allKeys];
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"{"];
    NSMutableArray *keyValues = [NSMutableArray array];
    for (int i=0; i<[keys count]; i++) {
        NSString *name = [keys objectAtIndex:i];
        id valueObj = [dictionary objectForKey:name];
        NSString *value = [NSString jsonStringWithObject:valueObj];
        if (value) {
            [keyValues addObject:[NSString stringWithFormat:@"\"%@\":%@",name,value]];
        }
    }
    [reString appendFormat:@"%@",[keyValues componentsJoinedByString:@","]];
    [reString appendString:@"}"];
    return reString;
}

+(NSString *) jsonStringWithObject:(id) object{
    NSString *value = nil;
    if (!object) {
        return value;
    }
    if ([object isKindOfClass:[NSString class]]) {
        value = [NSString jsonStringWithString:object];
    }else if([object isKindOfClass:[NSDictionary class]]){
        value = [NSString jsonStringWithDictionary:object];
    }else if([object isKindOfClass:[NSArray class]]){
        value = [NSString jsonStringWithArray:object];
    }else if ([object isKindOfClass:[NSNumber class]]) {
        value = [NSString jsonStringWithNumber:object];
    }
    
    return value;
}



@end
