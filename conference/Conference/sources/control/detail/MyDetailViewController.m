//
//  MyDetailViewController.m
//  Conference
//
//  Created by wu xiaofang on 13-6-14.
//  Copyright (c) 2013年 wu xiaofang. All rights reserved.
//

#import "MyDetailViewController.h"
#import "PublicMeetingViewController.h"
#import "CreateMeetingViewController.h"
#import "MyTaskViewController.h"
#import "MeetingManageViewController.h"

@interface MyDetailViewController ()

@property (nonatomic,retain)UIViewController* currentViewController;
@property (nonatomic,assign)LoadType currentType;
- (void)loadMyMettingViewController:(BOOL)animated;
- (void)loadPyblicMettingViewController:(BOOL)animated;
- (void)loadCreateMettingViewController:(BOOL)animated;
- (void)loadMyTaskViewController:(BOOL)animated;

@end

@implementation MyDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadMyMettingViewController:NO];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)dealloc
{
    self.currentViewController = nil;
    [super dealloc];
}


#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Cards", @"Cards");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
}

#pragma mark - Public
- (void)loadDataSource:(LoadType)loadtype
{
    NSLog(@"%d",loadtype);
    switch (loadtype) {
        case LoadMyConference:
        {
            [self loadMyMettingViewController:YES];
        }
            break;
        case LoadPublicConference:
        {
            [self loadPyblicMettingViewController:YES];
        }
            break;
        case LoadCreateConference:
        {
            [self loadCreateMettingViewController:YES];
        }
            break;
        case LoadMyTask:
        {
            [self loadMyTaskViewController:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Internal
- (void)loadMyMettingViewController:(BOOL)animated
{
    if(self.currentType != LoadMyConference){
        if(self.currentViewController){
            [self.navigationController popViewControllerAnimated:NO];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            MeetingManageViewController *meet = [[[MeetingManageViewController alloc]init] autorelease];
            [self.navigationController pushViewController:meet animated:animated];
            self.currentViewController = meet;
            self.currentType = LoadMyConference;
        });


    }
}
- (void)loadPyblicMettingViewController:(BOOL)animated
{
    if(self.currentType != LoadPublicConference){
        if(self.currentViewController){
            [self.navigationController popViewControllerAnimated:NO];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            PublicMeetingViewController *publicMeet = [[[PublicMeetingViewController alloc]init] autorelease];
            [self.navigationController pushViewController:publicMeet animated:animated];
            self.currentViewController = publicMeet;
            self.currentType = LoadPublicConference;

        });

    }
}
- (void)loadCreateMettingViewController:(BOOL)animated
{
    if(self.currentType != LoadCreateConference){
        if(self.currentViewController){
            [self.navigationController popViewControllerAnimated:NO];
        }
       
        dispatch_async(dispatch_get_main_queue(), ^{
            CreateMeetingViewController *createMeet = [[[CreateMeetingViewController alloc]init] autorelease];
            [self.navigationController pushViewController:createMeet animated:animated];
            self.currentViewController = createMeet;
            self.currentType = LoadCreateConference;
        });



    }
}
- (void)loadMyTaskViewController:(BOOL)animated
{
    if(self.currentType != LoadMyTask){
        if(self.currentViewController){
            [self.navigationController popViewControllerAnimated:NO];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            MyTaskViewController *mytask = [[[MyTaskViewController alloc]init] autorelease];
            [self.navigationController pushViewController:mytask animated:animated];
            self.currentViewController = mytask;
            self.currentType = LoadMyTask;
        });

    }

}

@end
