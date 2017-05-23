//
//  MainUserCaseProtocol.h
//  LYEngine
//
//  Created by llywuchen on 2017/5/23.
//  Copyright © 2017年 franklin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MineUserCaseProtocol <NSObject>

- (NSDictionary *)getMineInfo;

@end

@protocol ListUserCaseProtocol <NSObject>

- (NSArray *)getList;

@end
