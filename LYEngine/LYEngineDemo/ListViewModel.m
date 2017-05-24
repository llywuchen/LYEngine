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
    LYUserCase<ListUserCaseProtocol,ListUserCaseAPI> *listUserCase = (LYUserCase<ListUserCaseProtocol> *)[LYUserCase instanceWithProtoco:@protocol(ListUserCaseProtocol)];
    [listUserCase getListWithCount:10 suceessBlock:^(NSArray<Mine *> *result, NSURLResponse *response) {
        self.VM_list = [self transformAction:result];
    } failBlock:^(NSString *errorMessage, NSURLResponse *response, NSError *error) {
        
    }];
    
}

- (NSMutableArray<LYTViewData *> *)transformAction:(NSArray<Mine *> *)modelList{
    NSMutableArray *a = [NSMutableArray array];
    for(Mine *model in modelList){
        [a addObject:[self transform:model]];
    }
    return a;
}

- (LYTViewData *)transform:(Mine *)model{
    return [LYTViewData instanceWithName:model.name nick:model.site];
}

@end
