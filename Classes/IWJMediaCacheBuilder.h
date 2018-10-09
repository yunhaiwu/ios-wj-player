//
//  IWJMediaCacheBuilder.h
//  WJPlayer
//
//  Created by ada on 2018/10/8.
//  Copyright © 2018年 PN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IWJMediaCache.h"


/**
 第三方缓存构建器
 使用方法：
    1、第三方缓存需要建一个类名为 WJMediaCacheBuilder类
    2、实现 IWJMediaCacheBuilder
 */
@protocol IWJMediaCacheBuilder <NSObject>

+(id<IWJMediaCache>)build;

@end

