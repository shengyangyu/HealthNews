//
//  ULETablePage.h
//  PostLife_new
//
//  Created by yushengyang on 14/12/9.
//  Copyright (c) 2014年 ule. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ULETablePage : NSObject
{
    
@public
    NSInteger start;        //开始点
    NSInteger end;          //结束点
    NSInteger count;        //数据总数
    NSInteger currentPage;  //当前页
    NSInteger pageSize;     //每页数据条数
}

@property(nonatomic,assign) NSInteger start;
@property(nonatomic,assign) NSInteger end;
@property(nonatomic,assign) NSInteger count;
@property(nonatomic,assign) NSInteger currentPage;
@property(nonatomic,assign) NSInteger pageSize;

/**
 *  设置当前页index 和页数pagesize
 */
-(void)setStuPage:(NSInteger)pCurrentPage
     withPageSize:(NSInteger)pPageSize;

@end
