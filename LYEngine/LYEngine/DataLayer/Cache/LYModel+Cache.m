//
//  LYModel+Cache.m
//  LYEngine
//
//  Created by lly on 2017/5/4.
//  Copyright © 2017年 franklin. All rights reserved.
//

#import "LYModel+Cache.h"
#import <Realm/Realm.h>
#define DefaultRealm [RLMRealm defaultRealm]

@implementation LYModel (Cache)

+ (NSString *)primaryKey{
    return nil;
}

- (void)insertIfNotExcist{
    [DefaultRealm beginWriteTransaction];
    [DefaultRealm addObject:self];
    [DefaultRealm commitWriteTransaction];
}

- (void)insertOrReplace{
    [DefaultRealm beginWriteTransaction];
    [DefaultRealm addOrUpdateObject:self];
    [DefaultRealm commitWriteTransaction];
}

- (void)deleteFromCache{
    [DefaultRealm beginWriteTransaction];
    [DefaultRealm deleteObject:self];
    [DefaultRealm commitWriteTransaction];
}

+ (void)deleteWithPrimaryKey:(id)primaryKey{
    if([self primaryKey].length==0) return;
    RLMObject *object = [self objectForPrimaryKey:primaryKey];
    [DefaultRealm beginWriteTransaction];
    [DefaultRealm deleteObject:object];
    [DefaultRealm commitWriteTransaction];
}

+ (void)deleteWithConditions:(NSString *)conditions{
    RLMResults *results = [self objectsWhere:conditions];
    [DefaultRealm beginWriteTransaction];
    for(int i = 0;i<results.count;i++){
        RLMObject *object = [results objectAtIndex:i];
        [DefaultRealm deleteObject:object];
    }
    [DefaultRealm commitWriteTransaction];
}

+ (NSArray<__kindof LYModel *> *)getListFromCache{
    RLMResults *results = [self allObjects];
    NSMutableArray *array = [NSMutableArray array];
    for(int i = 0;i<results.count;i++){
        RLMObject *object = [results objectAtIndex:i];
        [array addObject:object];
    }
    return array;
}

+ (NSArray<__kindof LYModel *> *)getListFromCacheWithConditions:(NSString *)conditions{
    RLMResults *results = [self objectsWhere:conditions];//[DefaultRealm objects:NSStringFromClass([self class]) where:conditions];
    NSMutableArray *array = [NSMutableArray array];
    for(int i = 0;i<results.count;i++){
        RLMObject *object = [results objectAtIndex:i];
        [array addObject:object];
    }
    return array;
}


+ (void)updateWithPrimaryKey:(id)primaryKey conditions:(NSDictionary *)conditions{
    if([self primaryKey].length==0||conditions.allKeys.count) return;
    RLMObject *object = [self objectForPrimaryKey:primaryKey];
    [object setValuesForKeysWithDictionary:conditions];
    [DefaultRealm beginWriteTransaction];
    [DefaultRealm addOrUpdateObject:object];
    [DefaultRealm commitWriteTransaction];
}


+ (void)initCacheWithUserId:(NSString *)userId{
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    
     //使用默认的目录，但是使用用户名来替换默认的文件名
    config.inMemoryIdentifier = userId;
    
     //将这个配置应用到默认的 Realm 数据库当中
    [RLMRealmConfiguration setDefaultConfiguration:config];
}

@end
