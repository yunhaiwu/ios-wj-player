//
//  PlayerGestureIndicatorView.m
//  WJPlayerKit-example
//
//  Created by ada on 2018/10/18.
//  Copyright © 2018年 PN. All rights reserved.
//

#import "PlayerGestureIndicatorView.h"
#import "ReactiveObjC.h"

@interface PlayerGestureIndicatorView()

@property(nonatomic, weak) UIImageView *indicatorImage;
@property(nonatomic, weak) UILabel *indicatorLab;

@end

@implementation PlayerGestureIndicatorView

-(instancetype)init {
    self = [super init];
    if (self) {
        [self performInitialize];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self performInitialize];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self performInitialize];
    }
    return self;
}

-(void)performInitialize {
    if (!_indicatorImage) {
        UIImageView *image = [[UIImageView alloc] init];
        [self addSubview:image];
        _indicatorImage = image;
        UILabel *label = [[UILabel alloc] init];
        [self addSubview:label];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
        [label setTextColor:[UIColor whiteColor]];
        _indicatorLab = label;
    }
    [self setUserInteractionEnabled:NO];
    [self setBackgroundColor:[UIColor clearColor]];
    [self setHidden:YES];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [_indicatorImage setFrame:CGRectMake((self.bounds.size.width-36.0f)/2.0f, (self.bounds.size.height-50.0f)/2.0f - 20.0f, 36, 27)];
    [_indicatorLab setFrame:CGRectMake((self.bounds.size.width-100.0f)/2.0f, _indicatorImage.frame.origin.y+_indicatorImage.frame.size.height+7.0f, 100.0f, 16.0f)];
    [CATransaction commit];
}

- (NSString *)formatTimeToString:(int)time{
    int dMinutes = floor(time % 3600 / 60);
    int dSeconds = floor(time % 3600 % 60);
    if (time <= 0) {
        return @"00:00";
    } else {
        return [NSString stringWithFormat:@"%02i:%02i", dMinutes, dSeconds];
    }
}

- (void)refreshGestureData:(PlayerGestureData *)gestureData {
    PanGestureFuncType type = [gestureData funcType];
    switch (type) {
        case PanGestureFuncTypeProgress:
            [self setHidden:NO];
            if (gestureData.beginTime > gestureData.currentTime) {
                [_indicatorImage setImage:[UIImage imageNamed:@"player-indicator-progress-backward"]];
            } else {
                [_indicatorImage setImage:[UIImage imageNamed:@"player-indicator-progress-forward"]];
            }
            [_indicatorLab setText:[NSString stringWithFormat:@"%@ / %@",[self formatTimeToString:gestureData.currentTime],[self formatTimeToString:gestureData.totalDuration]]];
            [_indicatorLab setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
            break;
        case PanGestureFuncTypeBrightess:
            [self setHidden:NO];
            [_indicatorImage setImage:[UIImage imageNamed:@"player-indicator-brightness"]];
            [_indicatorLab setText:[NSString stringWithFormat:@"%i%%",(int)(gestureData.currentBrightness*100)]];
            [_indicatorLab setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
            break;
        case PanGestureFuncTypeVolume:
            [self setHidden:NO];
            [_indicatorImage setImage:[UIImage imageNamed:@"player-indicator-volume"]];
            [_indicatorLab setText:[NSString stringWithFormat:@"%i%%",(int)(gestureData.currentBrightness*100)]];
            [_indicatorLab setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
            break;
        default:
            [self setHidden:YES];
            break;
    }
}

@end
