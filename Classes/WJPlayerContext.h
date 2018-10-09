//
//  WJPlayerContext.h
//  WJPlayer
//
//  Created by Yunhai.Wu on 2018/9/8.
//  Copyright © 2018年 PN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IWJPlayer.h"

#define WJ_PLAYER_CONTEXT_TIME_GET(K)            [[WJPlayerContext sharedInstance] timeForKey:K]
#define WJ_PLAYER_CONTEXT_TIME_SET(K,V)          [[WJPlayerContext sharedInstance] setTime:V forKey:K]
#define WJ_PLAYER_CONTEXT_CURRENT_PLAYER_SET(V)  [[WJPlayerContext sharedInstance] setCurrentPlayer:V]
#define WJ_PLAYER_CONTEXT_CURRENT_PLAYER_GET     [[WJPlayerContext sharedInstance] currentPlayer]

/**
 播放位置时间缓存
 */
@interface WJPlayerContext : NSObject

/**
 当前正在播放播放器
 */
@property(nonatomic, weak) id<IWJPlayer> currentPlayer;

- (void)setTime:(int)time forKey:(NSString*)key;

- (int)timeForKey:(NSString*)key;

+ (instancetype)sharedInstance;

@end
