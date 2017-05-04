//
//  NSArray+Cache.m
//  LYEngine
//
//  Created by lly on 2017/5/4.
//  Copyright © 2017年 franklin. All rights reserved.
//

#import "NSArray+Cache.h"
#import <Realm/Realm.h>
#define DefaultRealm [RLMRealm defaultRealm]

@implementation NSArray (Cache)

- (void)saveToCache{
    [DefaultRealm beginWriteTransaction];
    for(RLMObject *object in self){
        [DefaultRealm addObject:object];
    }
    [DefaultRealm commitWriteTransaction];
}

- (void)deleteFromCache{
    [DefaultRealm beginWriteTransaction];
    for(RLMObject *object in self){
        [DefaultRealm deleteObject:object];
    }
    [DefaultRealm commitWriteTransaction];
}

@end
