//
//  LYMutableArray.h
//  MVVM-test
//
//  Created by lly on 2017/5/2.
//  Copyright © 2017年 llywuchen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,LYArrayEditStatus){
    LYArrayEditAdd = 0,
    LYArrayEditRemove = 1,
    LYArrayEditInsert = 2,
    LYArrayEditReplace = 3
};

typedef void (^LYArraySingleEditdBlock)(NSInteger changedIndex,id changedObj,LYArrayEditStatus edit);
typedef void (^LYArrayMultiEditdBlock)(NSSet *changedIndexSet,NSArray *changedSubArray,LYArrayEditStatus edit);

@interface LYMutableArray<ObjectType> : NSMutableArray<ObjectType>

@property (nonatomic,copy) LYArraySingleEditdBlock singleEditdBlock;
@property (nonatomic,copy) LYArrayMultiEditdBlock multiEditdBlock;

@end
