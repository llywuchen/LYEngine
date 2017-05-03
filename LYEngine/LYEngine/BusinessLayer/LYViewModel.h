//
//  LYViewModel.h
//  LYEngine
//
//  Created by lly on 16/5/31.
//  Copyright © 2016年 lly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class LYViewController;

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

#define GetViewModel(viewModelClass) ((viewModelClass *)[self getViewModel:[viewModelClass class]])

@class LYModel;
@class LYViewData;


@interface LYViewModel : NSObject

@property (nonatomic,weak) UIView *view;

@property (nonatomic,strong) NSDictionary *params;

/*
 life circle
 */
- (void)onViewWillMoveToSuperview:(UIView *)newSuperview;
- (void)onViewDidMoveToSuperview;
- (void)onViewWillAppear:(BOOL)animated;
- (void)onViewDidAppear:(BOOL)animated;
- (void)onViewRemoveFromSuperview;


- (UIViewController *)currentViewController;

- (void)transformAndRefresh:(__kindof LYModel *)model;
- (void)transformArrayAndRefresh:(NSArray <__kindof LYModel *> *)modelArray;


@end
