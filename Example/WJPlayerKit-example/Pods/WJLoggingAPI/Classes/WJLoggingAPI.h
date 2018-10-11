//
//  WJLoggingAPI.h
//
//   __      __   _____
//  /\ \  __/\ \ /\___ \
//  \ \ \/\ \ \ \\/__/\ \
//   \ \ \ \ \ \ \  _\ \ \
//    \ \ \_/ \_\ \/\ \_\ \
//     \ `\___x___/\ \____/
//      '\/__//__/  \/___/
//
//  Created by yunhai.wu on 15-12-26.
//  Copyright (c) 2015年 WJ. All rights reserved.
//


/**
 * 日志入口 API
 * error > warn > info > debug > verbose
 */

#import "IWJLogger.h"
#import "WJLoggerBinder.h"

#define WJLogError(frmt, ...) \
        [[[WJLoggerBinder getLoggerFactory] build] error:[NSString stringWithFormat:@"%s line:%d",__func__,__LINE__] format:frmt, ##__VA_ARGS__]

#define WJLogWarn(frmt, ...) \
        [[[WJLoggerBinder getLoggerFactory] build] warn:[NSString stringWithFormat:@"%s line:%d",__func__,__LINE__] format:frmt, ##__VA_ARGS__]

#define WJLogInfo(frmt, ...) \
        [[[WJLoggerBinder getLoggerFactory] build] info:[NSString stringWithFormat:@"%s line:%d",__func__,__LINE__] format:frmt, ##__VA_ARGS__]

#define WJLogDebug(frmt, ...) \
        [[[WJLoggerBinder getLoggerFactory] build] debug:[NSString stringWithFormat:@"%s line:%d",__func__,__LINE__] format:frmt, ##__VA_ARGS__]

#define WJLogVerbose(frmt, ...) \
        [[[WJLoggerBinder getLoggerFactory] build] verbose:[NSString stringWithFormat:@"%s line:%d",__func__,__LINE__] format:frmt, ##__VA_ARGS__]
