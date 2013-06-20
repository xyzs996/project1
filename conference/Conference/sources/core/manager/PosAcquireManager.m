//
//  PosAcquireManager.m
//  PosProject
//
//  Created by wu xiaofang on 13-6-13.
//  Copyright (c) 2013年 xiaofang.wu. All rights reserved.
//

#import "PosAcquireManager.h"
#import "PosHttpClient.h"
#import "PosParser.h"
@interface PosAcquireManager()
@property (nonatomic,retain)PosHttpClient* httpClient;
- (void)initHttpClient;

@end

@implementation PosAcquireManager
#pragma mark - Object Lifecycle
- (id)init
{
    self = [super init];
    if(self){
        [self initHttpClient];
    }
    return self;
}

- (void)dealloc
{
    self.httpClient = nil;
    [super dealloc];
}

#pragma mark - Internal
- (void)initHttpClient
{
    self.httpClient = [[[PosHttpClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://m.weather.com.cn"]] autorelease];
}

#pragma mark - http method


@end
