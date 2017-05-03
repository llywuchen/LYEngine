//
//  ListViewModel.h
//  MVVM-test
//
//  Created by lly on 2017/5/2.
//  Copyright © 2017年 llywuchen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ListVMProtocol.h"

@interface ListViewModel : LYViewModel <ListVMProtocol>

VMPropretyStrong(LYMutableArray<LYVDataProtocol> *, list);

@end
