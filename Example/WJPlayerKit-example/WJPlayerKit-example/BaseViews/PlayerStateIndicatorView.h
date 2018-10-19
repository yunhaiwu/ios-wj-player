//
//  PlayerStateIndicatorView.h
//  WJPlayerKit-example
//
//  Created by ada on 2018/10/18.
//  Copyright © 2018年 PN. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, StateIndicatorType) {
    
    //无
    StateIndicatorTypeNone,
    
    //播放进度
    StateIndicatorTypeProgress,
    
    //亮度
    StateIndicatorTypeBrightess,
    
    //声音
    StateIndicatorTypeVolume,
};

/**
 拖拽标识视图
 */
@interface PlayerStateIndicatorView : UIView

//类型
@property(nonatomic, assign) StateIndicatorType type;

//亮度
@property(nonatomic, assign) float brightness;

//播放进度
@property(nonatomic, assign) int currentTime,beginTime,totalDuration;

@end
