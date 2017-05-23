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

- (NSURLSessionDataTask *)getListWithSuceessBlock:(void (^)(NSArray *, NSURLResponse *))callback failBlock:(void (^)(NSString *, NSURLResponse *, NSError *))errorMessage{
    
    return [self.requestManager getListWithSuceessBlock:^(NSArray *result, NSURLResponse *response) {
        if(callback){
            int i;
            NSMutableArray *a = [NSMutableArray array];
            while (i <10) {
                [a addObject:@{@"name":@"namei",@"nike":@"nicki"}];
            }
            callback(a,response);
        }
    } failBlock:^(NSString *errorMessage, NSURLResponse *response, NSError *error) {
        callback(nil,response);
    }];
}

@end
