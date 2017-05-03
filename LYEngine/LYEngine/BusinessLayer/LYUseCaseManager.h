//
//  LYUseCaseManager.h
//  LYEngine
//
//  Created by lly on 16/7/21.
//  Copyright © 2016年 lly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYAssertionHandler.h"
@class LYUseCase;

@interface LYUseCaseManager : NSObject

- (void)registerUseCase:(Class) useCaseClass;

- (__kindof LYUseCase *)obtainUseCase:(Class) useCaseClass;

- (void)closeUseCase:(Class)useCaseClass;

- (void)closeAllUseCases;

@end
