//
//  PlayerLoadingView.h
//  WJPlayerKit-example
//
//  Created by ada on 2018/10/18.
//  Copyright © 2018年 PN. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 播放器加载动画视图
 */
@interface PlayerLoadingView : UIView

/**
 *  开始动画(主线程中调用)
 */
- (void)startAnimating;

/**
 *  停止动画(主线程中调用)
 */
- (void)stopAnimating;

/**
 *  是否在动画(主线程中调用)
 */
- (BOOL)isAnimating;


@end
