//
//  HomePlayerControlView.m
//  WJPlayerKit-example
//
//  Created by ada on 2018/10/19.
//  Copyright © 2018年 PN. All rights reserved.
//

#import "HomePlayerControlView.h"
#import "HomePlayerBottomOperationBar.h"
#import "ReactiveObjC.h"
#import <Masonry/Masonry.h>
#import "TimeStringFormatter.h"

@interface HomePlayerControlView()

@property(nonatomic, weak) HomePlayerBottomOperationBar *bottomBar;

@property(nonatomic, weak) UILabel *labTotalDuration;

@property(nonatomic, weak) NSTimer *timer;

@end

@implementation HomePlayerControlView

-(void)dealloc {
    [self closeTimer];
}

-(void)showBar:(BOOL)animated {
    if ([self isHiddenBar]) {
        [self closeTimer];
        if (animated) {
            [UIView animateWithDuration:0.25f animations:^{
                self.bottomBar.frame = CGRectMake(0, self.bounds.size.height-36.0f, self.bounds.size.width, 36.0f);
            } completion:^(BOOL finished) {
                [self startTimerHideBarAction];
            }];
        } else {
            self.bottomBar.frame = CGRectMake(0, self.bounds.size.height-36.0f, self.bounds.size.width, 36.0f);
            [self startTimerHideBarAction];
        }
    }
}

-(void)hideBar:(BOOL)animated {
    if (![self isHiddenBar]) {
        if (animated) {
            [UIView animateWithDuration:0.25f animations:^{
                self.bottomBar.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, 36.0f);
            }];
        } else {
            self.bottomBar.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, 36.0f);
        }
    }
}

- (BOOL)isHiddenBar {
    return self.bottomBar.frame.origin.y == self.bounds.size.height;
}

- (void)closeTimer {
    if ([_timer isValid]) [_timer invalidate];
    _timer = nil;
}

- (void)startTimerHideBarAction {
    [self closeTimer];
    if (self.player.status == WJPlayerStatusPlaying) {
        @weakify(self)
        _timer = [NSTimer scheduledTimerWithTimeInterval:3 repeats:NO block:^(NSTimer * _Nonnull timer) {
            @strongify(self)
            if (self.player.status == WJPlayerStatusPlaying) [self hideBar:YES];
            [self closeTimer];
        }];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

- (void)singleTapGestureHandler {
    if (self.player.status != WJPlayerStatusUnknown) {
        if ([self isHiddenBar]) {
            [self showBar:YES];
        } else {
            [self hideBar:YES];
        }
    } else {
        [self hideBar:NO];
    }
}

-(void)addPlayerObserver:(NSHashTable<RACDisposable *> *)disposables {
    @weakify(self)
    [disposables addObject:[[(NSObject*)self.player rac_valuesAndChangesForKeyPath:@"status" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew observer:self] subscribeNext:^(RACTwoTuple<id,NSDictionary *> * _Nullable x) {
        @strongify(self)
        WJPlayerStatus status = self.player.status;
        [self refreshPlayStatus:status];
        [self.bottomBar setPlaying:status == WJPlayerStatusPlaying];
        [self.labTotalDuration setHidden:status != WJPlayerStatusUnknown];
        switch (status) {
            case WJPlayerStatusPaused:
                [self showBar:NO];
                break;
            case WJPlayerStatusPlaying:
                [self showBar:NO];
                [self startTimerHideBarAction];
                break;
            case WJPlayerStatusUnknown:
                [self hideBar:NO];
                break;
            case WJPlayerStatusReadyToPlay:
                [self showBar:NO];
                break;
            default:
                break;
        }
    }]];
    
    [disposables addObject:[[(NSObject*)self.player rac_valuesAndChangesForKeyPath:@"muted" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew observer:self] subscribeNext:^(RACTwoTuple<id,NSDictionary *> * _Nullable x) {
        @strongify(self)
        [self.bottomBar setMute:self.player.muted];
    }]];
    [disposables addObject:[[(NSObject*)self.player rac_valuesAndChangesForKeyPath:@"duration" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew observer:self] subscribeNext:^(RACTwoTuple<id,NSDictionary *> * _Nullable x) {
        @strongify(self)
        [self.bottomBar setTotalTime:self.player.duration];
        [self.labTotalDuration setText:[TimeStringFormatter formatTime:self.player.duration]];
    }]];
    [disposables addObject:[[(NSObject*)self.player rac_valuesAndChangesForKeyPath:@"currentPlayTime" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew observer:self] subscribeNext:^(RACTwoTuple<id,NSDictionary *> * _Nullable x) {
        @strongify(self)
        [self.bottomBar setCurrentTime:self.player.currentPlayTime];
    }]];
}

-(void)loadSubviews {
    if (!_bottomBar) {
        HomePlayerBottomOperationBar *bar = [[HomePlayerBottomOperationBar alloc] init];
        [self addSubview:bar];
        [bar setFrame:CGRectMake(0, self.bounds.size.height, self.bounds.size.width, 36.0f)];
        [bar setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin];
        _bottomBar = bar;
        @weakify(self)
        [bar setActionBlock:^(BOOL playOrPause, BOOL mute) {
            @strongify(self)
            [self startTimerHideBarAction];
            if (playOrPause) {
                if ([self.player status] == WJPlayerStatusPlaying) {
                    [self.player pause];
                } else {
                    [self.player play];
                }
            }
            if (mute) {
                [self.player setMuted:!self.player.muted];
            }
        }];
        
        [[[bar slider] rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self.stateIndicatorView setTotalDuration:self.player.duration];
            [self.stateIndicatorView setBeginTime:self.player.currentPlayTime];
            [self.stateIndicatorView setCurrentTime:self.player.duration*bar.slider.value];
        }];
        [[[bar slider] rac_signalForControlEvents:UIControlEventTouchDown] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self closeTimer];
            [self.stateIndicatorView setType:StateIndicatorTypeProgress];
            [self.stateIndicatorView setTotalDuration:self.player.duration];
            [self.stateIndicatorView setBeginTime:self.player.currentPlayTime];
            [self.stateIndicatorView setCurrentTime:self.player.duration*bar.slider.value];
        }];
        [[[bar slider] rac_signalForControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside|UIControlEventTouchCancel] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self.stateIndicatorView setType:StateIndicatorTypeNone];
            int t = self.player.duration*bar.slider.value;
            [self.player seekToTime:t];
            [self startTimerHideBarAction];
        }];
        
        UILabel *lab = [UILabel new];
        [lab setTextAlignment:NSTextAlignmentRight];
        [lab setTextColor:[UIColor whiteColor]];
        [lab setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
        [self addSubview:lab];
        _labTotalDuration = lab;
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(16);
            make.width.mas_greaterThanOrEqualTo(20);
            make.right.equalTo(self.mas_right).with.offset(-8);
            make.bottom.equalTo(self.mas_bottom).with.offset(-8);
        }];
        
        self.enableSingleTapGesture = YES;
        self.enableDoubleTapGesture = YES;
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
