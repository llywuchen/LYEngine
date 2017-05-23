//
//  ListUserCase.m
//  LYEngine
//
//  Created by llywuchen on 2017/5/22.
//  Copyright © 2017年 franklin. All rights reserved.
//

#import "ListUserCase.h"

@implementation ListUserCase

- (NSArray *)getList{
    int i;
    NSMutableArray *a = [NSMutableArray array];
    while (i <10) {
        [a addObject:@{@"name":@"namei",@"nike":@"nicki"}];
    }
    return a;
}

@end
