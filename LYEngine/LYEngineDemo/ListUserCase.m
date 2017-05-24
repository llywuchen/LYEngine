//
//  ListUserCase.m
//  LYEngine
//
//  Created by llywuchen on 2017/5/22.
//  Copyright © 2017年 franklin. All rights reserved.
//

#import "ListUserCase.h"

@interface ListUserCase ()

@property (nonatomic,strong) id<ListUserCaseAPI> requestManager;

@end

@implementation ListUserCase

- (id<ListUserCaseAPI>)requestManager{
    if(!_requestManager){
        _requestManager = LYWebRequest(ListUserCaseAPI);
    }
    return _requestManager;
}

- (NSURLSessionDataTask *)getListWithCount:(NSInteger)count suceessBlock:(void (^)(NSArray<Mine *> *, NSURLResponse *))callback failBlock:(void (^)(NSString *, NSURLResponse *, NSError *))errorMessage{
    
    return [self.requestManager getListWithCount:count suceessBlock:^(NSArray<Mine *> *result, NSURLResponse *response) {
        if(callback){
            callback(result,response);
        }
    } failBlock:^(NSString *errorMessage, NSURLResponse *response, NSError *error) {
        NSLog(@"getListWithCount requaet fail");
    }];
}

@end
