//
//  LYUserCaseManager.h
//  LYEngine
//
//  Created by lly on 16/7/21.
//  Copyright © 2016年 lly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYAssertionHandler.h"
@class LYUserCase;
@class LYModule;

@interface LYUserCaseManager : NSObject

+ (LYUserCaseManager *)sharedInstance;

+ (__kindof LYModule *)belongModuleWithUserCaseClass:(Class) userCaseClass;

- (void)registerUserCase:(Class) userCaseClass belongModuleClass:(Class)moduleClass;

- (__kindof LYUserCase *)obtainUserCase:(Class) userCaseClass belongModuleClass:(Class)moduleClass;

- (void)closeUserCase:(Class)userCaseClass belongModuleClass:(Class)moduleClass;

- (void)closeAllUserCasesWithBelongModuleClass:(Class)moduleClass;


@end
