//
//  LYUseCaseManager.m
//  LYEngine
//
//  Created by lly on 16/7/21.
//  Copyright © 2016年 lly. All rights reserved.
//

#import "LYUseCaseManager.h"
#import "LYWeakMutableArray.h"
#import "LYUseCase.h"
#import "LYDefines.h"

@implementation LYUseCaseManager{
    NSMutableSet<Class> *useCaseTypes;
    LYWeakMutableArray *useCaseRefs;
}

- (instancetype)init{
    self = [super init];
    if(self){
        useCaseTypes = [NSMutableSet set];
        useCaseRefs = [LYWeakMutableArray new];
    }
    return self;
}

- (void)registerUseCase:(Class) useCaseClass{
    LYAssert(![useCaseTypes containsObject:useCaseClass], @"%@ has registered",NSStringFromClass(useCaseClass));
    [useCaseTypes addObject:useCaseClass];
}

- (__kindof LYUseCase *)obtainUseCase:(Class) useCaseClass{
    LYAssert([useCaseTypes containsObject:useCaseClass], @"%@ has not registered",NSStringFromClass(useCaseClass));
    __block id<LYUseCaseDelegate> useCase = nil;
    [useCaseRefs.allObjects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(!obj){
            [useCaseRefs removeObjectAtIndex:idx];
        }else if([obj isKindOfClass:useCaseClass]){
            [obj open];
            useCase = obj;
            *stop = YES;
        }
    }];
    if(!useCase){
        useCase = [useCaseClass new];
        [useCase open];
    }
    
    return (__kindof LYUseCase *)useCase;
}

- (void)closeUseCase:(Class)useCaseClass{
    LYAssert(![useCaseTypes containsObject:useCaseClass], @"%@ has not registered",NSStringFromClass(useCaseClass));
    [useCaseRefs.allObjects enumerateObjectsUsingBlock:^(id<LYUseCaseDelegate>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(!obj){
            [useCaseRefs removeObjectAtIndex:idx];
        }else if([obj isKindOfClass:useCaseClass]){
            [obj close];
            *stop = YES;
        }
    }];
}

- (void)closeAllUseCases{
    [useCaseRefs.allObjects enumerateObjectsUsingBlock:^(id<LYUseCaseDelegate>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(!obj){
            [useCaseRefs removeObjectAtIndex:idx];
        }else{
            [obj close];
        }
    }];
}
@end
