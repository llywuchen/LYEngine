//
//  LYViewModel.m
//  LYEngine
//
//  Created by lly on 16/5/31.
//  Copyright © 2016年 lly. All rights reserved.
//

#import "LYViewModel.h"
#import "LYModel.h"
#import "LYDefines.h"
#import "UIView+UIViewController.h"
#import "LYAssertionHandler.h"


@interface LYViewModel ()

@end

@implementation LYViewModel

#pragma mark ---
- (void)onViewWillMoveToSuperview:(UIView *)newSuperview{
    
}


- (void)onViewDidMoveToSuperview{
    
    
}

- (void)onViewWillAppear:(BOOL)animated{
    
}

- (void)onViewDidAppear:(BOOL)animated{
    
}

- (void)onViewRemoveFromSuperview{
    
}

- (void)dealloc{
    LYLogDebugInfo;
}


#pragma mark data
- (void)onLoadData{
    
}

- (void)onReloadData{
    
}

- (UIViewController *)currentViewController{
    return self.view.viewController;
}

#pragma mark ---get othre vm
//- (__kindof LYViewModel *)getViewModel:(Class) viewModelClass{
//    return [self.viewController getViewModel:viewModelClass];
//}

#pragma mark ----


#pragma mark -----

- (void)transformAndRefresh:(__kindof LYModel *)model{
    
}

- (void)transformArrayAndRefresh:(NSArray <__kindof LYModel *> *)modelArray{
    
    
}


#pragma mark --- kvo
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (id)valueForUndefinedKey:(NSString *)key{
#if DEBUG
    if([key hasPrefix:@"VD_"]||[key hasPrefix:@"VM_"])
        return [NSString stringWithFormat:@"%@",key];
    else
        return [super valueForUndefinedKey:key];
#else
    return [super valueForUndefinedKey:key];
#endif
    
}

- (void)doesNotRecognizeSelector:(SEL)aSelector{
#if DEBUG
    NSString *sel = NSStringFromSelector(aSelector);
    if([sel hasPrefix:@"VD_"]){
        NSLog(@"#warnning:VD Interface method:%@ not connect VM!!!",sel);
    }else{
        [super doesNotRecognizeSelector:aSelector];
    }
#else
    [super doesNotRecognizeSelector:aSelector];
#endif
}



@end
