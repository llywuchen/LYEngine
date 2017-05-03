//
//  LYViewData.h
//  MVVM-test
//
//  Created by lly on 2017/5/2.
//  Copyright © 2017年 llywuchen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ListVMProtocol.h"

@interface LYViewData : NSObject <LYVDataProtocol>

VDPropretyCopy(NSString *, name);
VDPropretyCopy(NSString *, nick);

+ (instancetype)instanceWithName:(NSString *)name nick:(NSString *)nick;
+ (NSMutableArray *)test:(NSInteger) count;

@end
