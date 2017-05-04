//
//  ListViewModel.m
//  MVVM-test
//
//  Created by lly on 2017/5/2.
//  Copyright © 2017年 llywuchen. All rights reserved.
//

#import "ListViewModel.h"
#import "LYViewData.h"

@implementation ListViewModel

LYSynthesizeProprety(NSMutableArray<LYTViewData *> *, VD_list, VM_list);
LYSynthesizeMethod(void, VD_refresh, refrsh);

- (void)refrsh{
    self.VM_list = [LYTViewData test:10];
}

@end
