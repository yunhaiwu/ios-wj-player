//
//  PlayerGestureData.h
//  WJPlayerKit-example
//
//  Created by ada on 2018/10/21.
//  Copyright © 2018年 PN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

/**
 手势功能
 */
typedef NS_ENUM(NSInteger, PanGestureFuncType) {
    
    //无
    PanGestureFuncTypeNone,
    
    //播放进度
    PanGestureFuncTypeProgress,
    
    //亮度
    PanGestureFuncTypeBrightess,
    
    //声音
    PanGestureFuncTypeVolume,
};

/**
 播放器手势数据
 */
@interface PlayerGestureData : NSObject

@property(nonatomic, assign) PanGestureFuncType funcType;

@property(nonatomic, assign) CGPoint beginPoint;

@property(nonatomic, assign) int totalDuration, beginTime, currentTime;

@property(nonatomic, assign) float currentVolume, beginVolume;

@property(nonatomic, assign) float currentBrightness, beginBrightness;

-(void)reset;


/**
 获取缓存播放进度手势数据
 */
+(PlayerGestureData*)getCacheGestureData;

@end

