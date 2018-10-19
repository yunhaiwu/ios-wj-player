//
//  BasePlayerControlView.m
//  WJPlayerKit-example
//
//  Created by ada on 2018/10/18.
//  Copyright © 2018年 PN. All rights reserved.
//

#import "BasePlayerControlView.h"
#import "PlayerPanGestureHandler.h"
#import "PlayerLoadingView.h"
#import "PlayerReplayView.h"

@interface BasePlayerControlView ()<UIGestureRecognizerDelegate>

@property(nonatomic, strong) NSHashTable<RACDisposable *> *disposables;

//loading 视图
@property(nonatomic, weak) PlayerLoadingView *loadingView;

//播放按钮
@property(nonatomic, weak) UIButton *btnPlay;

//重播视图
@property(nonatomic, weak) PlayerReplayView *replayView;

//单击手势、双击手势
@property(nonatomic, weak) UITapGestureRecognizer *singleTapGesture, *doubleTapGesture;

@property(nonatomic, weak) UIPanGestureRecognizer *panGesture;

/**
 托转手势处理程序
 */
@property(nonatomic, strong) PlayerPanGestureHandler *panGestureHandler;

@end

@implementation BasePlayerControlView

#pragma mark UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return ![touch.view isKindOfClass:[UISlider class]];
}

-(void)singleTapGestureHandler {}

-(void)doubleTapGestureHandler {
    if ([self.player status] == WJPlayerStatusPlaying) {
        [self.player pause];
        //添加动画
    } else {
        [self.player play];
        //添加动画
    }
}

- (void)handleDoubleGesture:(UITapGestureRecognizer*)gesture {
    [self doubleTapGestureHandler];
}

- (void)handleSingleGesture:(UITapGestureRecognizer*)gesture {
    [self singleTapGestureHandler];
}

- (void)handlePanGesture:(UIPanGestureRecognizer*)gesture {
    [self.panGestureHandler handleGesture:gesture view:self player:self.player isFullScreen:self.isFullScreen];
}

-(void)refreshPlayStatus:(WJPlayerStatus)status {
    if (status == WJPlayerStatusLoading) {
        [_loadingView startAnimating];
    } else {
        [_loadingView stopAnimating];
    }
    if (_btnPlay) [_btnPlay setHidden:(status != WJPlayerStatusUnknown && status != WJPlayerStatusPaused)];
    if (_replayView) {
        if (status == WJPlayerStatusCompleted) {
            [_replayView setHidden:NO];
            [self bringSubviewToFront:self.replayView];
        } else {
            [_replayView setHidden:YES];
        }
    }
}

-(void)removePlayerObserver {
    NSArray *objects = [_disposables allObjects];
    if ([objects count] > 0) {
        [objects makeObjectsPerformSelector:@selector(dispose)];
        [_disposables removeAllObjects];
    }
}

-(void)addPlayerObserver:(NSHashTable<RACDisposable *> *)disposables {}


-(void)setPlayer:(id<IWJPlayer>)player {
    if (_player == player) return;
    [self removePlayerObserver];
    _player = player;
    if (_player) [self addPlayerObserver:_disposables];
}

-(PlayerStateIndicatorView *)stateIndicatorView {
    if (!_stateIndicatorView) {
        PlayerStateIndicatorView *v = [[PlayerStateIndicatorView alloc] initWithFrame:self.bounds];
        [self addSubview:v];
        [v setHidden:YES];
        _stateIndicatorView = v;
    }
    [self bringSubviewToFront:_stateIndicatorView];
    return _stateIndicatorView;
}

#pragma mark Init、LayoutSubviews
-(void)layoutSubviews {
    [super layoutSubviews];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [_loadingView setFrame:CGRectMake((self.bounds.size.width-24.0f)/2.0f, (self.bounds.size.height-24.0f)/2.0f, 24.0f, 24.0f)];
    if (_btnPlay) [_btnPlay setFrame:CGRectMake((self.bounds.size.width-40)/2.0f, (self.bounds.size.height-40)/2.0f, 40, 40)];
    if (_replayView) [_replayView setFrame:self.bounds];
    if (_stateIndicatorView) [_stateIndicatorView setFrame:self.bounds];
    [CATransaction commit];
}


