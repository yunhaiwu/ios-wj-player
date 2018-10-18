//
//  BasePlayerControlView.h
//  WJPlayerKit-example
//
//  Created by ada on 2018/10/18.
//  Copyright © 2018年 PN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IWJPlayerControlView.h"
#import "PlayerLoadingView.h"
#import "ReactiveObjC.h"

/**
 播放器控制视图基类
 */
@interface BasePlayerControlView : UIView<IWJPlayerControlView>

/**
 播放器
 */
@property(nonatomic, weak) id<IWJPlayer> player;

/**
 loading 视图
 */
@property(nonatomic, weak, readonly) PlayerLoadingView *loadingView;

/**
 添加观察者
 */
-(void)addPlayerObserver:(NSHashTable<RACDisposable*>*)disposables;


/**
 开始视频加载动画
 */
- (void)startLoadingAnimated;

/**
 停止视频加载动画
 */
- (void)stopLoadingAnimated;

@end
