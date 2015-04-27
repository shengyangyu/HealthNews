//
//  ScrollPageView.m
//  ShowProduct
//
//  Created by lin on 14-5-23.
//  Copyright (c) 2014年 @"". All rights reserved.
//

#import "ScrollPageView.h"
#import "HomeCell.h"
#import "HomeViewController.h"

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
-(void)setContentOfTables:(NSInteger)aNumerOfTables {
    for (int i = 0; i < aNumerOfTables; i++) {
        SPTableView *vTableView = [[SPTableView alloc] initWithFrame:CGRectMake(__MainScreen_Width * i, 0, __MainScreen_Width, self.frame.size.height) withStyle:UITableViewStylePlain withType:ULE_TableViewTypeAll];
        vTableView.delegate = self;
        vTableView.dataSource = self;
        vTableView.m_type = self.typeArray[i];
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
    SPTableView *vTableContentView =(SPTableView *)[_contentItems objectAtIndex:aIndex];
    // 如果已有数据 不自动初始化
    if ([vTableContentView.m_heads count] && [vTableContentView.mInfoArray count]) {
        return;
    }
    [vTableContentView.header beginRefreshing];
}

#pragma mark 添加HeaderView
-(void)addLoopScrollowView:(SPTableView *)aTableView {
    //添加一张默认图片
    SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:@{@"image": @"NTESAW_banner_default"} tag:@"-1"];
    SGFocusImageFrame *bannerView = [[SGFocusImageFrame alloc] initWithFrame:CGRectMake(0, -105, 320, 105) delegate:self imageItems:@[item] isAuto:YES];
    aTableView.tableHeaderView = bannerView;
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
        /*
        CGFloat targetX = _scrollView.contentOffset.x + _scrollView.frame.size.width;
        targetX = (int)(targetX/ITEM_WIDTH) * ITEM_WIDTH;
        [self moveToTargetPosition:targetX];
         */
    }
}
#pragma mark - Table view data source
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return HC_Cell_height;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SPTableView *tmp = (SPTableView *)tableView;
    return tmp.mInfoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"HomeCell";
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[HomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    @try {
        SPTableView *tmp = (SPTableView *)tableView;
        HNNewsDetail *mclass = (HNNewsDetail *) tmp.mInfoArray[indexPath.row];
        [cell.mIconImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",kImageUrl,mclass.img]] placeholderImage:[UIImage imageNamed:@"hc_cell_icon"]];
        cell.mTitleLab.text = mclass.title;
        cell.mTimeLab.text = [NSString changeTimeMethod:mclass.time];
    }
    @catch (NSException *exception) {
        
    }
    
    return cell;
}

+ (NSDate *)methodDateFromString:(NSString *)mString withFormat:(NSString *)mFormat
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [formatter setDateFormat:mFormat];
    return [formatter dateFromString:mString];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    @try {
        SPTableView *tmp = (SPTableView *)tableView;
        HNNewsDetail *mclass = (HNNewsDetail *)tmp.mInfoArray[indexPath.row];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:mclass.mId forKey:@"id"];
        [self.supVC pushNewViewController:@"DetailViewController" isNibPage:NO withData:dic];
    }
    @catch (NSException *exception) {
        //[self HUDShow:@"获取详情错误!" delay:kShowTitleAfterDelay];
    }
}
#pragma mark -
- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame didSelectItem:(SGFocusImageItem *)item withIndex:(NSInteger)mIndex {
    if (![item.tag isEqualToString:@"-1"]) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:item.tag forKey:@"id"];
        [self.supVC pushNewViewController:@"DetailViewController" isNibPage:NO withData:dic];
    }
}

- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame currentItem:(int)index {
    
}
@end
