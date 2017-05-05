//
//  LYURLProtocol.m
//  LYEngine
//
//  Created by lly on 2017/5/5.
//  Copyright © 2017年 franklin. All rights reserved.
//

#import "LYURLProtocol.h"
#import "NSObject+LYLock.h"
#define LYURLProtocolHandled @"LYURLProtocolHandled"

static NSMutableDictionary *_handerDic;

@interface LYURLProtocol ()

@property(nonatomic,strong) id<LYURLProtocolHander> handler;

@end

@implementation LYURLProtocol

+(void)initialize
{
    if(self == LYURLProtocol.class)
    {
        _handerDic = [NSMutableDictionary dictionary];
    }
}

+ (void)registerHandler:(Class<LYURLProtocolHander>)handlerClass
                   path:(NSString *)path{
    [_handerDic ly_lockObject];
    [_handerDic setObject:handlerClass forKey:path];
    [_handerDic ly_unlockObject];
}

+ (void)unregisterHandlerWithPath:(NSString *)path
{
    [_handerDic ly_lockObject];
    [_handerDic removeObjectForKey:path];
    [_handerDic ly_unlockObject];
}

#pragma mark -
#pragma mark - NSURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    if ([NSURLProtocol propertyForKey:LYURLProtocolHandled inRequest:request])
    {
        return NO;
    }
    
    if([request.URL.absoluteString containsString:LYURLProtocolHanderFlag])
    {
        return YES;
    }
    
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request;
}

- (void)startLoading
{
    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
    [LYURLProtocol setProperty:@(YES)
                        forKey:LYURLProtocolHanderFlag
                     inRequest:mutableReqeust];
    
    self.handler = nil;
    [_handerDic ly_lockObject];
        for(NSString *key in [_handerDic allKeys])
        {
            if([mutableReqeust.URL.path isEqualToString:key])
            {
                Class class = [_handerDic objectForKey:key];
                self.handler = [[class alloc]init];
                break;
            }
        }
    [_handerDic ly_unlockObject];
    
    LYURLProtocolResponse *protocolResponse = nil;
    
    if(![self.handler respondsToSelector:@selector(handleURLRequest:block:)])
    {
        protocolResponse = [[LYURLProtocolResponse alloc]init];
        protocolResponse.code = 400;
        protocolResponse.errorMessage = @"No response";
        [self handleProtocolResponse:protocolResponse];
    }
    else
    {
        [self.handler handleURLRequest:mutableReqeust
                                         block:^(LYURLProtocolResponse *response)
         {
             [self handleProtocolResponse:response];
         }];
    }
}

- (void)handleProtocolResponse:(LYURLProtocolResponse *)protocolResponse
{
    NSString *str = [protocolResponse jsonString];
    
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    //    NSURLResponse *response = [[NSURLResponse alloc] initWithURL:self.request.URL
    //                                                        MIMEType:@"text/json"
    //                                           expectedContentLength:data.length
    //                                                textEncodingName:nil];
    NSDictionary * headerFields = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",data.length], @"Content-Length", @"text/json",@"Content-Type", nil];
    NSHTTPURLResponse * response = [[NSHTTPURLResponse alloc] initWithURL:self.request.URL statusCode:200 HTTPVersion:@"HTTP/1.1" headerFields:headerFields];//statusCode == 200
    
    
    [self.client URLProtocol:self
          didReceiveResponse:response
          cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    
    [self.client URLProtocol:self didLoadData:data];
    [self.client URLProtocolDidFinishLoading:self];
    
    self.handler = 0;
}


- (void)stopLoading
{
    self.handler = 0;
}

@end
