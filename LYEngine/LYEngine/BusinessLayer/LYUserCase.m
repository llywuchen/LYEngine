//
//  LYUserCase.m
//  LYEngineDemo
//
//  Created by lly on 16/6/14.
//  Copyright © 2016年 lly. All rights reserved.
//

#import "LYUserCase.h"
#import "LYModule.h"
#import "LYUserCaseManager.h"
#import "LYDefines.h"

@interface LYUserCase(){
    BOOL isOpen;
}


@end

@implementation LYUserCase

+ (__kindof LYModule *)belongModule{
    return [LYUserCaseManager belongModuleWithUserCaseClass:self];
}

+ (__kindof LYModule *)belongModuleWithUserCaseClass:(Class)userCaseClass{
    return [LYUserCaseManager belongModuleWithUserCaseClass:userCaseClass];
}

+ (instancetype)instance{
    LYModule *m = [self belongModule];
    return [m obtainUserCase:self];
}

+ (instancetype)instanceWithProtoco:(Protocol *)protocol{
    NSString *protocolStr = NSStringFromProtocol(protocol);
    
    LYAssert([protocolStr rangeOfString:@"UserCase"].length>0, @"UserCaseProtocol name invaid!!!");
    Class userCaseCass = NSClassFromString([protocolStr substringWithRange:NSMakeRange(0, [protocolStr rangeOfString:@"UserCase"].location+8)]);
    LYAssert(userCaseCass!=NULL, @"userCaseCass invalid!!!");
    LYModule *m = [self belongModuleWithUserCaseClass:userCaseCass];
    return [m obtainUserCase:userCaseCass];
}

- (void)open{
    if(isOpen) return;
    [self onOpen];
    isOpen = true;
}

- (void)close{
    if(!isOpen) return;
    [self onClose];
    isOpen = false;
}

- (void)onOpen{
    NSLog(@"%@ onOpen!",NSStringFromClass(self.class));
}

- (void)onClose{
    NSLog(@"%@ onClose!",NSStringFromClass(self.class));
}

- (void)dealloc{
    NSLog(@"%@ dealloc!",NSStringFromClass(self.class));
}
@end
