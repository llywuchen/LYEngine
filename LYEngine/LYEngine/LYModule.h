//
//  LYModule.h
//  LYEngine
//
//  Created by lly on 2017/5/5.
//  Copyright © 2017年 franklin. All rights reserved.
//

#import "MGJRouter.h"
#import "LYUserCase.h"

@interface LYModule : MGJRouter

@property (nonatomic,copy) NSString *APIHost;
@property (nonatomic,copy) NSDictionary *APIPublicParams;
@property (nonatomic,copy) NSString *H5Host;
@property (nonatomic,copy) NSBundle *bundle;


+ (LYModule *)sharedInstance;
+ (instancetype)instance;

+ (void)install;
+ (void)unInstall;
+ (BOOL)isInstalled;

- (void)initEnvironment;
- (void)initRouter;
- (void)unInitRouter;

- (void)onModuleInstlled;

- (void)onModuleUninstalled;

- (void)registerUserCase;
- (void)clearnUpUserCase;

- (void)registerUserCase:(Class) userCaseClass;
- (__kindof LYUserCase *)obtainUserCase:(Class) userCaseClass;
- (void)closeUserCase:(Class)userCaseClass;


@end
