//
//  BasePlayerControlView.h
//  WJPlayerKit-example
//
//  Created by ada on 2018/10/18.
//  Copyright © 2018年 PN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IWJPlayerControlView.h"
#import "ReactiveObjC.h"
#import "PlayerStateIndicatorView.h"
/**
 播放器控制视图基类
 */
@interface BasePlayerControlView : UIView<IWJPlayerControlView>

/**
 播放器
 */
@property(nonatomic, weak) id<IWJPlayer> player;

/**
 单击手势（显示、隐藏操作栏）
 default NO
 */
@property(nonatomic, assign) BOOL enableSingleTapGesture;

/**
 双击手势(暂停、播放)
 default NO
 */
@property(nonatomic, assign) BOOL enableDoubleTapGesture;

/**
 拖拽手势（快进、快退、亮度、音量）
 default NO
 */
@property(nonatomic, assign) BOOL enablePanGesture;

/**
 是否启用重播视图
 default YES
 */
@property(nonatomic, assign) BOOL enableReplyView;

/**
 是否启用播放按钮
 default YES
 */
@property(nonatomic, assign) BOOL enableBtnPlay;

/**
 是否为全屏Control View
 default NO
 */
@property(nonatomic, assign) BOOL isFullScreen;


@property(nonatomic, weak) PlayerStateIndicatorView *stateIndicatorView;

/**
 顶部操作栏
 */
@property(nonatomic, weak) UIView *topOperationBar,*bottomOperationBar;

/**
 添加观察者
 */
-(void)addPlayerObserver:(NSHashTable<RACDisposable*>*)disposables;

/**
 刷新播放状态
 注意：子类不要重写、当player.status 变更时调用
 */
- (void)refreshPlayStatus:(WJPlayerStatus)status;

/**
 单击手势处理方法
 默认实现：显示或者隐藏操作栏
 */
- (void)singleTapGestureHandler;

/**
 双击手势
 默认实现：暂停或播放，子类可重写方法实现新逻辑
 */
- (void)doubleTapGestureHandler;

/**
 显示操作栏
 子类不要继承重写
 */
- (void)showOperationBar:(BOOL)animated;

/**
 隐藏操作栏
 子类不要继承重写
 */
- (void)hideOperatonBar:(BOOL)animated;

/**
 显示/隐藏操作栏
 子类不要继承重写
 */
-(void)toggleOperationBar:(BOOL)animated;

/**
 当前操作栏是否已隐藏
 子类不要继承重写
 */
- (BOOL)isOperationBarHidden;

/**
 取消隐藏bar定时器
 子类不要继承重写
 */
- (void)cancelHideBarTimer;

/**
 开启隐藏bar定时器
 子类不要继承重写
 */
- (void)startHideBarTimer;

@end
