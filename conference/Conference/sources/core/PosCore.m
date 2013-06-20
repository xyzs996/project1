//
//  PosCore.m
//  PosProject
//
//  Created by xiaofang.wu on 13-5-4.
//  Copyright (c) 2013年 xiaofang.wu. All rights reserved.
//

#import "PosCore.h"

static PosCore* _sharedInstance = nil;

@interface PosCore ()
@property (nonatomic,readwrite,retain)PosUserManager* userManager;
@property (nonatomic,readwrite,retain)PosAcquireManager* acquireManager;

- (void)initManager;
@end
@implementation PosCore

#pragma mark - object lifecycle
+(PosCore*)sharedInstance
{
    @synchronized([PosCore class])
    {
        if (!_sharedInstance)
            [[self alloc] init];
        
        return _sharedInstance;
    }
    return nil;
}

+(id)alloc
{
    @synchronized([PosCore class])
    {
        NSAssert(_sharedInstance == nil, @"Attempted to allocate a second instance of a singleton.\n");
        _sharedInstance = [super alloc];
        return _sharedInstance;
    }
    return nil;
}

-(id)init {
    self = [super init];
    if (self != nil) {
        // initialize stuff here
        [self initManager];
    }
    return self;
}


- (void)dealloc
{
    self.userManager = nil;
    self.acquireManager = nil;
    [super dealloc];
}

#pragma mark - internal
- (void)initManager
{
    self.userManager = [[[PosUserManager alloc] init] autorelease];
    self.acquireManager = [[[PosAcquireManager alloc] init] autorelease];
}
@end
