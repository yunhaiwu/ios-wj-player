//
//  ILogger.h
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

/**
 * 日志记录器接口
 * error > warn > info > debug > verbose
 */
@protocol IWJLogger <NSObject>

/**
 *  error 级别日志
 */
-(void) error:(NSString*) func format:(NSString*) format, ...;

/**
 *  warn 级别日志
 */
-(void) warn:(NSString*) func format:(NSString*) format, ...;

/**
 *  info 级别日志
 */
-(void) info:(NSString*) func format:(NSString*) format, ...;

/**
 *  debug 级别日志
 */
-(void) debug:(NSString*) func format:(NSString*) format, ...;

/**
 *  verbose 级别日志
 */
-(void) verbose:(NSString*) func format:(NSString*) format, ...;

@end
