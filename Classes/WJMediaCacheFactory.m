//
//  PNCacheFactory.m
//  WJPlayer
//
//  Created by ada on 2018/9/29.
//  Copyright © 2018年 PN. All rights reserved.
//

#import "WJMediaCacheFactory.h"
#import "IWJMediaCacheBuilder.h"
#import "SimpleMediaCache.h"

@implementation WJMediaCacheFactory

static id<IWJMediaCache> currentMediaCacheObject = nil;

+(id<IWJMediaCache>)getMediaCache {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //加载第三方缓存构建器
        Class builderClazz = NSClassFromString(@"WJMediaCacheBuilder");
        if (builderClazz != NULL && [builderClazz conformsToProtocol:@protocol(IWJMediaCacheBuilder)]) {
            currentMediaCacheObject = [builderClazz build];
        } else {
            currentMediaCacheObject = [[SimpleMediaCache alloc] init];
        }
    });
    return currentMediaCacheObject;
}

@end
