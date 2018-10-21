//
//  CanFullScreenVideoPlayView.m
//  WJPlayerKit-example
//
//  Created by ada on 2018/10/21.
//  Copyright © 2018年 PN. All rights reserved.
//

#import "CanFullScreenVideoPlayView.h"
#import "BottomBarPlayerControlView.h"
#import "FullScreenPlayerControlView.h"
#import "GaussianBlurPosterView.h"

#define APPLICATION_KEY_WINDOW  [[UIApplication sharedApplication] keyWindow]

@interface CanFullScreenVideoPlayView()

@property(nonatomic, assign) BOOL currentHasFullScreen;

@property(nonatomic, strong) BottomBarPlayerControlView *controlView;

@end

@implementation CanFullScreenVideoPlayView

-(void)fullScreenAction {
    if (!_currentHasFullScreen) {
        _currentHasFullScreen = YES;
        CGRect f = [self convertRect:self.bounds toView:APPLICATION_KEY_WINDOW];
        WJPlayerView *pv = _playerView;
        [_playerView removeFromSuperview];
        [APPLICATION_KEY_WINDOW addSubview:pv];
        [pv setFrame:f];
        [UIView animateWithDuration:0.35f animations:^{
            pv.transform = CGAffineTransformMakeRotation(M_PI_2);
            [pv setBounds:CGRectMake(0, 0, APPLICATION_KEY_WINDOW.bounds.size.height, APPLICATION_KEY_WINDOW.bounds.size.width)];
            [pv setCenter:CGPointMake(CGRectGetMidX(APPLICATION_KEY_WINDOW.bounds), CGRectGetMidY(APPLICATION_KEY_WINDOW.bounds))];
        } completion:^(BOOL finished) {
            FullScreenPlayerControlView *cv = [[FullScreenPlayerControlView alloc] init];
            @weakify(self)
            [cv setActionBlock:^(BOOL transform) {
                @strongify(self)
                [self performSelectorOnMainThread:@selector(quitFullScreenAction) withObject:nil waitUntilDone:NO];
            }];
            [pv replaceControlView:cv];
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
        }];
    }
}

-(void)quitFullScreenAction {
    if (_currentHasFullScreen) {
        _currentHasFullScreen = NO;
        CGRect f = [self convertRect:self.bounds toView:APPLICATION_KEY_WINDOW];
        //退出全屏
        WJPlayerView *pv = _playerView;
        [UIView animateWithDuration:0.35f animations:^{
            pv.transform = CGAffineTransformIdentity;
            [pv setFrame:f];
            [pv setCenter:CGPointMake(CGRectGetMidX(f), CGRectGetMidY(f))];
        } completion:^(BOOL finished) {
            [pv removeFromSuperview];
            [self addSubview:pv];
            [pv replaceControlView:self.controlView];
            [self.controlView showOperationBar:NO];
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
        }];
    }
}

- (void)loadSubviews {
    if (!_playerView) {
        BottomBarPlayerControlView *controlView = [[BottomBarPlayerControlView alloc] init];
        self.controlView = controlView;
        @weakify(self)
        [controlView setActionBlock:^(BOOL transform) {
            @strongify(self)
            [self fullScreenAction];
        }];
        GaussianBlurPosterView *posterView = [[GaussianBlurPosterView alloc] init];
        WJPlayerView *v = [[WJPlayerView alloc] initWithControlView:controlView posterView:posterView];
        [self addSubview:v];
        [v setFrame:self.bounds];
        [v setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        _playerView = v;
    }
    [self setBackgroundColor:[UIColor blackColor]];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    if ([_playerView superview] == self) {
        [_playerView setFrame:self.bounds];
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

@end
