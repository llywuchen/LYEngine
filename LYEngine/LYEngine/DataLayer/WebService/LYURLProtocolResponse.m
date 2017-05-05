//
//  LYURLProtocolResponse.m
//  LYEngine
//
//  Created by lly on 2017/5/5.
//  Copyright © 2017年 franklin. All rights reserved.
//

#import "LYURLProtocolResponse.h"
#import "NSDictionary+JsonString.h"

@implementation LYURLProtocolResponse

- (NSString *)jsonString
{
    NSMutableDictionary *temp = [NSMutableDictionary dictionary];
    
    if(!self.errorMessage)
    {
        self.errorMessage = @"";
    }
    
    if(self.data)
        [temp setObject:self.data forKey:@"data"];
    
    
    [temp setObject:@(self.code) forKey:@"code"];
    [temp setObject:self.errorMessage forKey:@"message"];
    
    return [temp jsonString];
}

@end
