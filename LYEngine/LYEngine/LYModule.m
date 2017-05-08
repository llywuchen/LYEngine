//
//  LYModule.m
//  LYEngine
//
//  Created by lly on 2017/5/5.
//  Copyright © 2017年 franklin. All rights reserved.
//

#import "LYModule.h"
#import "LYDefines.h"

@interface LYModule(){
    
}
@property (nonatomic,assign) BOOL isOnload;

@end

@implementation LYModule

+ (instancetype)sharedInstance
{
    static LYModule *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)onModuleInstlled{
    [self initRouter];
}

- (void)onModuleUninstalled{
    [self unInitRouter];
}

#pragma mark - register
+ (void)install{
    LYModule * m = [self sharedInstance];
    if(m.isOnload){
        LYAssert(true, @"the Module:%@ has Registered !",NSStringFromClass(m.class));
    }else{
        m.isOnload = YES;
        [m onModuleInstlled];
    }
}

+ (void)unInstall{
    LYModule * m = [self sharedInstance];
    if(!m.isOnload){
        LYAssert(true, @"the Module:%@ has Unregistered !",NSStringFromClass(m.class));
    }else{
        m.isOnload = NO;
        [m onModuleUninstalled];
    }
}

+ (BOOL)isInstalled{
    return ((LYModule *)[self sharedInstance]).isOnload;
}


#pragma mark - router
- (void)initRouter{
    //overWrite
}

- (void)unInitRouter{
    //overWrite
}

@end
