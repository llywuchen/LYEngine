//
//  LYWeakMutableArray.h
//  LYEngine
//
//  Created by lly on 16/7/21.
//  Copyright © 2016年 lly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYWeakMutableArray : NSObject

/**
 *  获取所有有效的对象
 */
@property (nonatomic, strong, readonly)  NSArray    *allObjects;

/**
 *  数组中有用对象的个数
 */
@property (nonatomic, readonly)          NSInteger   usableCount;

/**
 *  数组中所有对象的个数(包括NULL)
 */
@property (nonatomic, readonly)          NSInteger   allCount;

+ (instancetype)arrayWithObject:(id)object;

/**
 *  添加对象
 *
 *  @param object 被添加对象
 */
- (void)addObject:(id)object;

/**
 *  删除索引对象
 *
 *  @param index 索引
 */
- (void)removeObjectAtIndex:(NSInteger)index;
/**
 *  获取数组中的对象(可以获取到NULL对象)
 *
 *  @param index 数组下标
 *
 *  @return 对象
 */
- (id)objectAtWeakMutableArrayIndex:(NSUInteger)index;

@end
