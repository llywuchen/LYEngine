//
//  ListVMProtocol.h
//  MVVM-test
//
//  Created by lly on 2017/5/2.
//  Copyright © 2017年 llywuchen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewModelProtocol.h"
#import "LYMutableArray.h"

@protocol LYVDataProtocol <NSObject>

VDPropretyCopy(NSString *, name);
VDPropretyCopy(NSString *, nick);

@end

@protocol ListVMProtocol <NSObject>

VDPropretyStrong(LYMutableArray<LYVDataProtocol> *, list);

VDMethod(void, refresh);

@end
