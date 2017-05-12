//
//  UIViewController+LYViewModel.m
//  MXEngine
//
//  Created by lly on 16/8/25.
//  Copyright © 2016年 lly. All rights reserved.
//

#import "UIViewController+LYViewModel.h"
#import <objc/runtime.h>
#import "NSObject+Extension.h"
static char *StaticViewModelKey = "UIViewController_StaticViewModelKey";

@implementation UIViewController (LYViewModel)
+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [self swizzMethodWithOrgSel:@selector(viewDidLoad) newSel:@selector(mx_viewDidLoad)];
        [self swizzMethodWithOrgSel:@selector(viewWillAppear:) newSel:@selector(mx_viewWillAppear:)];
        [self swizzMethodWithOrgSel:@selector(viewDidAppear:) newSel:@selector(mx_viewDidAppear:)];
    });
}

- (__kindof LYViewModel *)viewModel{
    return objc_getAssociatedObject(self, StaticViewModelKey);
}

- (void)setViewModel:(__kindof LYViewModel *)viewModel{
    objc_setAssociatedObject(self, StaticViewModelKey, viewModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (void)mx_viewDidLoad{
    if(self.viewModel){
        [self.viewModel onViewWillMoveToSuperview:self.view.superview];
    }
    
    [self mx_viewDidLoad];
    
    if(self.viewModel){
        [self.viewModel onViewDidMoveToSuperview];
    }
}

- (void)mx_viewWillAppear:(BOOL)animated{
    [self mx_viewWillAppear:animated];
    if(self.viewModel){
        [self.viewModel onViewWillAppear:animated];
    }
    
}

- (void)mx_viewDidAppear:(BOOL)animated{
    [self mx_viewDidAppear:animated];
    if(self.viewModel){
        [self.viewModel onViewDidAppear:animated];
    }
}

#pragma mark -
- (void)registerViewModelClass:(Class)vmClass{
    [self registerViewModelClass:vmClass params:nil];
}

- (void)registerViewModelClass:(Class)vmClass params:(NSDictionary *)params{
    [self setViewModel:[[vmClass alloc] init]];
    self.viewModel.params = params;
}

@end
