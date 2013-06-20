//
//  PosNotificationConstant.m
//  PosProject
//
//  Created by wu xiaofang on 13-6-7.
//  Copyright (c) 2013年 xiaofang.wu. All rights reserved.
//

#import "PosNotificationConstant.h"

void sendNotification(NSString* notification, NSDictionary* dic)
{
    [[NSNotificationCenter defaultCenter] postNotificationName:notification object:nil userInfo:dic];
}

void addObserverToNotificationCenter(id observer,SEL selector,NSString* notification)
{
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:notification object:nil];
}
void removeObserverFromNotificationCenter(id observer)
{
    [[NSNotificationCenter defaultCenter] removeObserver:observer];
}


NSString* const PosLoginNotification = @"LoginNotification";
NSString* const PosLogoutNotification = @"LoginNotification";