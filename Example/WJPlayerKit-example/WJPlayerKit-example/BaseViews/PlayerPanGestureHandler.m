//
//  PlayerPanGestureHandler.m
//  WJPlayerKit-example
//
//  Created by ada on 2018/10/18.
//  Copyright © 2018年 PN. All rights reserved.
//

#import "PlayerPanGestureHandler.h"
#import <MediaPlayer/MediaPlayer.h>

@interface PlayerPanGestureHandler()

@property(nonatomic, copy) PlayerPanGestureHandlerCallbackBlock copyCallbackBlock;
@property(nonatomic, strong) PlayerGestureData *gestureData;
@property(nonatomic, strong) MPVolumeView *volumeView;
@property(nonatomic, weak) UISlider *volumeSlider;
@end

@implementation PlayerPanGestureHandler

- (void)initVolumeView {
    if (!_volumeView) {
        MPVolumeView *v = [[MPVolumeView alloc] initWithFrame:CGRectZero];
        self.volumeView = v;
        for (UIView *view in [v subviews]){
            if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
                self.volumeSlider = (UISlider*)view;
                break;
            }
        }
    }
}

-(instancetype)init {
    self = [super init];
    if (self) {
        self.gestureData = [[PlayerGestureData alloc] init];
    }
    return self;
}

-(void)setCallbackBlock:(PlayerPanGestureHandlerCallbackBlock)block {
    self.copyCallbackBlock = block;
}

-(void)handleGesture:(UIPanGestureRecognizer *)gesture view:(UIView *)view player:(id<IWJPlayer>)player {
    CGPoint translationPoint = [gesture translationInView:view];
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            [self.gestureData reset];
            self.gestureData.beginPoint = [gesture locationInView:view];
            self.copyCallbackBlock(self.gestureData, NO);
            break;
        case UIGestureRecognizerStateChanged:
        {
            [self determinePanGestureTypeIfNeeded:translationPoint player:player];
            [self handleTranslationPoint:translationPoint];
            self.copyCallbackBlock(self.gestureData, NO);
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            [self determinePanGestureTypeIfNeeded:translationPoint player:player];
            [self handleTranslationPoint:translationPoint];
            self.copyCallbackBlock(self.gestureData, YES);
            [self.gestureData reset];
            self.copyCallbackBlock(self.gestureData, NO);
        }
            break;
        default:
            [self.gestureData reset];
            self.copyCallbackBlock(self.gestureData, NO);
            break;
    }
}

-(void)determinePanGestureTypeIfNeeded:(CGPoint)translation player:(id<IWJPlayer>)player {
    if (self.gestureData.funcType == PanGestureFuncTypeNone) {
        if (fabs(translation.x) > 10.0f) {
            BOOL horizontal = NO;
            if (translation.y == 0.0f) {
                horizontal = YES;
            } else {
                horizontal = (fabs(translation.x/translation.y) > 5.0f);
            }
            if (horizontal) {
                self.gestureData.funcType = PanGestureFuncTypeProgress;
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
                CGFloat v = [UIScreen mainScreen].bounds.size.width / 2.0f;
                if (self.gestureData.beginPoint.x < v) {
                    self.gestureData.funcType = PanGestureFuncTypeBrightess;
                    self.gestureData.beginBrightness = [UIScreen mainScreen].brightness;
                    self.gestureData.currentVolume = self.gestureData.beginBrightness;
                } else {
                    self.gestureData.funcType = PanGestureFuncTypeVolume;
                    [self initVolumeView];
                    self.gestureData.beginVolume = [self.volumeSlider value];
                }
            }
        }
    }
}

-(void)handleTranslationPoint:(CGPoint)translationPoint {
    switch (_gestureData.funcType) {
        case PanGestureFuncTypeVolume:
        {
            
            CGFloat denominator = [UIScreen mainScreen].bounds.size.width < [UIScreen mainScreen].bounds.size.height ? [UIScreen mainScreen].bounds.size.width : [UIScreen mainScreen].bounds.size.height;
            CGFloat value = fabs(translationPoint.y) / (denominator - 100.0f);
            if (translationPoint.y > 0) {
                if (_gestureData.beginVolume < value) {
                    _gestureData.currentVolume = 0.0f;
                } else {
                    _gestureData.currentVolume = _gestureData.beginVolume - value;
                }
            } else {
                if (_gestureData.beginVolume + value > 1.0f) {
                    _gestureData.currentVolume = 1.0f;
                } else {
                    _gestureData.currentVolume = _gestureData.beginVolume + value;
                }
            }
            [self.volumeSlider setValue:self.gestureData.currentVolume];
        }
            break;
        case PanGestureFuncTypeBrightess:
        {
            CGFloat denominator = [UIScreen mainScreen].bounds.size.width < [UIScreen mainScreen].bounds.size.height ? [UIScreen mainScreen].bounds.size.width : [UIScreen mainScreen].bounds.size.height;
            CGFloat value = fabs(translationPoint.y) / (denominator - 100.0f);
            if (translationPoint.y > 0) {
                if (_gestureData.beginBrightness < value) {
                    _gestureData.currentBrightness = 0.0f;
                } else {
                    _gestureData.currentBrightness = _gestureData.beginBrightness - value;
                }
            } else {
                if (_gestureData.beginBrightness + value > 1.0f) {
                    _gestureData.currentBrightness = 1.0f;
                } else {
                    _gestureData.currentBrightness = _gestureData.beginBrightness + value;
                }
            }
            [[UIScreen mainScreen] setBrightness:_gestureData.currentVolume];
        }
            break;
        case PanGestureFuncTypeProgress:
        {
            int currentTime = _gestureData.beginTime + (int)translationPoint.x;
            if (currentTime < 0) {
                currentTime = 0;
            } else if (currentTime > _gestureData.totalDuration) {
                currentTime = _gestureData.totalDuration;
            }
            [_gestureData setCurrentTime:currentTime];
        }
            break;
        default:
            break;
    }
}



@end
