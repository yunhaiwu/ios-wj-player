//
//  SimplePlayerControlView.h
//  WJPlayer
//
//  Created by ada on 2018/9/13.
//  Copyright © 2018年 PN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IWJPlayerControlView.h"

/**
 普通播放器控制视图
 */
@interface Simple2PlayerControlView : UIView<IWJPlayerControlView>

@property(nonatomic, weak) id<IWJPlayer> player;

@end
