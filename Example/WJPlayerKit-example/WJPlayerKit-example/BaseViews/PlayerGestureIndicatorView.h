//
//  PlayerGestureIndicatorView.h
//  WJPlayerKit-example
//
//  Created by ada on 2018/10/18.
//  Copyright © 2018年 PN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerGestureData.h"

/**
 拖拽标识视图
 */
@interface PlayerGestureIndicatorView : UIView

-(void)refreshGestureData:(PlayerGestureData*)gestureData;

@end
