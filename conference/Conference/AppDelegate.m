//
//  AppDelegate.m
//  Conference
//
//  Created by wu xiaofang on 13-6-14.
//  Copyright (c) 2013年 wu xiaofang. All rights reserved.
//

#import "AppDelegate.h"
#import "PosCore.h"
#import "PosLoginViewController.h"
@interface AppDelegate()<PosLoginDelegate>
- (void)loadSplitViewController;
- (void)handleLogoutNotification:(NSNotification*)notify;

@end
@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    if(![[PosCore sharedInstance].userManager isLogin]){
        [self presentLoginViewControl];
    }else{
        [self loadSplitViewController];
        self.window.rootViewController = self.splitViewController;
        
    }
    addObserverToNotificationCenter(self, @selector(handleLogoutNotification:), PosLogoutNotification);
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Internal
- (void)loadSplitViewController
{
    if(self.splitViewController == nil){
        NSMutableArray* splitVCS_ = [[NSMutableArray alloc] init];
        
        //左视图
        self.myMasterViewController = [[[MyMasterViewController alloc] init] autorelease];
        UINavigationController* rootNav = [[UINavigationController alloc] initWithRootViewController:self.myMasterViewController];
        [splitVCS_ addObject:rootNav];
        [rootNav release];
        
        //右视图
        self.myDetailViewController = [[[MyDetailViewController alloc] init] autorelease];
        UINavigationController* mapNav = [[UINavigationController alloc] initWithRootViewController:self.myDetailViewController];
        [splitVCS_ addObject:mapNav];
        [mapNav release];
        
        //分栏视图
        self.splitViewController = [[[UISplitViewController alloc] init] autorelease];
        self.splitViewController.viewControllers = splitVCS_;
        self.splitViewController.delegate = self.myDetailViewController;

    }
    self.window.rootViewController = self.splitViewController;

}

// handle logout notification
- (void)handleLogoutNotification:(NSNotification*)notify
{
    [self presentLoginViewControl];
    self.splitViewController = nil;
    self.myDetailViewController = nil;
    self.myMasterViewController = nil;
}
#pragma mark - Public
- (void)presentLoginViewControl
{
    
    PosLoginViewController* loginViewControl = [[PosLoginViewController alloc] init];
    loginViewControl.delegate = self;
  
    self.window.rootViewController = loginViewControl;
    [loginViewControl release];
    
}

#pragma mark - PosLoginDelegate

- (void)loginSuccess
{
    [self loadSplitViewController];
}

@end
