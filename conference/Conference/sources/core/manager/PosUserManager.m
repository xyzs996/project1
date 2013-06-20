//
//  PosUserManager.m
//  PosProject
//
//  Created by xiaofang.wu on 13-5-4.
//  Copyright (c) 2013年 xiaofang.wu. All rights reserved.
//

#import "PosUserManager.h"
#import "PosHttpClient.h"
#import "PosParser.h"
@interface PosUserManager()
@property (nonatomic,retain)PosHttpClient* httpClient;
- (void)initHttpClient;


- (void)loginSuccess:(NSDictionary*)responseObject;
@end

@implementation PosUserManager
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

#pragma mark - Public
- (BOOL)isLogin
{
    return NO;
}

#pragma mark - http method
- (void)loginWithUsername:(NSString*)username password:(NSString*)password
{
    [self.httpClient getPath:@"/data/101010100.html" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self loginSuccess:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        sendNotification(PosLoginNotification, [PosParser parseHttpError:error parameter:nil]);

    }];
}

- (void)loginSuccess:(NSDictionary*)responseObject
{
    PosLoginParser* parser = [[PosLoginParser alloc] init];
    if([parser parseResponseData:responseObject]){
        sendNotification(PosLoginNotification, [parser userInfoForParse:nil]);
    }else{
        sendNotification(PosLoginNotification, [parser userInfoForParse:nil]);
    }
}
- (void)checkInToServer
{

}


@end
