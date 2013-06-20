//
//  PosNotificationConstant.h
//  PosProject
//
//  Created by wu xiaofang on 13-6-7.
//  Copyright (c) 2013年 xiaofang.wu. All rights reserved.
//

#import <Foundation/Foundation.h>
void sendNotification(NSString* notification, NSDictionary* dic);
void addObserverToNotificationCenter(id observer,SEL selector,NSString* notification);
void removeObserverFromNotificationCenter(id observer);
// login notification 
extern NSString* const PosLoginNotification;
extern NSString* const PosLogoutNotification;