//
//  PosParser.h
//  PosProject
//
//  Created by xiaofang.wu on 13-5-4.
//  Copyright (c) 2013年 xiaofang.wu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PosParser : NSObject
@property (nonatomic,retain)NSString* errormessage;
@property (nonatomic,retain)NSString* errorCode;

- (id)parseResponseData:(id)responseObject;

- (NSDictionary*)dictionarySerializableWithObject:(id)object key:(NSString*)key;
- (NSArray*)arraySerializableWithObject:(id)object key:(NSString*)key;
- (NSString*)stringSerializableWithObject:(id)object key:(NSString*)key;
- (NSURL*)urlSerializableWithObject:(id)object key:(NSString*)key;
- (BOOL)boolSerializableWithObject:(id)object key:(NSString*)key;

- (NSMutableDictionary*)userInfoForParse:(NSDictionary*)parameters;
+ (NSMutableDictionary*)parseHttpError:(NSError*)error parameter:(NSDictionary*)parameters;

@end


@interface PosLoginParser : PosParser

@end
