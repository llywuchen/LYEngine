//
//  LYModel+Cache.h
//  LYEngine
//
//  Created by lly on 2017/5/4.
//  Copyright © 2017年 franklin. All rights reserved.
//

#import "LYModel.h"

@interface LYModel (Cache)

/**
 *  存储主键名
 *
 *  @return 不重写默认没有,则不能通过主键局部更新
 */
+ (NSString *)primaryKey;

- (void)insertIfNotExcist;
- (void)insertOrReplace;

- (void)deleteFromCache;

+ (void)deleteWithPrimaryKey:(id)primaryKey;
+ (void)deleteWithConditions:(NSString *)conditions;

+ (NSArray<__kindof LYModel *> *)getListFromCache;
+ (NSArray<__kindof LYModel *> *)getListFromCacheWithConditions:(NSString *)conditions;

+ (void)updateWithPrimaryKey:(id)primaryKey conditions:(NSDictionary *)conditions;


+ (void)initCacheWithUserId:(NSString *)userId;

@end
