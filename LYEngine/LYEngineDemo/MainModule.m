//
//  MainModule.m
//  LYEngine
//
//  Created by lly on 2017/5/8.
//  Copyright © 2017年 franklin. All rights reserved.
//

#import "MainModule.h"
#import "ViewController.h"

@implementation MainModule

- (void)onModuleInstlled{
    [super onModuleInstlled];
}

- (void)onModuleUninstalled{
    [super onModuleUninstalled];
}

- (void)initRouter{
    [super initRouter];
    [MGJRouter registerURLPattern:MainVC toObjectHandler:^id(NSDictionary *routerParameters) {
        ViewController *v = [[ViewController alloc]init];
        return v;
    }];
}

- (void)unInitRouter{
    [super unInitRouter];
}

@end
