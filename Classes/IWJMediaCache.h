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


@end
