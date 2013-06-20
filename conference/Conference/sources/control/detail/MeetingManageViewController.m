//
//  MeetingManageViewController.m
//  Conference
//
//  Created by zsf on 6/15/13.
//  Copyright (c) 2013 wu xiaofang. All rights reserved.
//

#import "MeetingManageViewController.h"

@interface MeetingManageViewController ()
@property (nonatomic, retain) UILabel *meetNameLab;
@property (nonatomic, retain) UITextField *meetTF;
@property (nonatomic, retain) UIButton *searchBtn;
@property (nonatomic, retain) UIButton *newBtn;
@property (nonatomic, retain) NSMutableArray *headArray;
@end

@implementation MeetingManageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
	// Do any additional setup after loading the view.
    self.title = @"我的会议";
    
    _meetNameLab = [[UILabel alloc]initWithFrame:CGRectMake(30, 70, 90, 30)];
    [_meetNameLab setText:@"会议名称:"];
    _meetNameLab.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_meetNameLab];
    
    _meetTF = [[UITextField alloc]initWithFrame:CGRectMake(_meetNameLab.frame.origin.x+_meetNameLab.frame.size.width+16, _meetNameLab.frame.origin.y, 240, 30)];
    _meetTF.backgroundColor = [UIColor redColor];
    [self.view addSubview:_meetTF];
    
    _searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(_meetTF.frame.origin.x+_meetTF.frame.size.width+40, _meetNameLab.frame.origin.y, 60 , 30)];
    [_searchBtn addTarget:self action:@selector(searchBtnFun) forControlEvents:UIControlEventTouchUpInside];
    _searchBtn.backgroundColor = [UIColor blueColor];
    [self.view addSubview:_searchBtn];
    
    _newBtn = [[UIButton alloc]initWithFrame:CGRectMake(_searchBtn.frame.origin.x+_searchBtn.frame.size.width+110, _meetNameLab.frame.origin.y, 60 , 30)];
    [_newBtn addTarget:self action:@selector(newBtnFun) forControlEvents:UIControlEventTouchUpInside];
    _newBtn.backgroundColor = [UIColor blueColor];
    [self.view addSubview:_newBtn];
    
    
    _headArray = [[NSMutableArray arrayWithObjects:@"编号",@"会议名称",@"会议开始时间",@"会议结束时间",@"会议地点",@"操作", nil] retain];
    
    GridView *gridView = [[GridView alloc] init];
    gridView.delegate = self;
    gridView.dataSource = self;
    [self.view addSubview:gridView];
    [gridView setIsDeleteRowAble:NO];
    [gridView setIsBouncesAble:NO];
    [gridView setIsDragUpAble:NO];
    [gridView setIsPullDownAble:NO];
    [gridView loadView:CGRectMake(_meetNameLab.frame.origin.x, _meetNameLab.frame.origin.y+_meetNameLab.frame.size.height + 50, 640.0, 500)];
    gridView.backgroundColor = [UIColor blueColor];
}

- (void)searchBtnFun
{
    
}

- (void)newBtnFun
{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)gridView:(GridView *)p_view heightForContentAtRow:(NSInteger)p_row
{
    return 40.0;
}

- (CGFloat)heightForHeader:(GridView *)p_view
{
    return 40.0;
}

- (CGFloat)heightForFooter:(GridView *)p_view
{
    return 40.0;
}

- (void)gridView:(GridView *)p_view deleteWithRow:(NSInteger)p_row
{
    
}

- (NSInteger)numberOfContentRowsInGridView:(GridView *)p_view
{
    return 20;
}

- (NSInteger)numberOfColumnsInGridView:(GridView *)p_view
{
    return 6;
}

- (GridColumnModel *)gridView:(GridView *)p_view modelForColumnAtColumn:(NSInteger)p_column
{
    GridColumnModel *columnModel = [[[GridColumnModel alloc] init] autorelease];
    columnModel.titleColor = GridColorMake(0.0, 0.0, 0.0, 1.0);
    columnModel.titleBgColor = GridColorMake(128.0, 128.0, 128.0, 1.0);
    switch (p_column)
    {
        case 0:
            columnModel.columnWidth = 50.0;
            break;
        case 1:
            columnModel.columnWidth = 90.0;
            break;
        case 2:
            columnModel.columnWidth = 140.0;
            break;
        case 3:
            columnModel.columnWidth = 140.0;
            break;
        case 4:
            columnModel.columnWidth = 90.0;
            break;
        case 5:
            columnModel.columnWidth = 130.0;
            break;
        case 6:
            columnModel.columnWidth = 100.0;
            break;
        case 7:
            columnModel.columnWidth = 100.0;
            break;
        default:
            return nil;
    }
    if (p_column % 2 == 0) {
        columnModel.contentColor = GridColorMake(.0, .0, .0, 1.0);
        columnModel.contentBgColor = GridColorMake(121.0, 21.0, 121.0, 1.0);
    } else {
        columnModel.contentColor = GridColorMake(.0, .0, .0, 1.0);
        columnModel.contentBgColor = GridColorMake(138.0, 138.0, 138.0, 1.0);
    }
    
    return columnModel;
}

- (NSString *)gridView:(GridView *)p_view textForHeaderAtColumn:(NSInteger)p_column
{
    return [_headArray objectAtIndex:p_column];
}

- (NSString *)gridView:(GridView *)p_view textForContentAtPosition:(GridPosition)p_p
{
    return [@"Row-" stringByAppendingFormat:@"%d,Column-%d", p_p.rc.row, p_p.rc.column];
}

- (void)dealloc
{
    [_meetNameLab release];
    _meetNameLab = nil;
    
    [_meetNameLab release];
    _meetNameLab = nil;
    
    [_searchBtn release];
    _searchBtn  = nil;
    
    [_headArray release];
    _headArray  = nil;
    
    [super dealloc];
}
@end
