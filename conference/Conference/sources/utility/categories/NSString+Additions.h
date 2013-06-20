//
//  NSString+Additions.h
//  PosProject
//
//  Created by xiaofang.wu on 13-5-4.
//  Copyright (c) 2013年 xiaofang.wu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(Additions)
-(NSString*)urLEncodedString;
-(NSString*)urlDecodedString;
-(NSMutableDictionary*)dictionaryFromQueryString;
@end
