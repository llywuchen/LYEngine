//
//  LYViewModel.m
//  LYEngine
//
//  Created by lly on 16/5/31.
//  Copyright © 2016年 lly. All rights reserved.
//

#import "LYViewModel.h"
#import "LYViewData.h"
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

- (void)forwardInvocation:(NSInvocation *)anInvocation{
#if DEBUG
    NSString *sel = NSStringFromSelector(anInvocation.selector);
    if([sel hasPrefix:@"VD_"]){
        NSLog(@"#warnning:VD Interface method:%@ not connect VM!!!",sel);
        if(![sel containsString:@":"]){
            NSMethodSignature *signature = [anInvocation methodSignatureForSelector:anInvocation.selector];
            const char *returnType = signature.methodReturnType;
            if( !strcmp(returnType, @encode(NSArray))){
                [anInvocation setReturnValue:(__bridge void * _Nonnull)([LYViewData test:20])];
            }else if (!strcmp(returnType, @encode(NSInteger))){
                NSInteger i = 0;
                [anInvocation setReturnValue:&i];
            }else if (!strcmp(returnType, @encode(NSString))){
                [anInvocation setReturnValue:@"undefined"];
            }
        }
    }else{
        [super forwardInvocation:anInvocation];
    }
#else
    [super forwardInvocation:anInvocation];
#endif
}

//- (void)doesNotRecognizeSelector:(SEL)aSelector{
//#if DEBUG
//    NSString *sel = NSStringFromSelector(aSelector);
//    if([sel hasPrefix:@"VD_"]){
//        NSLog(@"#warnning:VD Interface method:%@ not connect VM!!!",sel);
//        if(![sel containsString:@":"]){
//            NSMethodSignature *signature = [self.class instanceMethodSignatureForSelector:aSelector];
//            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
//            [invocation setSelector:aSelector];
//            const char *returnType = signature.methodReturnType;
//            if( !strcmp(returnType, @encode(NSArray))){
//                [invocation setReturnValue:(__bridge void * _Nonnull)([LYViewData test:20])];
//            }else if (!strcmp(returnType, @encode(NSInteger))){
//                NSInteger i = 0;
//                [invocation setReturnValue:&i];
//            }else if (!strcmp(returnType, @encode(NSString))){
//                [invocation setReturnValue:@"undefined"];
//            }
//            [invocation invoke];
//        }
//    }else{
//        [super doesNotRecognizeSelector:aSelector];
//    }
//#else
//    [super doesNotRecognizeSelector:aSelector];
//#endif
//}



@end
