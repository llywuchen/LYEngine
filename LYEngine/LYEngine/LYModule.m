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
#import "LYUserCaseManager.h"

static NSMutableDictionary *_moduleDic;
@interface LYModule(){
    
}
@property (nonatomic,assign) BOOL isOnload;
@property (nonatomic,strong) LYUserCaseManager *userCaseManager;

@end

@implementation LYModule

+ (void)load{
    if(self==LYModule.class){
        _moduleDic = [NSMutableDictionary dictionary];
    }
}

+ (LYModule *)sharedInstance
{
    static LYModule *shareInstance = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        shareInstance = [[LYModule alloc]init];
    });
    return shareInstance;
}

+ (instancetype)instance{
    [_moduleDic ly_lockObject];
    LYModule *moudule = [_moduleDic objectForKey:NSStringFromClass(self.class)];
    [_moduleDic ly_unlockObject];
    return moudule;
}

- (instancetype)init{
    self = [super init];
    if(self){
        self.userCaseManager = [LYUserCaseManager sharedInstance];
    }
    return self;
}

- (void)initEnvironment{
    NSLog(@"Module : %@ initEnvironment!",NSStringFromClass(self.class));
}

- (void)onModuleInstlled{
    NSLog(@"Module : %@ installed!",NSStringFromClass(self.class));
    [self initEnvironment];
    [self initRouter];
    [self registerUserCase];
}

- (void)onModuleUninstalled{
    NSLog(@"Module : %@ unInstalled!",NSStringFromClass(self.class));
    [self unInitRouter];
    [self clearnUpUserCase];
}

- (void)registerUserCase{
    NSLog(@"registerUserCase");
}

- (void)clearnUpUserCase{
    NSLog(@"clearnUpUserCase");
    [self.userCaseManager closeAllUserCasesWithBelongModuleClass:self.class];
}


#pragma mark - register
+ (void)install{
    LYAssert(self!=[LYModule class], @"to be installed module must extends LYModule!!!");
    LYModule * m = [self instance];
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
    LYAssert(self!=[LYModule class], @"to be installed module must extends LYModule!!!");
    LYModule * m = [self instance];
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
    LYAssert(self!=[LYModule class], @"to be installed module must extends LYModule!!!");
    return ((LYModule *)[self instance]).isOnload;
}

#pragma maark - useCase
- (void)registerUserCase:(Class) userCaseClass{
//    NSLog(@"registerUserCase:%@",NSStringFromClass(userCaseClass));
    [self.userCaseManager registerUserCase:userCaseClass belongModuleClass:self.class];
}

- (__kindof LYUserCase *)obtainUserCase:(Class) userCaseClass{
    return [self.userCaseManager obtainUserCase:userCaseClass belongModuleClass:self.class];
}

- (void)closeUserCase:(Class)userCaseClass{
    return [self.userCaseManager closeUserCase:userCaseClass belongModuleClass:self.class];
}

#pragma mark - router
- (void)initRouter{
    //overWrite
}

- (void)unInitRouter{
    //overWrite
}

#pragma mark - env
- (NSString *)APIHost{
    if(_APIHost.length>0){
        return _APIHost;
    }else{
        LYAssert(self.class!=[LYModule class], @"LYModule Environment APIHost must be inited!!!");
        return [self.class sharedInstance].APIHost;
    }
}

- (NSString *)H5Host{
    if(_H5Host.length>0){
        return _H5Host;
    }else{
        LYAssert(self.class!=[LYModule class], @"LYModule Environment H5Host must be inited!!!");
        return [self.class sharedInstance].H5Host;
    }
}

- (NSDictionary *)APIPublicParams{
    if(_APIPublicParams){
        return _APIPublicParams;
    }else{
        LYAssert(self.class!=[LYModule class], @"LYModule Environment APIPublicParams must be inited!!!");
        return [self.class sharedInstance].APIPublicParams;
    }
}

@end
