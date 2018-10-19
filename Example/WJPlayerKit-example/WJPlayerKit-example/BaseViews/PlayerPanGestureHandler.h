//
//  PlayerPanGestureHandler.h
//  WJPlayerKit-example
//
//  Created by ada on 2018/10/18.
//  Copyright © 2018年 PN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayerStateIndicatorView.h"

typedef void (^PlayerPanGestureHandlerCallbackBlock)(StateIndicatorType type, BOOL seek, int seekValue, BOOL brightness, float brightnessValue, BOOL progress, int progressValue);

/**
 播放器拖拽手势处理器
 */
@interface PlayerPanGestureHandler : NSObject


-(void)setCallbackBlock:(PlayerPanGestureHandlerCallbackBlock)block;

/**
 处理手势
 */
-(void)handleGesture:(UIPanGestureRecognizer*)gesture view:(UIView*)view;

@end
