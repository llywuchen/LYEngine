//
//  UIView+LYViewModel.m
//  MXEngine
//
//  Created by lly on 16/8/19.
//  Copyright © 2016年 lly. All rights reserved.
//

#import "UIView+LYViewModel.h"
#import <objc/runtime.h>
#import "NSObject+Extension.h"


@implementation UIView (LYViewModel)
static char *StaticViewModelKey = "UIView_StaticViewModelKey";

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [self swizzMethodWithOrgSel:@selector(willMoveToSuperview:) newSel:@selector(mx_willMoveToSuperview:)];
        [self swizzMethodWithOrgSel:@selector(willMoveToWindow:) newSel:@selector(mx_willMoveToWindow:)];
        [self swizzMethodWithOrgSel:@selector(didMoveToSuperview) newSel:@selector(mx_didMoveToSuperview)];
        [self swizzMethodWithOrgSel:@selector(didMoveToWindow) newSel:@selector(mx_didMoveToWindow)];
        [self swizzMethodWithOrgSel:@selector(removeFromSuperview) newSel:@selector(mx_removeFromSuperview)];
    });
    
}

- (__kindof LYViewModel *)viewModel{
    return objc_getAssociatedObject(self, StaticViewModelKey);
}

- (void)setViewModel:(__kindof LYViewModel *)viewModel{
    objc_setAssociatedObject(self, StaticViewModelKey, viewModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)mx_willMoveToSuperview:(UIView *)newSuperview{
    [self mx_willMoveToSuperview:newSuperview];
    if(self.viewModel&&[self.viewModel respondsToSelector:@selector(onViewWillMoveToSuperview:)]&&newSuperview){
        [self.viewModel onViewWillMoveToSuperview:newSuperview];
    }
}

- (void)mx_willMoveToWindow:(UIWindow *)newWindow{
    [self mx_willMoveToWindow:newWindow];
    if(self.viewModel&&[self.viewModel respondsToSelector:@selector(onViewWillAppear:)]&&newWindow){
        [self.viewModel onViewWillAppear:false];
    }
}

- (void)mx_didMoveToSuperview{
    [self mx_didMoveToSuperview];
    if(self.viewModel&&[self.viewModel respondsToSelector:@selector(onViewDidMoveToSuperview)]&&self.superview){
        [self.viewModel onViewDidMoveToSuperview];
    }
}

- (void)mx_didMoveToWindow{
    [self mx_didMoveToWindow];
    if(self.viewModel&&[self.viewModel respondsToSelector:@selector(onViewDidAppear:)]&&self.window){
        [self.viewModel onViewDidAppear:false];
    }
}

- (void)mx_removeFromSuperview{
    [self mx_removeFromSuperview];
    if(self.viewModel&&[self.viewModel respondsToSelector:@selector(onViewRemoveFromSuperview:)]){
        [self.viewModel onViewRemoveFromSuperview];
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
