//
//  LYAssertionHander.m
//  LYEngine
//
//  Created by lly on 16/5/27.
//  Copyright © 2016年 lly. All rights reserved.
//

#import "LYAssertionHandler.h"

@implementation LYAssertionHandler

//处理Objective-C的断言
- (void)handleFailureInMethod:(SEL)selector object:(id)object file:(NSString *)fileName lineNumber:(NSInteger)line description:(NSString *)format,...
{
    NSLog(@"NSAssert Failure: Method %@ for object %@ in %@#%li", NSStringFromSelector(selector), object, fileName, (long)line);
    exit(0);
}

//处理C的断言
- (void)handleFailureInFunction:(NSString *)functionName file:(NSString *)fileName lineNumber:(NSInteger)line description:(NSString *)format,...
{
    NSLog(@"NSCAssert Failure: Function (%@) in %@#%li", functionName, fileName, (long)line);
    exit(0);
}

@end
