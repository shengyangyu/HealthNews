//
//  ScrollPageView.m
//  ShowProduct
//
//  Created by lin on 14-5-23.
//  Copyright (c) 2014年 @"". All rights reserved.
//

#import "ScrollPageView.h"
#import "HomeCell.h"

@implementation ScrollPageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        mNeedUseDelegate = YES;
        [self commInit];
    }
    return self;
}

-(void)initData{
    [self freshContentTableAtIndex:0];
}


-(void)commInit{
    if (_contentItems == nil) {
        _contentItems = [[NSMutableArray alloc] init];
    }
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
    }
    [self addSubview:_scrollView];
}

-(void)dealloc{
    [_contentItems removeAllObjects],_contentItems= nil;
}

#pragma mark - 其他辅助功能
#pragma mark 添加ScrollowViewd的ContentView
-(void)setContentOfTables:(NSInteger)aNumerOfTables{
    for (int i = 0; i < aNumerOfTables; i++) {
        RefreshTableView *vTableView = [[RefreshTableView alloc] initWithFrame:CGRectMake(__MainScreen_Width * i, 0, __MainScreen_Width, self.frame.size.height) withStyle:UITableViewStylePlain withType:ULE_TableViewTypeAll];
        vTableView.delegate = self;
        vTableView.dataSource = self;
        //为table添加嵌套HeadderView
        [self addLoopScrollowView:vTableView];
        [_scrollView addSubview:vTableView];
        [_contentItems addObject:vTableView];
    }
    [_scrollView setContentSize:CGSizeMake(__MainScreen_Width * aNumerOfTables, self.frame.size.height)];
}

#pragma mark 移动ScrollView到某个页面
-(void)moveScrollowViewAthIndex:(NSInteger)aIndex{
    mNeedUseDelegate = NO;
    CGRect vMoveRect = CGRectMake(self.frame.size.width * aIndex, 0, self.frame.size.width, self.frame.size.width);
    [_scrollView scrollRectToVisible:vMoveRect animated:YES];
    mCurrentPage= aIndex;
    if ([_delegate respondsToSelector:@selector(didScrollPageViewChangedPage:)]) {
        [_delegate didScrollPageViewChangedPage:mCurrentPage];
    }
}

#pragma mark 刷新某个页面
-(void)freshContentTableAtIndex:(NSInteger)aIndex{
    if (_contentItems.count < aIndex) {
        return;
    }
    RefreshTableView *vTableContentView =(RefreshTableView *)[_contentItems objectAtIndex:aIndex];
    [vTableContentView.header beginRefreshing];
}

#pragma mark 添加HeaderView
-(void)addLoopScrollowView:(RefreshTableView *)aTableView {
    //添加一张默认图片
    SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:@{@"image": [NSString stringWithFormat:@"girl%d",2]} tag:-1];
    SGFocusImageFrame *bannerView = [[SGFocusImageFrame alloc] initWithFrame:CGRectMake(0, -105, 320, 105) delegate:aTableView imageItems:@[item] isAuto:YES];
    aTableView.tableHeaderView = bannerView;
}

#pragma mark 改变TableView上面滚动栏的内容
-(void)changeHeaderContentWithCustomTable:(RefreshTableView *)aTableContent{
    int length = 4;
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0 ; i < length; i++)
    {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSString stringWithFormat:@"title%d",i],@"title" ,
                              [NSString stringWithFormat:@"girl%d",(i + 1)],@"image",
                              nil];
        [tempArray addObject:dict];
    }
    
    NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:length+2];
    //添加最后一张图 用于循环
    if (length > 1)
    {
        NSDictionary *dict = [tempArray objectAtIndex:length-1];
        SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:dict tag:-1];
        [itemArray addObject:item];
    }
    for (int i = 0; i < length; i++)
    {
        NSDictionary *dict = [tempArray objectAtIndex:i];
        SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:dict tag:i];
        [itemArray addObject:item];
        
    }
    //添加第一张图 用于循环
    if (length >1)
    {
        NSDictionary *dict = [tempArray objectAtIndex:0];
        SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:dict tag:length];
        [itemArray addObject:item];
    }
    
    SGFocusImageFrame *vFocusFrame = (SGFocusImageFrame *)aTableContent.tableHeaderView;
    [vFocusFrame changeImageViewsContent:itemArray];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    mNeedUseDelegate = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = (_scrollView.contentOffset.x+320/2.0) / 320;
    if (mCurrentPage == page) {
        return;
    }
    mCurrentPage= page;
    if ([_delegate respondsToSelector:@selector(didScrollPageViewChangedPage:)] && mNeedUseDelegate) {
        [_delegate didScrollPageViewChangedPage:mCurrentPage];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
//        CGFloat targetX = _scrollView.contentOffset.x + _scrollView.frame.size.width;
//        targetX = (int)(targetX/ITEM_WIDTH) * ITEM_WIDTH;
//        [self moveToTargetPosition:targetX];
    }
  

}
#pragma mark - Table View DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HC_Cell_height;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    RefreshTableView *tmp = (RefreshTableView *)aTableView;
    return [tmp.mInfoArray count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"HomeCell";
    HomeCell *cell = [aTableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[HomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark 开始进入刷新状态
- (void)tableViewHeaderRereshing:(UITableView *)tableView withCompletioned:(void (^)())completioned
{
    //RefreshTableView *tmp = (RefreshTableView *)tableView;
    //下拉刷新
    //m_indexNum = 1;
    //m_totalCount = 0;
    //[self requestNews];//请求机票订单列表数据
}

- (void)tableViewFooterRereshing:(UITableView *)tableView withCompletioned:(void (^)())completioned
{
    //RefreshTableView *tmp = (RefreshTableView *)tableView;
    //上拉加载更多
    //[self requestNews];
}

@end
