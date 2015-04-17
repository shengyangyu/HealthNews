//
//  HomeViewController.m
//  HealthNews
//
//  Created by yushengyang on 15/4/17.
//  Copyright (c) 2015年 yushengyang. All rights reserved.
//

#import "HomeViewController.h"
#import "DetailViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    self.isHideLeftItem = YES;
    self.isShowTabbar = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self titleLabel:@"健康资讯" ];
    [self initTableView];
}

-(void)initTableView{
    [self addTableView:CGRectMake(0, 0, __MainScreen_Width, __viewContent_hight3) withStyle:UITableViewStylePlain withType:ULE_TableViewTypeNone parent:self.view];
    [m_muArray addObjectsFromArray:@[@"2",@"1",@"3",@"4",@"5",@"",@"",@"6",@"7",@"8",@"9",@"0",@"-",@"j",@"d",@"h"]];
}

#pragma mark - Table view data source
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_muArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }

    cell.textLabel.text = m_muArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self pushNewViewController:@"DetailViewController" isNibPage:NO setHideTabBar:YES withData:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
