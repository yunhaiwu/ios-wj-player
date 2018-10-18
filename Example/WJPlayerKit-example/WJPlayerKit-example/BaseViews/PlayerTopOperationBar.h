//
//  PlayerTopOperationBar.h
//  WJPlayerKit-example
//
//  Created by ada on 2018/10/18.
//  Copyright © 2018年 PN. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PlayerTopOperationBarActionBlock)(void);

/**
 播放器顶部操作栏 height:44.0f
 */
@interface PlayerTopOperationBar : UIView

-(void)setActionBlock:(PlayerTopOperationBarActionBlock)actionBlock;

@end
