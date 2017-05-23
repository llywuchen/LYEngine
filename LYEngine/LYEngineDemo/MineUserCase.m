//
//  MineUserCase.m
//  LYEngine
//
//  Created by llywuchen on 2017/5/22.
//  Copyright © 2017年 franklin. All rights reserved.
//

#import "MineUserCase.h"

@interface MineUserCase ()

@property (nonatomic,strong) id<MineUserCaseAPI> requestManager;

@end

@implementation MineUserCase

- (id<MineUserCaseAPI>)requestManager{
    if(!_requestManager){
        _requestManager = LYWebRequest(MineUserCaseAPI);
    }
    return _requestManager;
}

- (NSURLSessionDataTask*)getMineInfoWithSuceessBlock:(void (^)(NSDictionary *, NSURLResponse *))callback failBlock:(void (^)(NSString *, NSURLResponse *, NSError *))errorMessage{
    
    return [self.requestManager getMineInfoWithSuceessBlock:^(NSDictionary *result, NSURLResponse *response) {
        if(callback){
            callback(@{@"pwd":@"pwd",@"name":@"name"},response);
        }
    } failBlock:^(NSString *errorMessage, NSURLResponse *response, NSError *error) {
        if(callback){
            callback(@{@"pwd":@"pwd",@"name":@"name"},response);
        }
    }];
    
}

@end
