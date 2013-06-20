//
//  AppDelegate.h
//  Conference
//
//  Created by wu xiaofang on 13-6-14.
//  Copyright (c) 2013年 wu xiaofang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyMasterViewController.h"
#import "MyDetailViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (nonatomic,retain)UISplitViewController* splitViewController;
@property (nonatomic,retain)MyMasterViewController* myMasterViewController;
@property (nonatomic,retain)MyDetailViewController* myDetailViewController;

@property (strong, nonatomic) UIWindow *window;
- (void)presentLoginViewControl;
@end
