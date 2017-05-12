//
//  ViewModel.m
//  MVVM-test
//
//  Created by llywuchen on 2017/5/1.
//  Copyright © 2017年 llywuchen. All rights reserved.
//

#import "ViewModel.h"

@implementation ViewModel

LYSynthesizeProprety(NSString *,VD_userName,VM_name);
LYSynthesizeProprety(NSString *,VD_userPwd,VM_pwd);
LYSynthesizeMethod(void, VD_refresh, refresh1);

- (instancetype)init{
    self = [super init];
    if(self){
        self.VM_name = @"eqwewq";
        self.VM_pwd = @"inlin";
    }
    return self;
}

- (void)refresh1{
    self.VM_pwd = @"changgePwd";
    self.VM_name = @"changeName";
}


- (void)onViewDidAppear:(BOOL)animated{
    [super onViewDidAppear:animated];
    NSLog(@"onViewDidAppear");
}
@end
