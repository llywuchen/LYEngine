//
//  MainUserCaseProtocol.h
//  LYEngine
//
//  Created by llywuchen on 2017/5/23.
//  Copyright © 2017年 franklin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MineUserCaseAPI <LYWebService>

@POST("/login")
- (NSURLSessionDataTask*)getMineInfoWithSuceessBlock:LY_SUCCESS_BLOCK(NSDictionary*)callback failBlock:LY_FAIL_BLOCK(NSString*)errorMessage;

@end

@protocol MineUserCaseProtocol <NSObject>

@end


@protocol ListUserCaseAPI <LYWebService>

@POST("/login2")
- (NSURLSessionDataTask*)getListWithSuceessBlock:LY_SUCCESS_BLOCK(NSArray*)callback failBlock:LY_FAIL_BLOCK(NSString*)errorMessage;

@end

@protocol ListUserCaseProtocol <NSObject>

@end
