//
//  LYUserCase.m
//  LYEngineDemo
//
//  Created by lly on 16/6/14.
//  Copyright © 2016年 lly. All rights reserved.
//

#import "LYUseCase.h"

@interface LYUseCase(){
    BOOL isOpen;
}

@end

@implementation LYUseCase

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
    
}

- (void)onClose{
    
}
@end
