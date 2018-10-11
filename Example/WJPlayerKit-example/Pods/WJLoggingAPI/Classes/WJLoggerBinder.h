//
//  WJLoggerBinder.h
//
//   __      __   _____
//  /\ \  __/\ \ /\___ \
//  \ \ \/\ \ \ \\/__/\ \
//   \ \ \ \ \ \ \  _\ \ \
//    \ \ \_/ \_\ \/\ \_\ \
//     \ `\___x___/\ \____/
//      '\/__//__/  \/___/
//
//  Created by yunhai.wu on 15-12-13.
//  Copyright (c) 2015年 WJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IWJLoggerFactory.h"

@interface WJLoggerBinder : NSObject


/**
 日志工厂
 */
+(id<IWJLoggerFactory>)getLoggerFactory;

@end
