//
//  LYViewData.m
//  MVVM-test
//
//  Created by lly on 2017/5/2.
//  Copyright © 2017年 llywuchen. All rights reserved.
//

#import "LYViewData.h"

@implementation LYViewData

+ (instancetype)instanceWithName:(NSString *)name nick:(NSString *)nick{
    LYViewData *data = [[self alloc]init];
    data.VD_name = name;
    data.VD_nick = nick;
    return data;
}

+ (NSMutableArray *)test:(NSInteger) count{
    NSMutableArray *a = [NSMutableArray array];
    for(int i=0;i<count;i++){
        [a addObject:[self instanceWithName:[NSString stringWithFormat:@"name%d",i] nick:[NSString stringWithFormat:@"nick%d",i]]];
    }
    
    return a;
}

@end
