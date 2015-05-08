//
//  UserViewController.m
//  HealthNews
//
//  Created by yushengyang on 15/4/17.
//  Copyright (c) 2015年 yushengyang. All rights reserved.
//

#import "UserViewController.h"
#import "UleScrollView.h"
#import "UIViewController+UleHiddenNavi.h"
#import "UleHiddenForScroller.h"
#import "UleSectionHeaderView.h"

@interface UserViewController ()<UITableViewDelegate, UITableViewDataSource, UleScrollDelegate>
{
    NSMutableArray *imageArr;
    NSMutableArray *textArr;
}
@end

@implementation UserViewController

- (void)viewDidLoad {
    self.isHideLeftItem = YES;
    self.isShowTabbar = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self titleLabel:@"个人中心"];
    imageArr = [[NSMutableArray alloc]initWithObjects:
                @"tb_news",
                @"tb_reader",
                @"tb_found",nil];
    textArr = [[NSMutableArray alloc]initWithObjects:
               @"我的资讯",
               @"我的常识",
               @"我的食谱",nil];
    UleScrollView *myTableView = [[UleScrollView alloc]
                                    initTableViewWithBackgound:[UIImage imageNamed:@"Clouds"]
                                    avatarImage:[UIImage imageNamed:@"avatar"]
                                    titleString:@"Main title"
                                    subtitleString:@"Sub title"
                                    buttonTitle:@"Follow"];  // Set nil for no button
    myTableView.m_tableView.delegate = self;
    myTableView.m_tableView.dataSource = self;
    myTableView.delegate = self;
    [self.view addSubview:myTableView];
    
    self.mScroller = [[UleHiddenForScroller alloc] initWithViewController:self scrollView:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.mScroller expand];
    [super viewWillAppear:animated];
}

#pragma mark -UITableViewDelegate、UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UleSectionHeaderView *sectionHead = [[UleSectionHeaderView alloc] init];
    sectionHead.section = section;
    sectionHead.tableView = tableView;
    ({
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 30)];
        backView.backgroundColor = [UIColor convertHexToRGB:@"F2F2F2" withAlpha:1];
        [sectionHead addSubview:backView];
    });
    return sectionHead;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 10, 26, 26)];
    //imageView.tag = 111;
    [cell.contentView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 15, 0, __MainScreen_Width-120, 44)];
    label.tag = 222;
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor convertHexToRGB:@"686868" withAlpha:1];
    [cell.contentView addSubview:label];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(label.frame.origin.x - 3,43.5,__MainScreen_Width - CGRectGetMaxX(imageView.frame),.5)];
    line.backgroundColor = [UIColor convertHexToRGB:@"E5E5E5" withAlpha:1];
    [cell.contentView addSubview:line];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 44)];
    view.backgroundColor = [UIColor convertHexToRGB:@"e6e6e6" withAlpha:1];
    cell.selectedBackgroundView = view;
    if (indexPath.section == 0 && indexPath.row == 0) {
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0,0,__MainScreen_Width,.5)];
        line2.backgroundColor = [UIColor convertHexToRGB:@"E5E5E5" withAlpha:1];
        [cell.contentView addSubview:line2];
        imageView.image = [UIImage imageNamed:[imageArr objectAtIndex:0]];;
        label.text = [textArr objectAtIndex:0];
    }else if (indexPath.section == 0 && indexPath.row == 1) {
        imageView.image = [UIImage imageNamed:[imageArr objectAtIndex:1]];;
        label.text = [textArr objectAtIndex:1];
    }else if (indexPath.section == 0 && indexPath.row == 2) {
        imageView.image = [UIImage imageNamed:[imageArr objectAtIndex:2]];;
        label.text = [textArr objectAtIndex:2];
        line.frame = CGRectMake(0,43.5,__MainScreen_Width,.5);
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(void) recievedUleScrollEvent {
    NSLog(@"recievedUleScrollEvent");
}

- (void) recievedUleScrollButtonClicked {
    NSLog(@"recievedUleScrollButtonClicked");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
