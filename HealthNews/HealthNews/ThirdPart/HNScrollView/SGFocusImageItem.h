//
//  SGFocusImageItem.h
//  ScrollViewLoop
//
//  Created by Vincent Tang on 13-7-18.
//  Copyright (c) 2013年 Vincent Tang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGFocusImageItem : NSObject

@property (nonatomic, retain)  NSString     *title;
@property (nonatomic, retain)  NSString     *image;
@property (nonatomic, assign)  NSString     *tag;

- (id)initWithTitle:(NSString *)title image:(NSString *)image tag:(NSString *)tag;
- (id)initWithDict:(NSDictionary *)dict tag:(NSString *)tag;
@end
