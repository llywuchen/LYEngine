//
//  LYURLProtocolResponse.h
//  LYEngine
//
//  Created by lly on 2017/5/5.
//  Copyright © 2017年 franklin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYURLProtocolResponse : NSObject

@property (copy, nonatomic) NSString *errorMessage;
@property (strong, nonatomic) NSDictionary *data;
@property (assign, nonatomic) int code;

- (NSString *)jsonString;

@end
