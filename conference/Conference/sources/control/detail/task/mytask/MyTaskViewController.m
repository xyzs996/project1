//
//  MyTaskViewController.m
//  Conference
//
//  Created by wu xiaofang on 13-6-15.
//  Copyright (c) 2013年 wu xiaofang. All rights reserved.
//

#import "MyTaskViewController.h"

@interface MyTaskViewController ()

@end

@implementation MyTaskViewController

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
    self.title = @"我的任务";
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
