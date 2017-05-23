//
//  LYUserCase.h
//  LYEngineDemo
//
//  Created by lly on 16/6/14.
//  Copyright © 2016年 lly. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LYModule;
//#import "LYMessageEngine.h"

@protocol LYUserCaseDelegate <NSObject>

- (void)open;
- (void)close;

@end

@interface LYUserCase : NSObject//LYMessageHandle
- (void)onOpen;
- (void)onClose;

+ (instancetype)instance;
+ (instancetype)instanceWithProtoco:(Protocol *)protocol;
+ (__kindof LYModule *)belongModule;
@end
