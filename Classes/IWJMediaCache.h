//
//  IWJMediaCache.h
//  WJPlayer
//
//  Created by ada on 2018/9/29.
//  Copyright © 2018年 PN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


/**
 媒体缓存对象
 */
@protocol IWJMediaCache <NSObject>

/**
 构建一个AVPlayerItem
 */
-(AVPlayerItem*)getPlayerItem:(NSURL*)url;

/**
 取消加载
 */
-(void)cancelLoading:(NSURL*)url;

/**
 已缓存数据大小
 */
-(unsigned long long)cachedSize;

/**
 清空所有缓存
 */
- (void)cleanAllCache;

/**
 清空指定缓存
 */
- (void)cleanCacheWithURL:(NSURL*)url;

@end
