//
//  NSObject+LYLock.m
//  LYEngine
//
//  Created by lly on 16/8/26.
//  Copyright © 2016年 lly. All rights reserved.
//

#import "NSObject+LYLock.h"
#import <objc/runtime.h>

static const char *lockPropertyKey = "LYObjectLock::lock";

@interface LYObjectLockImpl : NSObject
{
    LY_SYNCHRONIZED_DEFINE(objectLock);
}

- (void)lyTakeLock;
- (void)lyFreeLock;

@end

@implementation LYObjectLockImpl

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        LY_SYNCHRONIZED_INIT(objectLock);
    }
    return self;
}

- (void)lyTakeLock
{
    LY_SYNCHRONIZED_BEGIN(objectLock);
}

- (void)lyFreeLock
{
    LY_SYNCHRONIZED_END(objectLock);
}

@end

@implementation NSObject (LYLock)

- (void)ly_lockObject
{
    LYObjectLockImpl *lock = (LYObjectLockImpl *)objc_getAssociatedObject(self, lockPropertyKey);
    if (lock == nil)
    {
        @synchronized(self)
        {
            lock = [[LYObjectLockImpl alloc] init];
            objc_setAssociatedObject(self, lockPropertyKey, lock, OBJC_ASSOCIATION_RETAIN);
        }
    }
    
    [lock lyTakeLock];
}

- (void)ly_unlockObject
{
    LYObjectLockImpl *lock = (LYObjectLockImpl *)objc_getAssociatedObject(self, lockPropertyKey);
    if (lock == nil)
    {
        @synchronized(self)
        {
            lock = [[LYObjectLockImpl alloc] init];
            objc_setAssociatedObject(self, lockPropertyKey, lock, OBJC_ASSOCIATION_RETAIN);
        }
    }
    
    [lock lyFreeLock];
}

@end
