//
//  IWJPlayer.h
//  WJPlayer
//
//  Created by Yunhai.Wu on 2018/9/8.
//  Copyright © 2018年 PN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IWJMedia.h"

/**
 播放器状态
 */
typedef NS_ENUM(NSInteger, WJPlayerStatus) {
    
    //未知状态
    WJPlayerStatusUnknown = 0,
    
    //加载中
    WJPlayerStatusLoading,
    
    //待播放
    WJPlayerStatusReadyToPlay,
    
    //暂停
    WJPlayerStatusPaused,
    
    //播放
    WJPlayerStatusPlaying,
    
    //失败
    WJPlayerStatusFailed,
    
    //播放完成
    WJPlayerStatusCompleted,
};




/**
 播放器
 */
@protocol IWJPlayer <NSObject>

/**
 当前播放状态
 */
@property(nonatomic, assign, readonly) WJPlayerStatus status;

/**
 时长（秒）
 */
@property(nonatomic, assign, readonly) int duration;

/**
 当前播放时间（秒）
 */
@property(nonatomic, assign, readonly) int currentPlayTime;

/**
 加载时间（秒）
 */
@property(nonatomic, assign, readonly) int loadedTime;

/**
 媒体数据
 */
@property(nonatomic, strong, readonly) id<IWJMedia> mediaData;

/**
 是否静音
 */
@property(nonatomic, assign, getter=isMuted) BOOL muted;

/**
 视频尺寸大小
 注意：此方法没有KVO通知，需要手动获取
 */
@property(nonatomic, assign, readonly) CGSize videoSize;

/**
 媒体数据
 */
- (void)setMedia:(id<IWJMedia>)media;

/**
 播放
 */
- (void)play;

/**
 暂停
 */
- (void)pause;

/**
 重播
 */
- (void)replay;

/**
 滑动到指定时间播放
 */
- (void)seekToTime:(int)time;

@end
