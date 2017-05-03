//
//  LYUserCase.h
//  LYEngineDemo
//
//  Created by lly on 16/6/14.
//  Copyright © 2016年 lly. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "LYMessageEngine.h"

@protocol LYUseCaseDelegate <NSObject>

- (void)open;
- (void)close;

@end

@interface LYUseCase : NSObject//LYMessageHandle
- (void)onOpen;
- (void)onClose;
@end
