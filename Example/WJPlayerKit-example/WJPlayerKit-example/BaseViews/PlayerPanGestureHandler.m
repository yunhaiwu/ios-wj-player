//
//  PlayerPanGestureHandler.m
//  WJPlayerKit-example
//
//  Created by ada on 2018/10/18.
//  Copyright © 2018年 PN. All rights reserved.
//

#import "PlayerPanGestureHandler.h"


@interface PlayerPanGestureData : NSObject
@property(nonatomic, assign) StateIndicatorType type;
@property(nonatomic, assign) CGPoint beginPoint;
@property(nonatomic, assign) float beginBrightness;
@property(nonatomic, assign) float currentBrightness;
@property(nonatomic, assign) int totalDuration;
@property(nonatomic, assign) int beginTime;
@property(nonatomic, assign) int currentTime;
@property(nonatomic, assign) float beginVolume;
@property(nonatomic, assign) float currentVolume;
-(void)reset;
-(NSNumber*)getValue;
@end

@implementation PlayerPanGestureData

-(void)reset {
    self.type = StateIndicatorTypeNone;
    self.beginPoint = CGPointZero;
    self.beginBrightness = 0.0f;
    self.currentBrightness = 0.0f;
    self.totalDuration = 0;
    self.beginTime = 0;
    self.currentTime = 0;
    self.currentVolume = 0.0f;
    self.beginVolume = 0.0f;
}

-(NSNumber *)getValue {
    NSNumber *value = nil;
    switch (_type) {
        case StateIndicatorTypeVolume:
            value = @(_currentVolume);
            break;
        case StateIndicatorTypeProgress:
            value = @(_currentTime);
            break;
        case StateIndicatorTypeBrightess:
            value = @(_currentBrightness);
            break;
        default:
            break;
    }
    return value;
}

@end
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface PlayerPanGestureHandler()

@property(nonatomic, copy) PlayerPanGestureHandlerCallbackBlock copyCallbackBlock;
@property(nonatomic, strong) PlayerPanGestureData *gestureData;
@end

@implementation PlayerPanGestureHandler

-(instancetype)init {
    self = [super init];
    if (self) {
        self.gestureData = [[PlayerPanGestureData alloc] init];
    }
    return self;
}

-(void)setCallbackBlock:(PlayerPanGestureHandlerCallbackBlock)block {
    self.copyCallbackBlock = block;
}

-(void)handleGesture:(UIPanGestureRecognizer *)gesture view:(UIView *)view player:(id<IWJPlayer>)player isFullScreen:(BOOL)isFullScreen {
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            [self.gestureData reset];
            self.gestureData.beginPoint = [gesture locationInView:view];
            self.copyCallbackBlock(self.gestureData.type, self.gestureData.getValue, NO);
            break;
        case UIGestureRecognizerStateChanged:
            
            self.copyCallbackBlock(self.gestureData.type, self.gestureData.getValue, NO);
            break;
        case UIGestureRecognizerStateEnded:
            
            self.copyCallbackBlock(self.gestureData.type, self.gestureData.getValue, YES);
            break;
        default:
            [self.gestureData reset];
            self.copyCallbackBlock(self.gestureData.type, self.gestureData.getValue, YES);
            break;
    }
}

-(void)determinePanGestureTypeIfNeeded:(CGPoint)translation player:(id<IWJPlayer>)player isFullScreen:(BOOL)isFullScreen {
    if (self.gestureData.type == StateIndicatorTypeNone) {
        if (fabs(translation.x) > 10.0f) {
            BOOL horizontal = NO;
            if (translation.y == 0.0f) {
                horizontal = YES;
            } else {
                horizontal = (fabs(translation.x/translation.y) > 5.0f);
            }
            if (horizontal) {
                self.gestureData.type = StateIndicatorTypeProgress;
                [self.gestureData setTotalDuration:[player duration]];
                [self.gestureData setBeginTime:[player currentPlayTime]];
            }
        } else if (fabs(translation.y) > 10.0f) {
            BOOL vertical = NO;
            if (translation.x == 0.0f) {
                vertical = YES;
            } else {
                vertical = (fabs(translation.y/translation.x) > 5.0f);
            }
            if (vertical) {
                CGFloat v = isFullScreen ? ([UIScreen mainScreen].bounds.size.height / 2.0f) : ([UIScreen mainScreen].bounds.size.width / 2.0f);
                if (self.gestureData.beginPoint.x < v) {
                    self.gestureData.type = StateIndicatorTypeBrightess;
                    self.gestureData.beginBrightness = [UIScreen mainScreen].brightness;
                } else {
                    self.gestureData.type = StateIndicatorTypeVolume;
//                    self.gestureData.beginVolume = [[self.gestureData volumeSlider] value];
                }
            }
        }
    }
}

-(void)handleTranslationPoint:(CGPoint)translationPoint {
    switch (_gestureData.type) {
        case StateIndicatorTypeVolume:
        {
            CGFloat value = fabs(translationPoint.y) / ([UIScreen mainScreen].bounds.size.width - 100.0f);
            if (translationPoint.y > 0) {
                if (_gestureData.beginVolume < value) {
//                    [[_panGestureInfo volumeSlider] setValue:0.0f];
                } else {
//                    [[_panGestureInfo volumeSlider] setValue:_panGestureInfo.beginVolume-value];
                }
            } else {
                if (_gestureData.beginVolume + value > 1.0f) {
//                    [[_panGestureInfo volumeSlider] setValue:1.0f];
                } else {
//                    [[_panGestureInfo volumeSlider] setValue:_panGestureInfo.beginVolume+value];
                }
            }
//            [_gestureData setCurrentVolume:[_panGestureInfo volumeSlider].value]
        }
            break;
        case StateIndicatorTypeBrightess:
        {
            CGFloat value = fabs(translationPoint.y) / ([UIScreen mainScreen].bounds.size.width - 100.0f);
            if (translationPoint.y > 0) {
                if (_gestureData.beginBrightness < value) {
                    [_gestureData setCurrentBrightness:0.0f];
                } else {
                    [_gestureData setCurrentBrightness:_gestureData.beginBrightness - value];
                }
            } else {
                if (_gestureData.beginBrightness + value > 1.0f) {
//                    [[UIScreen mainScreen] setBrightness:1.0f];
                    [_gestureData setCurrentBrightness:1.0f];
                } else {
                    [_gestureData setCurrentBrightness:_gestureData.beginBrightness+value];
//                    [[UIScreen mainScreen] setBrightness:_panGestureInfo.beginBrightness+value];
                }
            }
//            [_playerDragIndicatorView setBrightness:[UIScreen mainScreen].brightness];
        }
            break;
        case StateIndicatorTypeProgress:
        {
            int currentTime = _gestureData.beginTime + (int)translationPoint.x;
            if (currentTime < 0) {
                currentTime = 0;
            } else if (currentTime > _gestureData.totalDuration) {
                currentTime = _gestureData.totalDuration;
            }
            [_gestureData setCurrentTime:currentTime];
//            [_playerDragIndicatorView setBeginTime:_panGestureInfo.beginCurrentTime];
//            [_playerDragIndicatorView setTotalDuration:_panGestureInfo.totalDuration];
//            [_playerDragIndicatorView setCurrentTime:currentTime];
//            if (ended) {
//                //跳转操作
//                [self.player seekToTime:CMTimeMake(currentTime, 1.0f)];
//                [self.player play];
//            }
        }
            break;
        default:
            break;
    }
}



@end
