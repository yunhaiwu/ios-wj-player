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

@property(nonatomic, weak) UILabel *labTime;

@property(nonatomic, weak) NSTimer *timer;

@end

@implementation HomePlayerControlView

-(void)addPlayerObserver:(NSHashTable<RACDisposable *> *)disposables {
    @weakify(self)
    [disposables addObject:[[(NSObject*)self.player rac_valuesAndChangesForKeyPath:@"status" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew observer:self] subscribeNext:^(RACTwoTuple<id,NSDictionary *> * _Nullable x) {
        @strongify(self)
        WJPlayerStatus status = self.player.status;
        [self refreshPlayStatus:status];
        [self.bottomBar setPlaying:status == WJPlayerStatusPlaying];
        [self.labTime setHidden:status != WJPlayerStatusUnknown];
    }]];
    
    [disposables addObject:[[(NSObject*)self.player rac_valuesAndChangesForKeyPath:@"muted" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew observer:self] subscribeNext:^(RACTwoTuple<id,NSDictionary *> * _Nullable x) {
        @strongify(self)
        [self.bottomBar setMute:self.player.muted];
    }]];
    [disposables addObject:[[(NSObject*)self.player rac_valuesAndChangesForKeyPath:@"duration" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew observer:self] subscribeNext:^(RACTwoTuple<id,NSDictionary *> * _Nullable x) {
        @strongify(self)
        if (self.player.duration > 0) {
            [self.bottomBar setTotalTime:self.player.duration];
            [self.labTime setText:[TimeStringFormatter formatTime:self.player.duration]];
        }
    }]];
    [disposables addObject:[[(NSObject*)self.player rac_valuesAndChangesForKeyPath:@"mediaData" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial observer:self] subscribeNext:^(RACTwoTuple<id,NSDictionary *> * _Nullable x) {
        @strongify(self)
        if ([self.player.mediaData duration] > 0) {
            [self.bottomBar setTotalTime:[self.player.mediaData duration]];
            [self.labTime setText:[TimeStringFormatter formatTime:[self.player.mediaData duration]]];
        }
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
        self.bottomOperationBar = bar;
        _bottomBar = bar;
        @weakify(self)
        [bar setActionBlock:^(BOOL playOrPause, BOOL mute) {
            @strongify(self)
            [self startHideBarTimer];
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
        
        self.slider = [bar slider];
        
        UILabel *lab = [UILabel new];
        [lab setTextAlignment:NSTextAlignmentRight];
        [lab setTextColor:[UIColor whiteColor]];
        [lab setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
        [self addSubview:lab];
        _labTime = lab;
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
