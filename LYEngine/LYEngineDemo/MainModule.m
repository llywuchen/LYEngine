//
//  MainModule.m
//  LYEngine
//
//  Created by lly on 2017/5/8.
//  Copyright © 2017年 franklin. All rights reserved.
//

#import "MainModule.h"
#import "ViewController.h"
#import "ListUserCase.h"
#import "MineUserCase.h"

@implementation MainModule

- (void)onModuleInstlled{
    [super onModuleInstlled];
}

- (void)onModuleUninstalled{
    [super onModuleUninstalled];
}

- (void)initRouter{
    [super initRouter];
    [self.class registerURLPattern:MainVC toObjectHandler:^id(NSDictionary *routerParameters) {
        ViewController *v = [[ViewController alloc]init];
        return v;
    }];
}

- (void)unInitRouter{
    [super unInitRouter];
}

- (void)registerUserCase{
    [self registerUserCase:[ListUserCase class]];
    [self registerUserCase:[MineUserCase class]];
}

@end
