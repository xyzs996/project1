//
//  PosParser.m
//  PosProject
//
//  Created by xiaofang.wu on 13-5-4.
//  Copyright (c) 2013年 xiaofang.wu. All rights reserved.
//

#import "PosParser.h"

@implementation PosParser
- (id)parseResponseData:(id)responseObject
{
    if(responseObject == nil || ![responseObject isKindOfClass:[NSDictionary class]]){
        return nil;
    }
    if([[responseObject objectForKey:@"status_code"] integerValue] != 0){
        self.errorCode = [NSString stringWithFormat:@"%d",[[responseObject objectForKey:@"status_code"] integerValue]] ;
        
        NSArray* messageArray = [responseObject objectForKey:@"error_msg"];
        if([messageArray isKindOfClass:[NSArray class]]&&messageArray.count >0)
        {
            self.errormessage = [messageArray objectAtIndex:0];
        }
        return nil;
    }
    return responseObject;
    
}

- (void)dealloc
{
    self.errormessage = nil;
    [super dealloc];
}

- (NSDictionary*)dictionarySerializableWithObject:(id)object key:(NSString*)key
{
    id dic = nil;
    if([object isKindOfClass:[NSDictionary class]]){
        dic = [object objectForKey:key];
        if(![dic isKindOfClass:[NSDictionary class]]){
            dic = nil;
        }
    }
    return dic;
}

- (NSArray*)arraySerializableWithObject:(id)object key:(NSString*)key
{
    id array = nil;
    if([object isKindOfClass:[NSDictionary class]]){
        array = [object objectForKey:key];
        if(![array isKindOfClass:[NSArray class]]){
            array = nil;
        }
    }
    return array;
}

- (NSString*)stringSerializableWithObject:(id)object key:(NSString*)key
{
    id str = nil;
    if([object isKindOfClass:[NSDictionary class]]){
        str = [object objectForKey:key];
        if(![str isKindOfClass:[NSString class]]){
            str = nil;
        }
    }
    return str;
}

- (BOOL)boolSerializableWithObject:(id)object key:(NSString*)key
{
    BOOL value = NO;
    if([object isKindOfClass:[NSDictionary class]]){
        if([[object objectForKey:key] respondsToSelector:@selector(integerValue)]){
            value = [[object objectForKey:key] integerValue];
        }
    }
    return value;
}

- (NSURL*)urlSerializableWithObject:(id)object key:(NSString*)key
{
    id str = nil;
    if([object isKindOfClass:[NSDictionary class]]){
        
        str = [object objectForKey:key];
        if([str isKindOfClass:[NSString class]]){
            return [NSURL URLWithString:str];
        }
    }
    return nil;
}


- (NSMutableDictionary*)userInfoForParse:(NSDictionary*)parameters
{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    if(parameters){
        [dic setDictionary:parameters];

    }
    [dic setValue:self.errorCode forKey:PosHttpErrorCode];
    if(self.errormessage){
        [dic setValue:self.errormessage forKey:PosHttpErrorMessage];
    }
    return [dic autorelease];
}

+ (NSMutableDictionary*)parseHttpError:(NSError*)error parameter:(NSDictionary*)parameters
{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    if(parameters){
        [dic setDictionary:parameters];
    }
    [dic setValue:[NSString stringWithFormat:@"%d",error.code] forKey:PosHttpErrorCode];
    [dic setValue:@"您的网络有问题" forKey:PosHttpErrorMessage];
    return [dic autorelease];
}

@end


@implementation PosLoginParser
- (id)parseResponseData:(id)responseObject
{
    if([super parseResponseData:responseObject]){
        NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithCapacity:1];

        return dic;
    }
    return  nil;
}

@end

