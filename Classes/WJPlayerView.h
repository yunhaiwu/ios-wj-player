//
//  WJPlayerView.h
//  WJPlayer
//
//  Created by Yunhai.Wu on 2018/9/8.
//  Copyright © 2018年 PN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IWJPlayerControlView.h"
#import "IWJPlayerPosterView.h"
#import "IWJPlayer.h"
#import "IWJMedia.h"

/**
 WJPlayerView 子视图层级关系
 0:PosterView
 1:WJPlayer
 2:ControlView
 */
@interface WJPlayerView : UIView

/**
 播放器
 */
@property(nonatomic, weak, readonly) UIView<IWJPlayer> *player;

/**
 控制视图
 */
@property(nonatomic, weak, readonly) UIView<IWJPlayerControlView> *controlView;

/**
 当前海报视图
 */
@property(nonatomic, weak, readonly) UIView<IWJPlayerPosterView> *posterView;

/**
 替换控制视图
 */
- (void)replaceControlView:(UIView<IWJPlayerControlView>*)controlView;

/**
 替换海报视图
 */
- (void)replacePosterView:(UIView<IWJPlayerPosterView>*)posterView;


/**
 替换播放视图
 */
- (void)replacePlayer:(UIView<IWJPlayer>*)player;

/**
 初始化方法
 */
- (instancetype)initWithControlView:(UIView<IWJPlayerControlView>*)controlView;

/**
 初始化方法
 */
- (instancetype)initWithControlView:(UIView<IWJPlayerControlView>*)controlView posterView:(UIView<IWJPlayerPosterView>*)posterView;


/**
 播放
 @param media 媒体数据
 @param autoPlay 是否自动播放
 */
-(void)setMedia:(id<IWJMedia>)media autoPlay:(BOOL)autoPlay;

/**
 播放
 */
-(void)play;

/**
 暂停
 */
-(void)pause;

/**
 获取并从当前父视图移除
 */
-(UIView<IWJPlayer>*)fetchPlayerAndRemoveFromSuperview;




@end
