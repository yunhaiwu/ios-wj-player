//
//  PlayerSlider.m
//  WJPlayerKit-example
//
//  Created by ada on 2018/10/18.
//  Copyright © 2018年 PN. All rights reserved.
//

#import "PlayerSlider.h"

@implementation PlayerSlider

-(instancetype)init {
    self = [super init];
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

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self performInitialize];
    }
    return self;
}

-(void)performInitialize {
    self.maximumValue = 1.0f;
    self.minimumValue = 0.0f;
    self.layer.masksToBounds = YES;
    self.maximumTrackTintColor = [UIColor whiteColor];
    self.minimumTrackTintColor = [UIColor colorWithRed:1.0f green:38.0f/255.0f blue:97.0f/255.0f alpha:1];
    [self setThumbImage:[UIImage imageNamed:@"player-slider-thumb"] forState:UIControlStateNormal];
}

#pragma mark rewrite
-(CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value {
    rect.origin.x = rect.origin.x - 7;
    rect.size.width = rect.size.width + 14;
    return CGRectInset ([super thumbRectForBounds:bounds trackRect:rect value:value], 7 , 7);
    
}

@end
