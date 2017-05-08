//
//  LYModule.h
//  LYEngine
//
//  Created by lly on 2017/5/5.
//  Copyright © 2017年 franklin. All rights reserved.
//

#import "MGJRouter.h"

@interface LYModule : MGJRouter

+ (instancetype)sharedInstance;

+ (void)install;
+ (void)unInstall;
+ (BOOL)isInstalled;

- (void)initRouter;
- (void)unInitRouter;

- (void)onModuleInstlled;

- (void)onModuleUninstalled;



@end
