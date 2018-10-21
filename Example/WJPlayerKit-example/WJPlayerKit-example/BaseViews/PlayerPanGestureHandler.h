//
//  PlayerPanGestureHandler.h
//  WJPlayerKit-example
//
//  Created by ada on 2018/10/18.
//  Copyright © 2018年 PN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayerStateIndicatorView.h"
#import "IWJPlayer.h"
#import "PlayerGestureData.h"

typedef void (^PlayerPanGestureHandlerCallbackBlock)(PlayerGestureData *gesture, BOOL isEnd);

/**
 播放器拖拽手势处理器
 */
@interface PlayerPanGestureHandler : NSObject

-(void)setCallbackBlock:(PlayerPanGestureHandlerCallbackBlock)block;

/**
 处理手势
 */
-(void)handleGesture:(UIPanGestureRecognizer*)gesture view:(UIView*)view player:(id<IWJPlayer>)player isFullScreen:(BOOL)isFullScreen;

@end
