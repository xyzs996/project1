//
//  PosUserManager.h
//  PosProject
//
//  Created by xiaofang.wu on 13-5-4.
//  Copyright (c) 2013年 xiaofang.wu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PosUserManager : NSObject

- (BOOL)isLogin;

// http
- (void)loginWithUsername:(NSString*)username password:(NSString*)password;
- (void)checkInToServer;
@end
