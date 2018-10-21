//
//  PlayerGestureData.m
//  WJPlayerKit-example
//
//  Created by ada on 2018/10/21.
//  Copyright © 2018年 PN. All rights reserved.
//

#import "PlayerGestureData.h"

@implementation PlayerGestureData

-(void)reset {
    self.funcType = PanGestureFuncTypeNone;
    self.beginPoint = CGPointZero;
    self.totalDuration = 0;
    self.beginTime = 0;
    self.currentTime = 0;
    self.currentBrightness = 0.0f;
    self.beginBrightness = 0.0f;
    self.currentVolume = 0.0f;
    self.beginVolume = 0.0f;
}

static PlayerGestureData *sharedGestureData;

+(PlayerGestureData *)getCacheGestureData {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGestureData = [[PlayerGestureData alloc] init];
    });
    return sharedGestureData;
}

@end
