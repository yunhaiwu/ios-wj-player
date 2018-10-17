//
//  BaseAskPlayControlView.h
//  WJPlayerKit-example
//
//  Created by ada on 2018/10/15.
//  Copyright © 2018年 PN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IWJPlayerControlView.h"

@class AbstractAskPlayControlView;

@protocol AskPlayControlViewDelegate <NSObject>

-(void)askPlayControlViewDidContinue:(AbstractAskPlayControlView*)controlView;

@end


@interface AbstractAskPlayControlView : UIView<IWJPlayerControlView>

@property(nonatomic, weak) id<IWJPlayer> player;

@property(nonatomic, weak) id<AskPlayControlViewDelegate> askDelegate;

//继续播放
-(void)continuePlay;

@end
