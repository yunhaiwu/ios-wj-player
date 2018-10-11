//
//  IWJLoggerFactory.h
//  WJLoggingAPI-example
//
//  Created by ada on 2018/8/24.
//  Copyright © 2018年 WJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IWJLogger.h"

/**
 日志工厂
 */
@protocol IWJLoggerFactory <NSObject>

/**
 构建日志对象
 */
- (id<IWJLogger>)build;


@end
