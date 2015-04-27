//
//  SPTableView.h
//  HealthNews
//
//  Created by yushengyang on 15/4/27.
//  Copyright (c) 2015年 yushengyang. All rights reserved.
//

#import "RefreshTableView.h"
#import "AFInterfaceAPIExcute.h"
#import "BaseResponse.h"
#import "API_Header.h"
#import "HomeCell.h"
#import "NSString+HXAddtions.h"
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"

@interface SPTableView : RefreshTableView
{
    AFInterfaceAPIExcute *apiNewsList;//资讯列表
    NSInteger               m_indexNum;//当前下标
    NSInteger               m_totalCount;//总数
    
}
@property (nonatomic, retain) NSString *m_type;//类型
@property (nonatomic, retain) NSMutableArray *m_heads;//表头数据
@end
