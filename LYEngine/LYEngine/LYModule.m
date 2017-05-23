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

+ (instancetype)sharedInstance
{
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

- (void)onModuleInstlled{
    NSLog(@"Module : %@ installed!",NSStringFromClass(self.class));
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

@end
