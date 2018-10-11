//
//  WJLoggerBinder.m
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

#import "WJLoggerBinder.h"

@implementation WJLoggerBinder

static id<IWJLoggerFactory> loggerFactory = nil;

+(id<IWJLoggerFactory>)getLoggerFactory {
    static dispatch_once_t loggerOnceToken;
    dispatch_once(&loggerOnceToken, ^{
        Class clazz = NSClassFromString(@"WJLoggerFactory");
        if (clazz && [clazz conformsToProtocol:@protocol(IWJLoggerFactory)]) {
            loggerFactory = [[clazz alloc] init];
        } else {
            NSLog(@"无法构建日志工厂！，请查看文档：https://github.com/yunhaiwu/ios-wj-logging-api.git");
        }
    });
    return loggerFactory;
}

@end
