//
//  LYWeakMutableArray.m
//  LYEngine
//
//  Created by lly on 16/7/21.
//  Copyright © 2016年 lly. All rights reserved.
//

#import "LYWeakMutableArray.h"
@interface LYWeakMutableArray ()

@property (nonatomic, strong) NSPointerArray  *pointerArray;

@end

@implementation LYWeakMutableArray

- (instancetype)init {
    
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.pointerArray = [NSPointerArray weakObjectsPointerArray];
}

+ (instancetype)arrayWithObject:(id)object{
    LYWeakMutableArray *array = [[LYWeakMutableArray alloc]init];
    [array addObject:object];
    return array;
}

- (void)addObject:(id)object {
    [self.pointerArray addPointer:(__bridge void *)(object)];
}

- (void)removeObjectAtIndex:(NSInteger)index {
    [self.pointerArray removePointerAtIndex:index];
}

- (id)objectAtWeakMutableArrayIndex:(NSUInteger)index {
    return [self.pointerArray pointerAtIndex:index];
}

#pragma mark - 重写getter方法
@synthesize allObjects = _allObjects;
- (NSArray *)allObjects {
    return self.pointerArray.allObjects;
}

@synthesize usableCount = _usableCount;
- (NSInteger)usableCount {
    return self.pointerArray.allObjects.count;
}

@synthesize allCount = _allCount;
- (NSInteger)allCount {
    return self.pointerArray.count;
}


@end
