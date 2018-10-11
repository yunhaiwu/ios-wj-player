//
//  SimpleVideoControlView.h
//  WJPlayer
//
//  Created by Yunhai.Wu on 2018/9/9.
//  Copyright © 2018年 PN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IWJPlayerControlView.h"

@class SimpleVideoControlView;

@protocol SimpleVideoControlViewDelegate <NSObject>
-(void)simpleVideoControlViewDidFullScreen:(SimpleVideoControlView*)view;
@end

@interface SimpleVideoControlView : UIView<IWJPlayerControlView>

@property(nonatomic, weak) id<IWJPlayer> player;

@property(nonatomic, weak) id<SimpleVideoControlViewDelegate> delegate;

+(instancetype)instance;

@end
