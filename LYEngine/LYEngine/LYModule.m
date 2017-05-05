//
//  LYModule.m
//  LYEngine
//
//  Created by lly on 2017/5/5.
//  Copyright © 2017年 franklin. All rights reserved.
//

#import "LYModule.h"

@implementation LYModule

- (instancetype)init{
    self = [super init];
    if(self){
        [self.class registerRouter];
    }
    return self;
}

+ (void)registerRouter{
    //
}

@end
