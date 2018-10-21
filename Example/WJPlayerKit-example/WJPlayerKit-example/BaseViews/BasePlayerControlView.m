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

@property(nonatomic, strong) NSHashTable<RACDisposable *> *playerDisposables;

@property(nonatomic, strong) NSHashTable<RACDisposable *> *sliderDisposables;

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

@property(nonatomic, weak) NSTimer *hideBarTimer;

@end

@implementation BasePlayerControlView

-(void)cancelHideBarTimer {
    if ([_hideBarTimer isValid]) {
        [_hideBarTimer invalidate];
    }
    _hideBarTimer = nil;
}

-(void)timerExec:(NSTimer*)timer {
    if (self.player.status == WJPlayerStatusPlaying) [self hideOperatonBar:YES];
    [self cancelHideBarTimer];
}

-(void)startHideBarTimer {
    if (self.bottomOperationBar || self.topOperationBar) {
        [self cancelHideBarTimer];
        if (self.player.status == WJPlayerStatusPlaying) {
            _hideBarTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerExec:) userInfo:nil repeats:NO];
            [[NSRunLoop currentRunLoop] addTimer:_hideBarTimer forMode:NSRunLoopCommonModes];
        }
    }
}

-(void)showOperationBar:(BOOL)animated {
    if ([self isOperationBarHidden] && (self.bottomOperationBar || self.topOperationBar)) {
        [self cancelHideBarTimer];
        if (animated) {
            [UIView animateWithDuration:0.25f animations:^{
                self.bottomOperationBar.frame = CGRectMake(0, self.bounds.size.height-self.bottomOperationBar.bounds.size.height, self.bounds.size.width, self.bottomOperationBar.bounds.size.height);
                self.topOperationBar.frame = CGRectMake(0, 0, self.bounds.size.width, self.topOperationBar.bounds.size.height);
            } completion:^(BOOL finished) {
                [self startHideBarTimer];
            }];
        } else {
            self.bottomOperationBar.frame = CGRectMake(0, self.bounds.size.height-self.bottomOperationBar.bounds.size.height, self.bounds.size.width, self.bottomOperationBar.bounds.size.height);
            self.topOperationBar.frame = CGRectMake(0, 0, self.bounds.size.width, self.topOperationBar.bounds.size.height);
            [self startHideBarTimer];
        }
    }
}

-(void)hideOperatonBar:(BOOL)animated {
    if (![self isOperationBarHidden] && (self.bottomOperationBar || self.topOperationBar)) {
        if (animated) {
            [UIView animateWithDuration:0.25f animations:^{
                self.bottomOperationBar.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, self.bottomOperationBar.bounds.size.height);
                self.topOperationBar.frame = CGRectMake(0, -self.topOperationBar.frame.size.height, self.bounds.size.width, self.topOperationBar.frame.size.height);
            }];
        } else {
            self.bottomOperationBar.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, self.bottomOperationBar.bounds.size.height);
            self.topOperationBar.frame = CGRectMake(0, -self.topOperationBar.bounds.size.height, self.bounds.size.width, self.topOperationBar.bounds.size.height);
        }
    }
}

-(void)toggleOperationBar:(BOOL)animated {
    if ([self isOperationBarHidden]) {
        [self showOperationBar:animated];
    } else {
        [self hideOperatonBar:animated];
    }
}

- (BOOL)isOperationBarHidden {
    if (self.bottomOperationBar) {
        return self.bottomOperationBar.frame.origin.y == self.bounds.size.height;
    }
    if (self.topOperationBar) {
        return self.topOperationBar.frame.origin.y == -self.topOperationBar.frame.size.height;
    }
    return NO;
}

- (void)singleTapGestureHandler {
    if (self.player.status == WJPlayerStatusUnknown) {
        [self hideOperatonBar:NO];
    } else {
        [self toggleOperationBar:YES];
    }
}

-(void)doubleTapGestureHandler {
    if ([self.player status] == WJPlayerStatusPlaying) {
        [self.player pause];
        //添加动画
    } else {
        [self.player play];
        //添加动画
    }
}

#pragma mark UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return ![touch.view isKindOfClass:[UISlider class]];
}

- (void)handleDoubleGesture:(UITapGestureRecognizer*)gesture {
    [self doubleTapGestureHandler];
}

- (void)handleSingleGesture:(UITapGestureRecognizer*)gesture {
    [self singleTapGestureHandler];
}

- (void)handlePanGesture:(UIPanGestureRecognizer*)gesture {
    [self.panGestureHandler handleGesture:gesture view:self player:self.player];
}

