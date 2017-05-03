//
//  ViewModel.h
//  MVVM-test
//
//  Created by llywuchen on 2017/5/1.
//  Copyright © 2017年 llywuchen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewModelProtocol.h"

@interface ViewModel : LYViewModel <ViewModel>


VMPropretyStrong(NSString *,name);
VMPropretyStrong(NSString *,pwd);



@end
