//
//  PosLoginViewController.h
//  Conference
//
//  Created by wu xiaofang on 13-6-15.
//  Copyright (c) 2013年 wu xiaofang. All rights reserved.
//

//#import <UIKit/UIKit.h>
//
//@interface PosLoginViewController : UIViewController
//
//@end

#import "PosBaseViewController.h"

@protocol PosLoginDelegate <NSObject>
- (void)loginSuccess;
@end
@interface PosLoginViewController : PosBaseViewController
@property (nonatomic,assign)id<PosLoginDelegate>delegate;
@property (nonatomic,retain)IBOutlet UIButton* loginButton;
@property (nonatomic,retain)IBOutlet UITextField* usernameTextField;
@property (nonatomic,retain)IBOutlet UITextField* passwordTextField;
- (IBAction)loginButtonPress;
@end