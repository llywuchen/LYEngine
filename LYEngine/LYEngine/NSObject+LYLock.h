//
//  NSObject+LYLock.h
//  LYEngine
//
//  Created by lly on 16/8/26.
//  Copyright © 2016年 lly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <pthread.h>

#define LY_SYNCHRONIZED_DEFINE(lock) pthread_mutex_t _LY_SYNCHRONIZED_##lock
#define LY_SYNCHRONIZED_INIT(lock) pthread_mutex_init(&_LY_SYNCHRONIZED_##lock, NULL)
#define LY_SYNCHRONIZED_BEGIN(lock) pthread_mutex_lock(&_LY_SYNCHRONIZED_##lock);
#define LY_SYNCHRONIZED_END(lock) pthread_mutex_unlock(&_LY_SYNCHRONIZED_##lock);

@interface NSObject (LYLock)
- (void)ly_lockObject;
- (void)ly_unlockObject;
@end
