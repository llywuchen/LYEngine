//
//  LYMutableArray.m
//  MVVM-test
//
//  Created by lly on 2017/5/2.
//  Copyright © 2017年 llywuchen. All rights reserved.
//

#import "LYMutableArray.h"

@implementation LYMutableArray

- (void)addObject:(id)anObject{
    [super addObject:anObject];
    if(self.singleEditdBlock){
        self.singleEditdBlock(self.count, anObject, LYArrayEditAdd);
    }
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index{
    [super insertObject:anObject atIndex:index];
    if(self.singleEditdBlock){
        self.singleEditdBlock(index, anObject, LYArrayEditInsert);
    }
}

- (void)removeLastObject{
    id obj = self.lastObject;
    [super removeLastObject];
    if(self.singleEditdBlock){
        self.singleEditdBlock(self.count, obj, LYArrayEditRemove);
    }
}

- (void)removeObjectAtIndex:(NSUInteger)index{
    id obj = [self objectAtIndex:index];
    [super removeObjectAtIndex:index];
    if(self.singleEditdBlock){
        self.singleEditdBlock(index, obj, LYArrayEditRemove);
    }
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject{
    [super replaceObjectAtIndex:index withObject:anObject];
    if(self.singleEditdBlock){
        self.singleEditdBlock(index, anObject, LYArrayEditReplace);
    }
}


@end
