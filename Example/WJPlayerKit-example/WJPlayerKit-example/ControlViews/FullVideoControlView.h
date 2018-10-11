//
//  FullVideoControlView.h
//  WJPlayerKit-example
//
//  Created by ada on 2018/10/11.
//  Copyright © 2018年 PN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IWJPlayerControlView.h"

@class FullVideoControlView;

@protocol FullVideoControlViewDelegate <NSObject>
-(void)fullVideoControlViewDidQuitFullScreen:(FullVideoControlView*)view;
@end

@interface FullVideoControlView : UIView<IWJPlayerControlView>

@property(nonatomic, weak) id<IWJPlayer> player;

@property(nonatomic, weak) id<FullVideoControlViewDelegate> delegate;

+(instancetype)instance;

@end
