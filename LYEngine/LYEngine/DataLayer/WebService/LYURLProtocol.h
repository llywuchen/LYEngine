//
//  LYURLProtocol.h
//  LYEngine
//
//  Created by lly on 2017/5/5.
//  Copyright © 2017年 franklin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYURLProtocolResponse.h"
#define LYURLProtocolHanderFlag @"_mobile_bridge=1"

typedef void (^LYURLProtocolBLock)(LYURLProtocolResponse *response);

@protocol LYURLProtocolHander <NSObject>

- (void)handleURLRequest:(NSURLRequest *)request block:(LYURLProtocolBLock)block;

@end

@interface LYURLProtocol : NSURLProtocol

+ (void)registerHandler:(Class<LYURLProtocolHander>)handlerClass
                   path:(NSString *)path;

@end
