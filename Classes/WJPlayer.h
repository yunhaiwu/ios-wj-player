//
//  PNVideoDisplayView.h
//  WJPlayer
//
//  Created by Yunhai.Wu on 2018/9/8.
//  Copyright © 2018年 PN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IWJPlayer.h"

/**
 视频展示视图
 */
@interface WJPlayer : UIView<IWJPlayer>

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
 媒体文件url
 */
@property(nonatomic, strong, readonly) id<IWJMedia> mediaData;

/**
 是否静音
 */
@property(nonatomic, assign, getter=isMuted) BOOL muted;

/**
 视频尺寸大小
 */
@property(nonatomic, assign, readonly) CGSize videoSize;


@end
