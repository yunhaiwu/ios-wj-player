//
//  IWJPlayerControlView.h
//  WJPlayer
//
//  Created by Yunhai.Wu on 2018/9/8.
//  Copyright © 2018年 PN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IWJPlayer.h"
/**
 播放器控制视图
 */
@protocol IWJPlayerControlView <NSObject>

/**
 播放器
 */
@property(nonatomic, weak) id<IWJPlayer> player;


@end