-(void)refreshPlayStatus:(WJPlayerStatus)status {
    if (status == WJPlayerStatusLoading) {
        [_loadingView startAnimating];
    } else {
        [_loadingView stopAnimating];
    }
    if (_btnPlay) {
        [_btnPlay setHidden:(status != WJPlayerStatusUnknown && status != WJPlayerStatusPaused)];
    }
    if (_replayView) {
        if (status == WJPlayerStatusCompleted) {
            [_replayView setHidden:NO];
            [self bringSubviewToFront:self.replayView];
            for (UIGestureRecognizer *gesture in self.gestureRecognizers) {
                [gesture setEnabled:NO];
            }
        } else {
            [_replayView setHidden:YES];
            for (UIGestureRecognizer *gesture in self.gestureRecognizers) {
                [gesture setEnabled:YES];
            }
        }
    }
    switch (status) {
        case WJPlayerStatusPaused:
            [self showOperationBar:NO];
            break;
        case WJPlayerStatusPlaying:
            [self showOperationBar:NO];
            [self startHideBarTimer];
            break;
        case WJPlayerStatusUnknown:
            [self hideOperatonBar:NO];
            break;
        case WJPlayerStatusReadyToPlay:
            [self showOperationBar:NO];
            break;
        default:
            break;
    }    
}

-(void)removePlayerObserver {
    NSArray *objects = [_playerDisposables allObjects];
    if ([objects count] > 0) {
        [objects makeObjectsPerformSelector:@selector(dispose)];
        [_playerDisposables removeAllObjects];
    }
}

-(void)removeSliderEventsHandler {
    NSArray *objects = [_sliderDisposables allObjects];
    if ([objects count] > 0) {
        [objects makeObjectsPerformSelector:@selector(dispose)];
        [_sliderDisposables removeAllObjects];
    }
}

-(void)addPlayerObserver:(NSHashTable<RACDisposable *> *)disposables {}


-(void)addSliderEventsHandler:(NSHashTable<RACDisposable *> *)disposables {
    @weakify(self)
    [[_slider rac_signalForControlEvents:UIControlEventTouchDown] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self cancelHideBarTimer];
        PlayerGestureData *data = [PlayerGestureData getCacheGestureData];
        [data reset];
        [data setFuncType:PanGestureFuncTypeProgress];
        [data setTotalDuration:self.player.duration];
        [data setBeginTime:self.player.currentPlayTime];
        [data setCurrentTime:self.player.duration*self.slider.value];
        [self.gestureIndicatorView refreshGestureData:data];
    }];
    
    [[_slider rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [[PlayerGestureData getCacheGestureData] setCurrentTime:self.player.duration*self.slider.value];
        [self.gestureIndicatorView refreshGestureData:[PlayerGestureData getCacheGestureData]];
    }];
    
    [[_slider rac_signalForControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside|UIControlEventTouchCancel] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [[PlayerGestureData getCacheGestureData] reset];
        [self.gestureIndicatorView refreshGestureData:[PlayerGestureData getCacheGestureData]];
        int t = self.player.duration*self.slider.value;
        [self.player seekToTime:t];
        [self startHideBarTimer];
    }];
}

-(void)setPlayer:(id<IWJPlayer>)player {
    if (_player == player) return;
    [self removePlayerObserver];
    _player = player;
    if (_player) [self addPlayerObserver:_playerDisposables];
}

-(void)setSlider:(UISlider *)slider {
    if (_slider == slider) return;
    [self removeSliderEventsHandler];
    _slider = slider;
    if (_slider) [self addSliderEventsHandler:_sliderDisposables];
}

-(PlayerGestureIndicatorView *)gestureIndicatorView {
    if (!_gestureIndicatorView) {
        PlayerGestureIndicatorView *v = [[PlayerGestureIndicatorView alloc] initWithFrame:self.bounds];
        [self addSubview:v];
        [v setHidden:YES];
        _gestureIndicatorView = v;
    }
    [self bringSubviewToFront:_gestureIndicatorView];
    return _gestureIndicatorView;
}

#pragma mark Init、LayoutSubviews
-(void)layoutSubviews {
    [super layoutSubviews];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [_loadingView setFrame:CGRectMake((self.bounds.size.width-24.0f)/2.0f, (self.bounds.size.height-24.0f)/2.0f, 24.0f, 24.0f)];
    if (_btnPlay) [_btnPlay setFrame:CGRectMake((self.bounds.size.width-40)/2.0f, (self.bounds.size.height-40)/2.0f, 40, 40)];
    if (_replayView) [_replayView setFrame:self.bounds];
    if (_gestureIndicatorView) [_gestureIndicatorView setFrame:self.bounds];
    [CATransaction commit];
}


-(void)performInitialize {
    if (!_playerDisposables) {
        self.playerDisposables = [[NSHashTable alloc] initWithOptions:NSPointerFunctionsWeakMemory capacity:0];
    }
    if (!_slider) {
        self.sliderDisposables = [[NSHashTable alloc] initWithOptions:NSPointerFunctionsWeakMemory capacity:0];
    }
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
                    [self.panGestureHandler setCallbackBlock:^(PlayerGestureData *gesture, BOOL isEnd) {
                        @strongify(self)
                        [self.gestureIndicatorView refreshGestureData:gesture];
                        if (isEnd && [gesture funcType] == PanGestureFuncTypeProgress) {
                            [self.player seekToTime:gesture.currentTime];
                            [self showOperationBar:NO];
                        }
                    }];
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
