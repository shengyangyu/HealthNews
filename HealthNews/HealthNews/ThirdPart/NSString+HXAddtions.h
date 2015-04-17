//
//  NSString+HXAddtions.h
//  ule_flight
//
//  Created by ule_ysy on 14-9-18.
//  Copyright (c) 2014年 lizemeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HXAddtions)

+ (NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary;
+ (NSString *) jsonStringWithArray:(NSArray *)array;
+ (NSString *) jsonStringWithString:(NSString *) string;
+ (NSString *) jsonStringWithNumber:(NSNumber *) number;
+ (NSString *) jsonStringWithObject:(id) object;

@end
