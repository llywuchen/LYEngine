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
