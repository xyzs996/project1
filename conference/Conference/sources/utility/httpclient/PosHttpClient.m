//
//  PosHttpClient.m
//  PosProject
//
//  Created by xiaofang.wu on 13-5-4.
//  Copyright (c) 2013年 xiaofang.wu. All rights reserved.
//

#import "PosHttpClient.h"

#import "AFJSONRequestOperation.h"

#import "AFJSONRequestOperation.h"
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonHMAC.h>

#import "AFImageRequestOperation.h"
#import "JSONKit.h"
#import "NSString+Additions.h"


@interface PosHttpClient ()

@property (nonatomic, retain) NSString* testNonce;
@property (nonatomic, retain) NSString* testTimestamp;


-(void)signRequest:(NSMutableURLRequest*)request parameters:(NSDictionary*)parameters;
-(void)signRequest:(NSMutableURLRequest*)request parameters:(NSDictionary*)parameters includeUserAuth:(BOOL)includeUserAuth;

-(NSString*)OAuthTypeURLEncoding:(NSString*)str;
+(NSString*)userAgentString;
-(NSString*)URLWithoutQuery:(NSURL*)url;
-(NSString*)base64EncodeData:(NSData*)data;
-(NSString*)signClearText:(NSString*)text secret:(NSString*)secret;
@end


@implementation PosHttpClient
#pragma mark - Object Lifecycle
-(id)initWithBaseURL:(NSURL*)url{
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
//	[self setDefaultHeader:@"Accept" value:@"application/json"];
//    [[self valueForKey:@"defaultHeaders"] setObject:[PosHttpClient userAgentString] forKey:@"User-Agent"];
    self.parameterEncoding = AFJSONParameterEncoding;
    return self;
}

- (void)dealloc
{
    self.testNonce = nil;
    self.testTimestamp = nil;
    [super dealloc];
}


#pragma mark - Public
-(void)setMaxConcurrentOperations:(NSInteger)count
{
    [self.operationQueue setMaxConcurrentOperationCount:count];
}

-(NSInteger)activeRequestCount
{
    NSInteger count = 0;
    for(NSOperation* op in self.operationQueue.operations) {
        if(op.isExecuting) {
            ++count;
        }
    }
    return count;
}
-(void)performRequest:(NSMutableURLRequest*)request
           parameters:(NSDictionary*)params
              success:(HTTPSuccessBlock)success
              failure:(HTTPFailureBlock)failure
{
    
    [self signRequest:request parameters:params];
    AFHTTPRequestOperation* op = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    [self enqueueHTTPRequestOperation:op];
    
}
#pragma mark - Internal


-(void)signRequest:(NSMutableURLRequest*)request parameters:(NSDictionary*)parameters
{
    [self signRequest:request parameters:parameters includeUserAuth:YES];
}

-(void)signRequest:(NSMutableURLRequest*)request parameters:(NSDictionary*)parameters includeUserAuth:(BOOL)includeUserAuth
{
    
    NSMutableDictionary* additionalParameters = [NSMutableDictionary dictionaryWithDictionary:[request.URL.query dictionaryFromQueryString]];
    
    NSString* timestamp = [NSString stringWithFormat:@"%ld", time(NULL)];
    
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef nonce = CFUUIDCreateString(NULL, theUUID);
    [NSMakeCollectable (theUUID)autorelease];
    NSString* nonceObj = (NSString*)nonce;
    
    if(self.testNonce) nonceObj = self.testNonce;
    if(self.testTimestamp) timestamp = self.testTimestamp;
    
    //add the new oauth parameters to the list
    [additionalParameters setObject:self.useCryptographicSigning ? @"HMAC-SHA1": @"PLAINTEXT" forKey:@"oauth_signature_method"];
    [additionalParameters setObject:timestamp forKey:@"oauth_timestamp"];
    [additionalParameters setObject:nonceObj forKey:@"oauth_nonce"];
    [additionalParameters setObject:@"1.0" forKey:@"oauth_version"];

    NSMutableDictionary* allParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [allParameters addEntriesFromDictionary:additionalParameters];

    
    NSMutableArray* outStringArray = [NSMutableArray array];
    [[[allParameters allKeys] sortedArrayUsingSelector:@selector(compare:)] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
        [outStringArray addObject:[NSString stringWithFormat:@"%@=%@", [self OAuthTypeURLEncoding:obj], [self OAuthTypeURLEncoding:[allParameters objectForKey:obj]]]];
    }];
    NSString* signatureString = [NSString stringWithFormat:@"%@&%@&%@",
                                 request.HTTPMethod,
                                 [self OAuthTypeURLEncoding:[self URLWithoutQuery:request.URL]],
                                 [self OAuthTypeURLEncoding:[outStringArray componentsJoinedByString:@"&"]]
                                 ];

    
    NSString* signingKey = @"12345667";
    NSString* signedValue = [self signClearText:signatureString secret:signingKey];
    NSString* oauthHeader = [NSString stringWithFormat                                                                                                                :@"OAuth realm=\"\", oauth_signature_method=\"%@\", oauth_signature=\"%@\", oauth_timestamp=\"%@\", oauth_nonce=\"%@\",oauth_version=\"1.0\"",
                             [additionalParameters objectForKey:@"oauth_signature_method"],
                             [self OAuthTypeURLEncoding:signedValue],
                             timestamp,
                             nonceObj];
    [request addValue:oauthHeader forHTTPHeaderField:@"Authorization"];
    CFRelease(nonce);
}



