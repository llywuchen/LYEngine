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

@interface LYUserCase(){
    BOOL isOpen;
}


@end

@implementation LYUserCase

+ (__kindof LYModule *)belongModule{
    return [LYUserCaseManager belongModuleByUserCaseClass:self];
}

+ (instancetype)instance{
    LYModule *m = [self belongModule];
    return [m obtainUserCase:self];
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
@end
