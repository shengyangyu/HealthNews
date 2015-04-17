//
//  BaseTableViewController.m
//  HealthNews
//
//  Created by yushengyang on 15/4/17.
//  Copyright (c) 2015年 yushengyang. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

#pragma mark －初始化
- (void)addTableView:(CGRect)rect
           withStyle:(UITableViewStyle)style
            withType:(ULETableViewType)type
              parent:(UIView*)parentView
{
    m_indexNum=1;
    m_muArray = [[NSMutableArray alloc] init];
    m_tableView = [[RefreshTableView alloc] initWithFrame:rect
                                                      withStyle:style
                                                       withType:type];
    m_tableView.delegate = self;
    m_tableView.dataSource = self;
    m_tableView.touchDelegate = self;
    m_tableView.scrollsToTop = YES;
    m_tableView.backgroundColor = [UIColor clearColor];
    [parentView addSubview:m_tableView];

}

- (RefreshTableView *)fenleiTableView
{
    if(m_tableView)
    {
        return m_tableView;
    }else
        return nil;
}

#pragma mark -
- (void)updateThread:(NSString *)returnKey
{
    [self performSelectorOnMainThread:@selector(updateTableView)
                           withObject:nil
                        waitUntilDone:NO];
}

- (void)updateTableView
{
    BOOL isSuccessed = NO;
    if ( m_muArray.count >= m_totalCount)
    {
        isSuccessed = YES;
    }
    [m_tableView reloadData:isSuccessed];
}

-(void) setIndexNum:(int) listCount
         totalCount:(int) totalCount{
    
    m_indexNum  = m_indexNum + listCount;
    m_totalCount = totalCount;
    
}

-(void) setReduction{
    
    [m_muArray removeAllObjects];
    m_indexNum=1;
    [m_tableView reloadData];
}

-(void)setParams:(NSMutableDictionary*)dic
{
    m_params = dic;
}

#pragma mark - Table View DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return [m_muArray count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - scrollView Delegate

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