#pragma mark -  method
//Mozilla/5.0 (iPhone Simulator; CPU iPhone OS 5_0 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Mobile/9A334
static NSString* AGENT_DICT_KEY = @"pos_user_agent";
static NSString* DEVICE_MODEL_KEY = @"model";
static NSString* DEVICE_VERSTION_KEY = @"version";
static NSString* AGENT_STRING_KEY = @"user_agent_string";
+(NSString*)userAgentString
{
    static dispatch_once_t onceToken;
    static NSString* userAgentStr = nil;
    dispatch_once(&onceToken, ^{
        UIDevice* device = [UIDevice currentDevice];
        NSString* newModel = [device model];
        NSString* newVersion = [device systemVersion];
        
        BOOL needUpdateCache = YES;
        NSUserDefaults* defaults= [NSUserDefaults standardUserDefaults];
        NSDictionary* userAgentDict = [defaults objectForKey:AGENT_DICT_KEY];
        if ([newModel isEqualToString:[userAgentDict objectForKey:DEVICE_MODEL_KEY]] &&
            [newVersion isEqualToString:[userAgentDict objectForKey:DEVICE_VERSTION_KEY]]) {
            needUpdateCache = NO;
            userAgentStr = [userAgentDict objectForKey:AGENT_STRING_KEY];
        }
        
        if (needUpdateCache) {
            UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectZero];
            userAgentStr= [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
            [webView release];
            
            userAgentDict = [NSDictionary dictionaryWithObjectsAndKeys:
                             newModel, DEVICE_MODEL_KEY,
                             newVersion, DEVICE_VERSTION_KEY,
                             userAgentStr, AGENT_STRING_KEY, nil];
            [defaults setObject:userAgentDict forKey:AGENT_DICT_KEY];
        }
        
        atexit_b (^{
            [userAgentStr release], userAgentStr = nil;
        });
    });
    
    return userAgentStr;
}
-(NSString*)OAuthTypeURLEncoding:(NSString*)str
{
    NSString* result = (NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                          (CFStringRef)str,
                                                                          NULL,
                                                                          CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                          kCFStringEncodingUTF8);
    [result autorelease];
    return result;
}
-(NSString*)URLWithoutQuery:(NSURL*)url
{
    return [[[url absoluteString] componentsSeparatedByString:@"?"] objectAtIndex:0];
}

-(NSString*)signClearText:(NSString*)text secret:(NSString*)secret
{
    //SHA1 HMAC
    NSData* secretData = [secret dataUsingEncoding:NSUTF8StringEncoding];
    NSData* clearTextData = [text dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[20];
    CCHmac(kCCHmacAlgSHA1, [secretData bytes], [secretData length], [clearTextData bytes], [clearTextData length], result);
    
    //then Base64
    return [self base64EncodeData:[NSData dataWithBytes:result length:20]];
}
-(NSString*)base64EncodeData:(NSData*)data
{
    NSUInteger length = [data length];
    NSMutableData* mutableData = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    
    uint8_t* input = (uint8_t*)[data bytes];
    uint8_t* output = (uint8_t*)[mutableData mutableBytes];
    
    for (NSUInteger i = 0; i < length; i += 3) {
        NSUInteger value = 0;
        for (NSUInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        static uint8_t const kAFBase64EncodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
        
        NSUInteger idx = (i / 3) * 4;
        output[idx + 0] = kAFBase64EncodingTable[(value >> 18) & 0x3F];
        output[idx + 1] = kAFBase64EncodingTable[(value >> 12) & 0x3F];
        output[idx + 2] = (i + 1) < length ? kAFBase64EncodingTable[(value >> 6)  & 0x3F] : '=';
        output[idx + 3] = (i + 2) < length ? kAFBase64EncodingTable[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[[NSString alloc] initWithData:mutableData encoding:NSASCIIStringEncoding] autorelease];
}


#pragma mark - AFHTTPClient overloads
-(NSMutableURLRequest*)requestWithMethod:(NSString*)method path:(NSString*)path parameters:(NSDictionary*)parameters
{
    NSMutableURLRequest* request = [super requestWithMethod:method path:path parameters:parameters];
    
    if ([method isEqualToString:@"GET"]) {
        [self signRequest:request parameters:parameters];
    } else {
        [self signRequest:request parameters:nil];
    }
    
    return request;
}
@end
