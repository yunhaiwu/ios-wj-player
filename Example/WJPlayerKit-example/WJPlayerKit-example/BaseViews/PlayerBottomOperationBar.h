//
//  PlayerBottomOperationBar.h
//  WJPlayerKit-example
//
//  Created by ada on 2018/10/18.
//  Copyright © 2018年 PN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerSlider.h"
#import "ReactiveObjC.h"

/**
 底部操作栏block

 @param progress 更新进度
 @param playOrPause 播放或者暂停
 @param transform 全屏/退出全屏
 */
typedef void (^PlayerBottomOperationBarActionBlock)(float progress, BOOL playOrPause, BOOL transform);

/**
 底部控制栏 height 44.0f
 */
@interface PlayerBottomOperationBar : UIView

/**
 slider
 */
@property(nonatomic, weak, readonly) PlayerSlider *slider;

/**
 slider value
 */
@property(nonatomic, assign) float progress;

/**
 是否显示播放状态
 */
@property(nonatomic, assign) BOOL playing;


-(void)setActionBlock:(PlayerBottomOperationBarActionBlock)actionBlock;

@end
