//
//  PlayerPanGestureHandler.m
//  WJPlayerKit-example
//
//  Created by ada on 2018/10/18.
//  Copyright © 2018年 PN. All rights reserved.
//

#import "PlayerPanGestureHandler.h"

@interface PlayerPanGestureHandler()

@property(nonatomic, copy) PlayerPanGestureHandlerCallbackBlock copyCallbackBlock;

@end

@implementation PlayerPanGestureHandler

-(void)setCallbackBlock:(PlayerPanGestureHandlerCallbackBlock)block {
    self.copyCallbackBlock = block;
}

-(void)handleGesture:(UIPanGestureRecognizer *)gesture view:(UIView *)view {
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            
            break;
        case UIGestureRecognizerStateEnded:
            
            break;
        default:
            break;
    }
    
}

@end
