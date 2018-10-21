//
//  BottomBarPlayerControlView.h
//  WJPlayerKit-example
//
//  Created by ada on 2018/10/21.
//  Copyright © 2018年 PN. All rights reserved.
//

#import "BasePlayerControlView.h"

typedef void (^BottomBarPlayerControlViewActionBlock)(BOOL transform);

/**
 带底部bar控制视图，可用在沉浸式/PGC落地页
 */
@interface BottomBarPlayerControlView : BasePlayerControlView

- (void)setActionBlock:(BottomBarPlayerControlViewActionBlock)actionBlock;

@end
