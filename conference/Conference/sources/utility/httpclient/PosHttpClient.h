//
//  PosHttpClient.h
//  PosProject
//
//  Created by xiaofang.wu on 13-5-4.
//  Copyright (c) 2013年 xiaofang.wu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFHTTPClient.h"
typedef void (^HTTPSuccessBlock)(AFHTTPRequestOperation*, id);
typedef void (^HTTPFailureBlock)(AFHTTPRequestOperation*, NSError*);

@interface PosHttpClient : AFHTTPClient
-(id)initWithBaseURL:(NSURL*)url;
-(void)setMaxConcurrentOperations:(NSInteger)count;
-(NSInteger)activeRequestCount;
-(void)signRequest:(NSMutableURLRequest*)request parameters:(NSDictionary*)parameters;

-(void)performRequest:(NSMutableURLRequest*)request
           parameters:(NSDictionary*)params
              success:(HTTPSuccessBlock)success
              failure:(HTTPFailureBlock)failure;
@property (nonatomic, assign) BOOL useCryptographicSigning;
@end
