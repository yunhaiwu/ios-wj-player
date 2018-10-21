//
//  FullScreenPlayerControlView.h
//  WJPlayerKit-example
//
//  Created by ada on 2018/10/19.
//  Copyright © 2018年 PN. All rights reserved.
//

#import "BasePlayerControlView.h"

typedef void (^FullScreenPlayerControlViewActionBlock)(BOOL transform);

/**
 全屏播放器控制视图
 */
@interface FullScreenPlayerControlView : BasePlayerControlView

- (void)setActionBlock:(FullScreenPlayerControlViewActionBlock)actionBlock;

@end
