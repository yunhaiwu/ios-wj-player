//
//  WJPlayerView.m
//  WJPlayer
//
//  Created by Yunhai.Wu on 2018/9/8.
//  Copyright © 2018年 PN. All rights reserved.
//

#import "WJPlayerView.h"
#import "WJPlayer.h"

@interface WJPlayerView()

@property(nonatomic, strong) id<IWJMedia> media;

@end

@implementation WJPlayerView


#pragma mark init、layout

- (void)layoutSubviews {
    [super layoutSubviews];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [_player setFrame:self.bounds];
    [_posterView setFrame:self.bounds];
    [_controlView setFrame:self.bounds];
    [CATransaction commit];
}

- (void)loadSubviews {
    if (!_player) {
        WJPlayer *player = [[WJPlayer alloc] init];
        if ([[self subviews] count] > 0) {
            [self insertSubview:player atIndex:1];
        } else {
            [self addSubview:player];
        }
        _player = player;
        [_controlView setPlayer:_player];
    }
    [self setBackgroundColor:[UIColor blackColor]];
}

-(instancetype)initWithControlView:(UIView<IWJPlayerControlView> *)controlView {
    self = [super init];
    if (self) {
        [self loadSubviews];
        if (controlView) [self replaceControlView:controlView];
    }
    return self;
}

-(instancetype)initWithControlView:(UIView<IWJPlayerControlView> *)controlView posterView:(UIView<IWJPlayerPosterView> *)posterView {
    self = [super init];
    if (self) {
        [self loadSubviews];
        if (posterView) [self replacePosterView:posterView];
        if (controlView) [self replaceControlView:controlView];
    }
    return self;
}

#pragma mark features

- (void)replaceControlView:(UIView<IWJPlayerControlView> *)controlView {
    if (_controlView) {
        [_controlView removeFromSuperview];
    }
    if (controlView) {
        [self addSubview:controlView];
        [controlView setFrame:self.bounds];
        [controlView setPlayer:_player];
        _controlView = controlView;
    }
}

-(void)replacePosterView:(UIView<IWJPlayerPosterView> *)posterView {
    if (_posterView) {
        [_posterView removeFromSuperview];
    }
    if (posterView) {
        [self insertSubview:posterView atIndex:0];
        [posterView setFrame:self.bounds];
        [posterView setMedia:_media];
        _posterView = posterView;
    }
}

-(void)setMedia:(id<IWJMedia>)media autoPlay:(BOOL)autoPlay {
    if (_media == media) return;
    _media = media;
    [self.posterView setMedia:media];
    [self.player setMedia:media];
    if (autoPlay) [self play];
}

-(void)play {
    [self.player play];
}

-(void)pause {
    [self.player pause];
}

@end
