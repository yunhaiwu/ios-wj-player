//
//  PlayerLoadingView.m
//  WJPlayerKit-example
//
//  Created by ada on 2018/10/18.
//  Copyright © 2018年 PN. All rights reserved.
//

#import "PlayerLoadingView.h"

@interface PlayerLoadingView()

@property(nonatomic, weak) UIImageView *animatedImage;

@property(nonatomic, weak) CADisplayLink *displayLink;

@end

@implementation PlayerLoadingView

-(instancetype)init {
    self =[super init];
    if (self) {
        [self loadSubviews];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self loadSubviews];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadSubviews];
    }
    return self;
}

-(void)loadSubviews {
    if (!_animatedImage) {
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"player-loading"]];
        [img setFrame:self.bounds];
        [self addSubview:img];
        [img setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
        _animatedImage = img;
    }
    [self setUserInteractionEnabled:NO];
    [self setBackgroundColor:[UIColor clearColor]];
    [self setClipsToBounds:YES];
}

- (void)rotateAction {
    [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        self.animatedImage.transform = CGAffineTransformRotate(self.animatedImage.transform, 180 * M_PI_2 / 180.0f );
    } completion:NULL];
}

-(void)startAnimating {
    if (![self isAnimating]) {
        CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(rotateAction)];
        if (@available(iOS 10.0, *)) {
            //每秒钟调用4次
            [link setPreferredFramesPerSecond:4];
        } else {
            //每12帧调用一次
            [link setFrameInterval:12];
        }
        [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        self.displayLink = link;
    }
}

-(void)stopAnimating {
    if ([self isAnimating]) {
        [self.displayLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}

-(BOOL)isAnimating {
    if (self.displayLink) {
        return YES;
    }
    return NO;
}

@end
