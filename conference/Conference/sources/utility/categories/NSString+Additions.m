//
//  NSString+Additions.m
//  PosProject
//
//  Created by xiaofang.wu on 13-5-4.
//  Copyright (c) 2013年 xiaofang.wu. All rights reserved.
//

#import "NSString+Additions.h"
#import "base64.h"
#import <CommonCrypto/CommonHMAC.h>

#define IS_SURROGATE_PAIRS_HIGH_SURROGATE(unichar) (0xD800 <= (unichar) && (unichar) <= 0xDBFF)
#define IS_SURROGATE_PAIRS_LOW_SURROGATE(unichar)  (0xDC00 <= (unichar) && (unichar) <= 0xDFFF)
#define IS_REGIONAL_INDICATOR(unichar)             (0xDDE6 <= (unichar) && (unichar) <= 0xDDFF)
#define IS_COMBINING_CHARACTER(unichar)            ((unichar) == 0x20E3)
static const int kSurrogatePairNSStringLength = 2;
@implementation NSString(Additions)

-(NSString*)urLEncodedString
{
    NSString* anEncodedString = (NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, CFSTR("!*'();:@&=+$,/?%#[]"), kCFStringEncodingUTF8);
    [anEncodedString autorelease];
    return anEncodedString;
}

-(NSString*)urlDecodedString
{
    NSString* aDecodedString = (NSString*)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)self, CFSTR(""), kCFStringEncodingUTF8);
    [aDecodedString autorelease];
    return aDecodedString;
}

-(NSMutableDictionary*)dictionaryFromQueryString
{
    id pairs = [self componentsSeparatedByString:@"&"];
    id params = [NSMutableDictionary dictionaryWithCapacity:[pairs count]];
    for (NSString* aPair in pairs) {
        id keyAndValue = [aPair componentsSeparatedByString:@"="];
        if ([keyAndValue count] == 2) {
            [params setObject:[(NSString*)[keyAndValue objectAtIndex:1] urlDecodedString]
                       forKey:[(NSString*)[keyAndValue objectAtIndex:0] urlDecodedString]];
        }
    }
    return params;
}
@end
