//
//  SimpleVideoPlayView.m
//  WJPlayerKit-example
//
//  Created by ada on 2018/10/11.
//  Copyright © 2018年 PN. All rights reserved.
//

#import "SimpleVideoPlayView.h"
#import "SimpleVideoControlView.h"
#import "FullVideoControlView.h"
#import "GaussianBlurPlayerPosterView.h"

@interface SimpleVideoPlayView ()<SimpleVideoControlViewDelegate, FullVideoControlViewDelegate>

@property(nonatomic, assign) BOOL currentHasFullScreen;

@end

@implementation SimpleVideoPlayView

#define APPLICATION_KEY_WINDOW  [[UIApplication sharedApplication] keyWindow]

#pragma mark SimpleVideoControlViewDelegate
-(void)simpleVideoControlViewDidFullScreen:(SimpleVideoControlView *)view {
    if (!_currentHasFullScreen) {
        _currentHasFullScreen = YES;
        WJPlayerView *pv = _playerView;
        [_playerView removeFromSuperview];
        [APPLICATION_KEY_WINDOW addSubview:pv];
        [UIView animateWithDuration:0.35f animations:^{
            pv.transform = CGAffineTransformMakeRotation(M_PI_2);
            [pv setBounds:CGRectMake(0, 0, APPLICATION_KEY_WINDOW.bounds.size.height, APPLICATION_KEY_WINDOW.bounds.size.width)];
            [pv setCenter:CGPointMake(CGRectGetMidX(APPLICATION_KEY_WINDOW.bounds), CGRectGetMidY(APPLICATION_KEY_WINDOW.bounds))];
        } completion:^(BOOL finished) {
            FullVideoControlView *cv = [FullVideoControlView instance];
            [cv setDelegate:self];
            [pv replaceControlView:cv];
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
        }];
    }
}

#pragma mark FullVideoControlViewDelegate
-(void)fullVideoControlViewDidQuitFullScreen:(FullVideoControlView *)view {
    if (_currentHasFullScreen) {
        _currentHasFullScreen = NO;
        //退出全屏
        WJPlayerView *pv = _playerView;
        CGRect f = [self convertRect:self.bounds toView:APPLICATION_KEY_WINDOW];
        [UIView animateWithDuration:0.35f animations:^{
            pv.transform = CGAffineTransformIdentity;
            [pv setFrame:f];
            [pv setCenter:CGPointMake(CGRectGetMidX(f), CGRectGetMidY(f))];
        } completion:^(BOOL finished) {
            [pv removeFromSuperview];
            SimpleVideoControlView *cv = [SimpleVideoControlView instance];
            [self addSubview:pv];
            [cv setDelegate:self];
            [pv replaceControlView:cv];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
#pragma clang diagnostic pop
            
        }];
    }
}

-(instancetype)init {
    self = [super init];
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
    if (!_playerView) {
        SimpleVideoControlView *controlView = [SimpleVideoControlView instance];
        GaussianBlurPlayerPosterView *posterView = [[GaussianBlurPlayerPosterView alloc] init];
        [controlView setDelegate:self];
        WJPlayerView *p = [[WJPlayerView alloc] initWithControlView:controlView posterView:posterView];
        [self addSubview:p];
        [p setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [p setFrame:self.bounds];
        _playerView = p;
    }
    [self setBackgroundColor:[UIColor blackColor]];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    if ([_playerView superview] == self) {
        [_playerView setFrame:self.bounds];
    }
}

@end
