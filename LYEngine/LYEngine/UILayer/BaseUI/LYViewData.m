//
//  LYViewData.m
//  LYEngine
//
//  Created by lly on 2017/5/4.
//  Copyright © 2017年 franklin. All rights reserved.
//

#import "LYViewData.h"

@implementation LYViewData

+ (NSArray *)test:(NSInteger) count{
    NSMutableArray *a = [NSMutableArray array];
    for(int i=0;i<count;i++){
        [a addObject:[self new]];
    }
    return a;
}

#pragma mark --- kvo
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (id)valueForUndefinedKey:(NSString *)key{
#if DEBUG
    if([key hasPrefix:@"VD_"]||[key hasPrefix:@"VM_"])
        return [NSString stringWithFormat:@"%@",key];
    else
        return [super valueForUndefinedKey:key];
#else
    return [super valueForUndefinedKey:key];
#endif
    
}

@end
