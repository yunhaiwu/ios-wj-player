//
//  BottomBarPlayerControlView.m
//  WJPlayerKit-example
//
//  Created by ada on 2018/10/21.
//  Copyright © 2018年 PN. All rights reserved.
//

#import "BottomBarPlayerControlView.h"
#import "PlayerBottomOperationBar.h"

@interface BottomBarPlayerControlView()

@property(nonatomic, weak) PlayerBottomOperationBar *bottomBar;

@property(nonatomic, copy) BottomBarPlayerControlViewActionBlock copyActionBlock;

@end

@implementation BottomBarPlayerControlView

-(void)setActionBlock:(BottomBarPlayerControlViewActionBlock)actionBlock {
    self.copyActionBlock = actionBlock;
}

- (void)loadSubviews {
    if (!_bottomBar) {
        PlayerBottomOperationBar *bottomBar = [[PlayerBottomOperationBar alloc] initWithFrame:CGRectMake(0, self.bounds.size.height, self.bounds.size.width, 44.0f)];
        [self addSubview:bottomBar];
        [bottomBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin];
        _bottomBar = bottomBar;
        self.bottomOperationBar = bottomBar;
        @weakify(self)
        [bottomBar setActionBlock:^(BOOL playOrPause, BOOL transform) {
            @strongify(self)
            if (playOrPause) {
                if ([self.player status] == WJPlayerStatusPlaying) {
                    [self.player pause];
                } else {
                    [self.player play];
                }
            }
            if (transform) if (NULL != self.copyActionBlock) self.copyActionBlock(YES);
        }];
        
        [[[bottomBar slider] rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self.stateIndicatorView setCurrentTime:self.player.duration*self.bottomBar.slider.value];
        }];
        [[[bottomBar slider] rac_signalForControlEvents:UIControlEventTouchDown] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self cancelHideBarTimer];
            [self.stateIndicatorView setType:StateIndicatorTypeProgress];
            [self.stateIndicatorView setTotalDuration:self.player.duration];
            [self.stateIndicatorView setBeginTime:self.player.currentPlayTime];
            [self.stateIndicatorView setCurrentTime:self.player.duration*self.bottomBar.slider.value];
        }];
        [[[bottomBar slider] rac_signalForControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside|UIControlEventTouchCancel] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self.stateIndicatorView setType:StateIndicatorTypeNone];
            int t = self.player.duration*self.bottomBar.slider.value;
            [self.player seekToTime:t];
            [self startHideBarTimer];
        }];
        
//        self.enablePanGesture = YES;
        self.enableDoubleTapGesture = YES;
        self.enableSingleTapGesture = YES;
    }
}

-(void)addPlayerObserver:(NSHashTable<RACDisposable *> *)disposables {
    @weakify(self)
    [disposables addObject:[[(NSObject*)self.player rac_valuesAndChangesForKeyPath:@"status" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew observer:self] subscribeNext:^(RACTwoTuple<id,NSDictionary *> * _Nullable x) {
        @strongify(self)
        WJPlayerStatus status = self.player.status;
        [self refreshPlayStatus:status];
        [self.bottomBar setPlaying:status == WJPlayerStatusPlaying];
    }]];
    [disposables addObject:[[(NSObject*)self.player rac_valuesAndChangesForKeyPath:@"duration" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew observer:self] subscribeNext:^(RACTwoTuple<id,NSDictionary *> * _Nullable x) {
        @strongify(self)
        if (self.player.duration > 0) {
            [self.bottomBar setTotalTime:self.player.duration];
        }
    }]];
    [disposables addObject:[[(NSObject*)self.player rac_valuesAndChangesForKeyPath:@"mediaData" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial observer:self] subscribeNext:^(RACTwoTuple<id,NSDictionary *> * _Nullable x) {
        @strongify(self)
        if ([self.player.mediaData duration] > 0) {
            [self.bottomBar setTotalTime:[self.player.mediaData duration]];
        }
    }]];
    [disposables addObject:[[(NSObject*)self.player rac_valuesAndChangesForKeyPath:@"currentPlayTime" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew observer:self] subscribeNext:^(RACTwoTuple<id,NSDictionary *> * _Nullable x) {
        @strongify(self)
        [self.bottomBar setCurrentTime:self.player.currentPlayTime];
    }]];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self loadSubviews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self loadSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadSubviews];
    }
    return self;
}

@end
