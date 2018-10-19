//
//  HomePlayerBottomOperationBar.h
//  WJPlayerKit-example
//
//  Created by ada on 2018/10/19.
//  Copyright © 2018年 PN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReactiveObjC.h"
#import "PlayerSlider.h"

typedef void (^HomePlayerBottomOperationBarActionBlock)(BOOL playOrPause, BOOL mute);


//height : 36.0f
@interface HomePlayerBottomOperationBar : UIView

/**
 slider
 */
@property(nonatomic, weak, readonly) PlayerSlider *slider;

@property(nonatomic, assign) BOOL playing;

@property(nonatomic, assign) BOOL mute;

@property(nonatomic, assign) int currentTime,totalTime;

-(void)setActionBlock:(HomePlayerBottomOperationBarActionBlock)actionBlock;

@end
