//
//  WJPlayerView.m
//  WJPlayer
//
//  Created by Yunhai.Wu on 2018/9/8.
//  Copyright © 2018年 PN. All rights reserved.
//

#import "WJPlayerView.h"
#import "WJPlayer.h"
#import "AbstractAskPlayControlView.h"
#import "WJConfig.h"

@interface WJPlayerView()<WJPlayerDelegate, AskPlayControlViewDelegate>

//媒体数据
@property(nonatomic, strong) id<IWJMedia> media;

//网络询问控制器
@property(nonatomic, weak) AbstractAskPlayControlView *askControlView;

/**
 当前控制视图
 当askControlView == nil 时，currentControlView才不为空有值
 */
@property(nonatomic, strong) UIView<IWJPlayerControlView> *currentControlView;


@end

@implementation WJPlayerView

#pragma mark AskPlayControlViewDelegate
-(void)askPlayControlViewDidContinue:(AbstractAskPlayControlView *)controlView {
    [self replaceControlView:_currentControlView];
    [(WJPlayer*)_player cellNetworkCanPlay];
    [self play];
}

#pragma mark WJPlayerDelegate
-(void)playerDidAskCellNetworkCanPlay:(WJPlayer *)player {
    if (!_askControlView) {
        AbstractAskPlayControlView *v = [self instanceAskPlayControlView];
        if (v) {
            //强引用当前控制视图
            self.currentControlView = _controlView;
            //替换当前控制视图为询问网络控制视图
            [v setAskDelegate:self];
            [self replaceControlView:v];
            _askControlView = v;
        } else {
            [(WJPlayer*)_player cellNetworkCanPlay];
            [self play];
        }
    }
}

-(AbstractAskPlayControlView*)instanceAskPlayControlView {
    NSDictionary *dict = [WJConfig dictionaryForKey:@"WJPlayerKit"];
    NSString *askPlayControlViewClazzName = dict[@"askPlayControlView"];
    if (askPlayControlViewClazzName) {
        Class clazz = NSClassFromString(askPlayControlViewClazzName);
        if (clazz && [clazz isSubclassOfClass:[AbstractAskPlayControlView class]]) {
            return [[clazz alloc] init];
        }
    }
    return nil;
}

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
        [player setDelegate:self];
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
    
    if ([_askControlView superview]) {
        self.currentControlView = nil;
        [_askControlView removeFromSuperview];
        _askControlView = nil;
    }
    
    if ([_controlView superview]) {
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
