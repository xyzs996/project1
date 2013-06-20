//
//  PosCore.h
//  PosProject
//
//  Created by xiaofang.wu on 13-5-4.
//  Copyright (c) 2013年 xiaofang.wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PosUserManager.h"
#import "PosAcquireManager.h"

@interface PosCore : NSObject
@property (nonatomic,readonly,retain)PosUserManager* userManager;
@property (nonatomic,readonly,retain)PosAcquireManager* acquireManager;

+(PosCore*)sharedInstance;
@end
