//
//  ViewModel.m
//  MVVM-test
//
//  Created by llywuchen on 2017/5/1.
//  Copyright © 2017年 llywuchen. All rights reserved.
//

#import "ViewModel.h"
#import "MainUserCaseProtocol.h"

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
    LYUserCase<MineUserCaseProtocol,MineUserCaseAPI> *mineUserCase = (LYUserCase<MineUserCaseProtocol> *)[LYUserCase instanceWithProtoco:@protocol(MineUserCaseProtocol)];
    [mineUserCase getMineInfoWithSuceessBlock:^(Mine *result, NSURLResponse *response) {
        [self transformAction:result];
    } failBlock:^(NSString *errorMessage, NSURLResponse *response, NSError *error) {
        
    }];
}

- (void)transformAction:(Mine *)model{
    self.VM_pwd = model.nick;
    self.VM_name = model.name;
}
@end
