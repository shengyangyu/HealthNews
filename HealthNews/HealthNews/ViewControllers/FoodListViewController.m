//
//  FoodListViewController.m
//  HealthNews
//
//  Created by yushengyang on 15/4/30.
//  Copyright (c) 2015年 yushengyang. All rights reserved.
//

#import "FoodListViewController.h"

@interface FoodListViewController ()

@end

@implementation FoodListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self titleLabel:@"食谱列表"];
    [self setUIMethod];
}

#pragma mark - set UIMethod
- (void)setUIMethod {
    //  列表
    [self addTableView:CGRectMake(0, 0, __MainScreen_Width, __viewContent_hight3) withStyle:UITableViewStylePlain withType:ULE_TableViewTypeAll parent:self.view];
    m_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)requestList {

}

#pragma mark - CustomerTableViewDelegate
- (void)tableViewHeaderRereshing:(UITableView *)tableView withCompletioned:(void (^)())completioned {
    m_indexNum = 1;
    [self requestList];
}
- (void)tableViewFooterRereshing:(UITableView *)tableView withCompletioned:(void (^)())completioned {
    [self requestList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
