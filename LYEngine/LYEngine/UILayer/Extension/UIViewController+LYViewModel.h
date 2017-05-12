//
//  UIViewController+LYViewModel.h
//  MXEngine
//
//  Created by lly on 16/8/25.
//  Copyright © 2016年 lly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYViewModel.h"

@interface UIViewController (LYViewModel)

@property (nonatomic,strong,readonly) __kindof LYViewModel* viewModel;

- (void)registerViewModelClass:(Class)vmClass;

- (void)registerViewModelClass:(Class)vmClass params:(NSDictionary *)params;

@end
