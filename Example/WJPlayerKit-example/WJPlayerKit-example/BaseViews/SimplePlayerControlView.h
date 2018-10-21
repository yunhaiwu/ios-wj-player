//
//  SimplePlayerControlView.h
//  WJPlayerKit-example
//
//  Created by ada on 2018/10/21.
//  Copyright © 2018年 PN. All rights reserved.
//

#import "BasePlayerControlView.h"

typedef void (^SimplePlayerControlViewActionBlock)(BOOL tapped);

/**
 简单控制视图
 */
@interface SimplePlayerControlView : BasePlayerControlView

/**
 单击视频响应
 */
-(void)setActionBlock:(SimplePlayerControlViewActionBlock)actionBlock;

@end
