//
//  PlayerReplayView.h
//  WJPlayerKit-example
//
//  Created by ada on 2018/10/18.
//  Copyright © 2018年 PN. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PlayerReplayViewActionBlock)(void);

/**
 重新播放视图
 */
@interface PlayerReplayView : UIView

-(void)setActionBlock:(PlayerReplayViewActionBlock)actionBlock;

@end
