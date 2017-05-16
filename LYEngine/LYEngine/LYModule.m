//
//  LYModule.m
//  LYEngine
//
//  Created by lly on 2017/5/5.
//  Copyright © 2017年 franklin. All rights reserved.
//

#import "LYModule.h"
#import "LYDefines.h"
#import "NSObject+LYLock.h"
#import "LYUseCaseManager.h"

static NSMutableDictionary *_moduleDic;
@interface LYModule(){
    
}
@property (nonatomic,assign) BOOL isOnload;
@property (nonatomic,strong) LYUseCaseManager *userCaseManager;

@end

@implementation LYModule

+ (void)load{
    if(self==LYModule.class){
        _moduleDic = [NSMutableDictionary dictionary];
    }
}

+ (instancetype)sharedInstance
{
    [_moduleDic ly_lockObject];
    LYModule *moudule = [_moduleDic objectForKey:NSStringFromClass(self.class)];
    [_moduleDic ly_unlockObject];
    return moudule;
}

- (void)onModuleInstlled{
    NSLog(@"Module : %@ installed!",NSStringFromClass(self.class));
    [self initRouter];
}

- (void)onModuleUninstalled{
    NSLog(@"Module : %@ unInstalled!",NSStringFromClass(self.class));
    [self unInitRouter];
}

#pragma mark - register
+ (void)install{
    LYModule * m = [self sharedInstance];
    if(m){
        LYAssert(false, @"the Module:%@ has Registered !",NSStringFromClass(m.class));
    }else{
        m = [[self alloc]init];
        [_moduleDic ly_lockObject];
        [_moduleDic setObject:m forKey:NSStringFromClass(self.class)];
        [_moduleDic ly_unlockObject];
        
        m.isOnload = YES;
        [m onModuleInstlled];
    }
}

+ (void)unInstall{
    LYModule * m = [self sharedInstance];
    if(!m){
        LYAssert(false, @"the Module:%@ has Unregistered !",NSStringFromClass(m.class));
    }else{
        m.isOnload = NO;
        [m onModuleUninstalled];
        [_moduleDic ly_lockObject];
        [_moduleDic removeObjectForKey:NSStringFromClass(self.class)];
        [_moduleDic ly_unlockObject];
        m = nil;
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
