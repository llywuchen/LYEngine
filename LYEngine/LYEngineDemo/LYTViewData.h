//
//  LYViewData.h
//  MVVM-test
//
//  Created by lly on 2017/5/2.
//  Copyright © 2017年 llywuchen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYTViewData : LYViewData

VDPropretyCopy(NSString *, name);
VDPropretyCopy(NSString *, nick);

+ (instancetype)instanceWithName:(NSString *)name nick:(NSString *)nick;
+ (NSMutableArray<LYTViewData *> *)test:(NSInteger) count;

@end
