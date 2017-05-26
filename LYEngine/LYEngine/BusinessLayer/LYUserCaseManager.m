//
//  LYUserCaseManager.m
//  LYEngine
//
//  Created by lly on 16/7/21.
//  Copyright © 2016年 lly. All rights reserved.
//

#import "LYUserCaseManager.h"
#import "LYWeakMutableArray.h"
#import "LYUserCase.h"
#import "LYDefines.h"

@interface LYUserCaseManager ()

@property (nonatomic,strong) NSMutableDictionary *userCaseToModuleDic;

@end

@implementation LYUserCaseManager{
//    NSMutableSet<Class> *userCaseTypes;
//    LYWeakMutableArray *userCaseRefs;
    NSMutableDictionary<NSString *,NSMutableArray *> *userCaseRefDic;
}

+ (LYUserCaseManager *)sharedInstance{
    static LYUserCaseManager *intance = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        intance = [[LYUserCaseManager alloc]init];
    });
    return intance;
}

+ (Class)belongModuleClassWithUserCaseClass:(Class) userCaseClass{
    NSString *userCaseKey = [NSString stringWithFormat:@"%p",userCaseClass];
    
    LYAssert([[self sharedInstance].userCaseToModuleDic objectForKey:userCaseKey], @"%@ has not registered",NSStringFromClass(userCaseClass));
    Class moduleClass = [[self sharedInstance].userCaseToModuleDic objectForKey:userCaseKey];
    return moduleClass;
}

+ (__kindof LYModule *)belongModuleWithUserCaseClass:(Class) userCaseClass{
    Class moduleClass = [self belongModuleClassWithUserCaseClass:userCaseClass];
    return (LYModule *)[moduleClass instance];
}

- (instancetype)init{
    self = [super init];
    if(self){
        userCaseRefDic = [NSMutableDictionary dictionary];
        _userCaseToModuleDic = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)registerUserCase:(Class)userCaseClass belongModuleClass:(Class)moduleClass{
    NSString *userCaseKey = [NSString stringWithFormat:@"%p",userCaseClass];
    LYAssert(![_userCaseToModuleDic objectForKey:userCaseKey], @"%@ has registered",NSStringFromClass(userCaseClass));
    [_userCaseToModuleDic setObject:moduleClass forKey:userCaseKey];
}

- (__kindof LYUserCase *)obtainUserCase:(Class) userCaseClass belongModuleClass:(Class )moduleClass{
    NSString *userCaseKey = [NSString stringWithFormat:@"%p",userCaseClass];
    LYAssert([_userCaseToModuleDic objectForKey:userCaseKey], @"%@ has not registered",NSStringFromClass(userCaseClass));
    NSString *modueKey = [NSString stringWithFormat:@"%p",moduleClass];
    __block id<LYUserCaseDelegate> userCase = nil;
    __block NSMutableArray *array = [userCaseRefDic objectForKey:modueKey];
    if(array){
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([obj isKindOfClass:userCaseClass]){
                userCase = obj;
                *stop = YES;
            }
        }];
        if(!userCase){
            userCase = [[userCaseClass alloc]init];
            [userCase open];
            [array addObject:userCase];
        }
        
    }else{
        userCase = [[userCaseClass alloc]init];
        [userCase open];
        array = [[NSMutableArray alloc]init];
        [array addObject:userCase];
        [userCaseRefDic setObject:array forKey:modueKey];
    }
    
    
    return (__kindof LYUserCase *)userCase;
}

- (void)closeUserCase:(Class)userCaseClass belongModuleClass:(Class )moduleClass{
    NSString *userCaseKey = [NSString stringWithFormat:@"%p",userCaseClass];
    LYAssert([_userCaseToModuleDic objectForKey:userCaseKey], @"%@ has not registered",NSStringFromClass(userCaseClass));
    NSString *modueKey = [NSString stringWithFormat:@"%p",moduleClass];
    NSMutableArray *array = [userCaseRefDic objectForKey:modueKey];
    
    [array enumerateObjectsUsingBlock:^(id<LYUserCaseDelegate>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj&&[obj isKindOfClass:userCaseClass]){
            [obj close];
            *stop = YES;
        }
    }];
}

- (void)closeAllUserCasesWithBelongModuleClass:(Class )moduleClass{
    NSString *modueKey = [NSString stringWithFormat:@"%p",moduleClass];
    NSMutableArray *array = [userCaseRefDic objectForKey:modueKey];
    
    [array enumerateObjectsUsingBlock:^(id<LYUserCaseDelegate>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj&&[obj respondsToSelector:@selector(close)]){
            [obj close];
        }
    }];
    
    [userCaseRefDic removeObjectForKey:modueKey];
}
@end