-(void)performInitialize {
    if (!_disposables) self.disposables = [[NSHashTable alloc] initWithOptions:NSPointerFunctionsWeakMemory capacity:0];
    if (!_loadingView) {
        PlayerLoadingView *v = [[PlayerLoadingView alloc] init];
        [self addSubview:v];
        _loadingView = v;
        
        self.enableBtnPlay = YES;
        self.enableReplyView = YES;
        
        //是否启用重播视图
        @weakify(self)
        [[self rac_valuesAndChangesForKeyPath:@"enableReplyView" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial observer:self] subscribeNext:^(RACTwoTuple<id,NSDictionary *> * _Nullable x) {
            @strongify(self)
            if (self.enableReplyView) {
                if (!self.replayView) {
                    PlayerReplayView *replayView = [[PlayerReplayView alloc] initWithFrame:self.bounds];
                    [self addSubview:replayView];
                    self.replayView = replayView;
                    [replayView setHidden:YES];
                    @weakify(self)
                    [replayView setActionBlock:^{
                        @strongify(self)
                        [[self player] play];
                    }];
                }
            } else {
                if (self.replayView) [self.replayView removeFromSuperview];
            }
        }];
        
        //是否启用播放按钮
        [[self rac_valuesAndChangesForKeyPath:@"enableBtnPlay" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial observer:self] subscribeNext:^(RACTwoTuple<id,NSDictionary *> * _Nullable x) {
            @strongify(self)
            if (self.enableBtnPlay) {
                if (!self.btnPlay) {
                    UIButton *play = [UIButton buttonWithType:UIButtonTypeCustom];
                    [play setImage:[UIImage imageNamed:@"player-play"] forState:UIControlStateNormal];
                    [self addSubview:play];
                    self.btnPlay = play;
                    [self.btnPlay setFrame:CGRectMake((self.bounds.size.width-40)/2.0f, (self.bounds.size.height-40)/2.0f, 40, 40)];
                    @weakify(self)
                    [[play rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                        @strongify(self)
                        [[self player] play];
                    }];
                }
            } else {
                if (self.btnPlay) [self.btnPlay removeFromSuperview];
            }
        }];
        
        //观察单击手势
        [[self rac_valuesAndChangesForKeyPath:@"enableSingleTapGesture" options:NSKeyValueObservingOptionNew observer:self] subscribeNext:^(RACTwoTuple<id,NSDictionary *> * _Nullable x) {
            @strongify(self)
            if (self.enableSingleTapGesture) {
                if (!self.singleTapGesture) {
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleGesture:)];
                    tap.delaysTouchesBegan = YES;
                    [tap setDelegate:self];
                    [self addGestureRecognizer:tap];
                    self.singleTapGesture = tap;
                    if (self.doubleTapGesture) [self.singleTapGesture requireGestureRecognizerToFail:self.doubleTapGesture];
                }
            } else {
                if (self.singleTapGesture) {
                    [self removeGestureRecognizer:self.singleTapGesture];
                    self.singleTapGesture = nil;
                }
            }
        }];
        
        //观察双击手势
        [[self rac_valuesAndChangesForKeyPath:@"enableDoubleTapGesture" options:NSKeyValueObservingOptionNew observer:self] subscribeNext:^(RACTwoTuple<id,NSDictionary *> * _Nullable x) {
            @strongify(self)
            if (self.enableDoubleTapGesture) {
                if (!self.doubleTapGesture) {
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleGesture:)];
                    [tap setNumberOfTapsRequired:2];
                    [tap setDelegate:self];
                    [self addGestureRecognizer:tap];
                    self.doubleTapGesture = tap;
                    if (self.singleTapGesture) [self.singleTapGesture requireGestureRecognizerToFail:self.doubleTapGesture];
                }
            } else {
                if (self.doubleTapGesture) {
                    [self removeGestureRecognizer:self.doubleTapGesture];
                    self.doubleTapGesture = nil;
                }
            }
        }];
        
        //观察拖拽手势
        [[self rac_valuesAndChangesForKeyPath:@"enablePanGesture" options:NSKeyValueObservingOptionNew observer:self] subscribeNext:^(RACTwoTuple<id,NSDictionary *> * _Nullable x) {
            @strongify(self)
            if (self.enablePanGesture) {
                if (!self.panGesture) {
                    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
                    [pan setDelegate:self];
                    [self addGestureRecognizer:pan];
                    self.panGesture = pan;
                    self.panGestureHandler = [[PlayerPanGestureHandler alloc] init];
                    @weakify(self)
//                    [self.panGestureHandler setCallbackBlock:^(StateIndicatorType type, BOOL seek, int timeValue, BOOL brightness, float brightnessValue, BOOL progress, int progressValue) {
//                        @strongify(self)
//                        [self.stateIndicatorView setType:type];
//                        if (seek) [self.player seekToTime:timeValue];
//                        if (brightness) [self.stateIndicatorView setBrightness:brightnessValue];
//                        if (progress) [self.stateIndicatorView setCurrentTime:progressValue];
//                    }];
                }
            } else {
                if (self.panGesture) {
                    [self removeGestureRecognizer:self.panGesture];
                    self.panGesture = nil;
                    self.panGestureHandler = nil;
                }
            }
        }];
    }
    [self setClipsToBounds:YES];
    [self setBackgroundColor:[UIColor clearColor]];
}

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

@end
