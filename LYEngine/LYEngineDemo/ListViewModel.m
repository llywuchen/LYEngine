//
//  ListViewModel.m
//  MVVM-test
//
//  Created by lly on 2017/5/2.
//  Copyright © 2017年 llywuchen. All rights reserved.
//

#import "ListViewModel.h"
#import "LYViewData.h"
#import "MainUserCaseProtocol.h"

@implementation ListViewModel

LYSynthesizeProprety(NSMutableArray<LYTViewData *> *, VD_list, VM_list);
LYSynthesizeMethod(void, VD_refresh, refrsh);

- (void)onViewDidAppear:(BOOL)animated{
    [super onViewDidAppear:animated];
    NSLog(@"onViewDidAppear");
    
    [self refrsh];
}

- (void)refrsh{
    LYUserCase<ListUserCaseProtocol> *listUserCase = (LYUserCase<ListUserCaseProtocol> *)[LYUserCase instanceWithProtoco:@protocol(ListUserCaseProtocol)];
    NSArray *list =[listUserCase getList];
    
    self.VM_list = [self transformAction:list];
}

- (NSMutableArray<LYTViewData *> *)transformAction:(NSArray *)modelList{
    return [LYTViewData test:10];
}

@end
