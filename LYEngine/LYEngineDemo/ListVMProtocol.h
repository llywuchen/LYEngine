//
//  ListVMProtocol.h
//  MVVM-test
//
//  Created by lly on 2017/5/2.
//  Copyright © 2017年 llywuchen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYMutableArray.h"
#import "LYTViewData.h"

@protocol ListVMProtocol <LYViewDataProtocol>

VDPropretyStrong(NSMutableArray<LYTViewData *> *, list);

VDMethod(void, refresh);

@end
