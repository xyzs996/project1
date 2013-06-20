//
//  PosBaseViewController.m
//  PosProject
//
//  Created by wu xiaofang on 13-6-7.
//  Copyright (c) 2013年 xiaofang.wu. All rights reserved.
//

#import "PosBaseViewController.h"

@interface PosBaseViewController ()

@end

@implementation PosBaseViewController

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
    self.navigationItem.hidesBackButton = YES;
    self.view.backgroundColor = [UIColor whiteColor];

}


- (void)viewDidUnload
{
    [super viewDidUnload];
    [self releaseAllSubViews];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0){
        [self releaseAllSubViews];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (UIInterfaceOrientationLandscapeRight == toInterfaceOrientation || UIInterfaceOrientationLandscapeLeft == toInterfaceOrientation);
    
}

// New Autorotation support.
- (BOOL)shouldAutorotate
{
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
    
}
#pragma mark - 
- (void)releaseAllSubViews
{

}

@end
