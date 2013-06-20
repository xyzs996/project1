//
//  MyMasterViewController.m
//  Conference
//
//  Created by wu xiaofang on 13-6-14.
//  Copyright (c) 2013年 wu xiaofang. All rights reserved.
//

#import "MyMasterViewController.h"
#import "MyMasterTitleCell.h"
#import "MyMasterSubTitleCell.h"
#import "MyDetailViewController.h"
#import "AppDelegate.h"
@interface MyMasterViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain)UITableView* myTableView;
@property (nonatomic,retain)UIButton* logoutButton;
- (void)initMyTableView;
- (void)logoutButtonPress;
@end

@implementation MyMasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initMyTableView];
    self.logoutButton = [[UIButton alloc] init];
    [self.logoutButton setTitle:@"注销系统" forState:UIControlStateNormal];
    [self.logoutButton addTarget:self action:@selector(logoutButtonPress) forControlEvents:UIControlEventTouchUpInside];
    [self.logoutButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.logoutButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];

    self.logoutButton.titleLabel.font = [UIFont boldSystemFontOfSize:24.0f];
    [self.view addSubview:self.logoutButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGFloat viewWidth = self.view.bounds.size.width;
    CGFloat viewHeigth = self.view.bounds.size.height;
    self.myTableView.frame = CGRectMake(0, 0, viewWidth, viewHeigth - 40);
    self.logoutButton.frame = CGRectMake(0, viewHeigth - 40, viewWidth, 40);
}
- (void)dealloc
{
    self.myTableView = nil;
    self.logoutButton = nil;
    [super dealloc];
}
#pragma mark - init
- (void)initMyTableView
{
    self.view.backgroundColor = [UIColor grayColor];
    self.myTableView = [[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain] autorelease];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.scrollEnabled = NO;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView.backgroundColor = [UIColor clearColor];
    self.myTableView.backgroundView = nil;
    [self.view addSubview:self.myTableView];
}
#pragma mark - Internal
- (void)logoutButtonPress
{
    sendNotification(PosLogoutNotification, nil);
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSString* identify = @"MyMasterTitleCell";
    if(indexPath.row ==0 || indexPath.row == 4){
        identify = @"MyMasterTitleCell";
    }else{
        identify = @"MyMasterSubTitleCell";
    }
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if(cell == nil){
        cell = [[[NSClassFromString(identify) alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify] autorelease];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    if([identify isEqualToString:@"MyMasterTitleCell"]){
        MyMasterTitleCell* myMasterTitle = (MyMasterTitleCell*)cell;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(indexPath.row == 0){
            [myMasterTitle loadCellData:@"会议管理"];
        }else if(indexPath.row == 4){
            [myMasterTitle loadCellData:@"任务管理"];
        }
    }else if([identify isEqualToString:@"MyMasterSubTitleCell"]){
        MyMasterSubTitleCell* myMasterSubTitle = (MyMasterSubTitleCell*)cell;
        
        switch (indexPath.row) {
            case 1:
            {
                [myMasterSubTitle loadCellData:@"我的会议"];
            }
                break;
            case 2:
            {
                [myMasterSubTitle loadCellData:@"公共会议"];
            }
                break;
            case 3:
            {
                [myMasterSubTitle loadCellData:@"创建会议"];
            }
                break;
            case 5:
            {
                [myMasterSubTitle loadCellData:@"我的任务"];
            }
                break;
            
                
            default:
                break;
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    switch (indexPath.row) {
        case 1:
        {
            [delegate.myDetailViewController loadDataSource:LoadMyConference];
        }
            break;
        case 2:
        {
            [delegate.myDetailViewController loadDataSource:LoadPublicConference];
        }
            break;
        case 3:
        {
            [delegate.myDetailViewController loadDataSource:LoadCreateConference];
        }
            break;
        case 5:
        {
            [delegate.myDetailViewController loadDataSource:LoadMyTask];
        }
            break;
            
            
        default:
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat heigth = 50;
    if(indexPath.row == 0 || indexPath.row == 4){
        heigth = 80;
    }
    return heigth;
}
@end
