//
//  MainUserCaseProtocol.h
//  LYEngine
//
//  Created by llywuchen on 2017/5/23.
//  Copyright © 2017年 franklin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mine.h"
@class Mine;

@protocol MineUserCaseAPI <LYWebService>

@GET("/get")
- (NSURLSessionDataTask*)getMineInfoWithSuceessBlock:LY_SUCCESS_BLOCK(Mine*)callback failBlock:LY_FAIL_BLOCK(NSString*)errorMessage;

@end

@protocol MineUserCaseProtocol <NSObject>

@end


@protocol ListUserCaseAPI <LYWebService>

@GET("/post")
- (NSURLSessionDataTask*)getListWithCount:(NSInteger)count suceessBlock:LY_SUCCESS_BLOCK(NSArray<Mine *>*)callback failBlock:LY_FAIL_BLOCK(NSString*)errorMessage;

@end

@protocol ListUserCaseProtocol <NSObject>

@end
