//
//  PosLoginViewController.m
//  Conference
//
//  Created by wu xiaofang on 13-6-15.
//  Copyright (c) 2013年 wu xiaofang. All rights reserved.
//

#import "PosLoginViewController.h"

@interface PosLoginViewController ()
- (void)handleLoginNotification:(NSNotification*)notify;
@end

@implementation PosLoginViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    addObserverToNotificationCenter(self, @selector(handleLoginNotification:), PosLoginNotification);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    removeObserverFromNotificationCenter(self);
}

- (void)releaseAllSubViews
{
    [super releaseAllSubViews];

}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
//    CGFloat viewWidth = self.view.bounds.size.width;
//    self.loginButton.frame = CGRectMake(20, 130, viewWidth - 40, 35);
    
}
// button press

- (void)loginButtonPress
{
    //    [[PosCore sharedInstance].userManager loginWithUsername:@"" password:@""];
    if(self.delegate&&[self.delegate respondsToSelector:@selector(loginSuccess)]){
        [self.delegate loginSuccess];
    }
}

#pragma mark - handle Notification

- (void)handleLoginNotification:(NSNotification*)notify
{
    NSDictionary* userInfor = [notify userInfo];
    if([[userInfor objectForKey:PosHttpErrorCode] integerValue] == 0){
        if(self.delegate&&[self.delegate respondsToSelector:@selector(loginSuccess)]){
            [self.delegate loginSuccess];
        }
        
    }else{
        
    }
}
@end
