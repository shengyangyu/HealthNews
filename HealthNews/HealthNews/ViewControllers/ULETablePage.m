//
//  ULETablePage.m
//  PostLife_new
//
//  Created by yushengyang on 14/12/9.
//  Copyright (c) 2014年 ule. All rights reserved.
//

#import "ULETablePage.h"

@implementation ULETablePage
@synthesize start;
@synthesize end;
@synthesize count;
@synthesize currentPage;
@synthesize pageSize;

- (void)setStuPage:(NSInteger)pCurrentPage
      withPageSize:(NSInteger)pPageSize
{
    currentPage = pCurrentPage;
    pageSize = pPageSize;
    start = (currentPage - 1) * pageSize + 1;
    end = start + pageSize - 1;
    count = 0;
}

@end
