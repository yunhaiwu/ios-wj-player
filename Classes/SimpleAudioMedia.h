//
//  SimpleAudioMedia.h
//  WJPlayer
//
//  Created by ada on 2018/9/24.
//  Copyright © 2018年 PN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IWJMedia.h"

/**
 音频文件
 */
@interface SimpleAudioMedia : NSObject<IWJMedia>

/**
 视频url
 */
@property(nonatomic, strong) NSURL *videoUrl;

/**
 海报url
 */
@property(nonatomic, strong) NSURL *posterUrl;

/**
 初始化方法
 @param videoUrl 视频地址
 @param posterUrl 海报地址
 @return SimpleVideoMedia
 */
- (instancetype)initWithVideoUrl:(NSString*)videoUrl posterUrl:(NSString*)posterUrl;

@end
