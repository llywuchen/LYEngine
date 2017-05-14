//
//  ViewMode.h
//  MVVM-test
//
//  Created by llywuchen on 2017/5/1.
//  Copyright © 2017年 llywuchen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYDefines.h"

@protocol ViewModel <NSObject>

VDPropretyCopy(NSString *,userName);
VDPropretyCopy(NSString *,userPwd);

VDMethod(void, refresh);

@end
