//
//  SimplePlayerControlView.m
//  WJPlayerKit-example
//
//  Created by ada on 2018/10/21.
//  Copyright © 2018年 PN. All rights reserved.
//

#import "SimplePlayerControlView.h"
#import "ReactiveObjC.h"
#import <Masonry/Masonry.h>
#import "TimeStringFormatter.h"

@interface SimplePlayerControlView()

@property(nonatomic, copy) SimplePlayerControlViewActionBlock copyActionBlock;

@property(nonatomic, weak) UILabel *labTime;

@property(nonatomic, weak) UIProgressView *progressView;

@end

@implementation SimplePlayerControlView

-(void)setActionBlock:(SimplePlayerControlViewActionBlock)actionBlock {
    self.copyActionBlock = actionBlock;
}

-(void)singleTapGestureHandler {
    if (NULL != self.copyActionBlock) self.copyActionBlock(YES);
}

- (void)loadSubviews {
    if (!_labTime) {
        //时间
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
        
        UIProgressView *progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        [progress setTrackTintColor:[UIColor clearColor]];
        [progress setProgressTintColor:[UIColor grayColor]];
        [self addSubview:progress];
        _progressView = progress;
        [progress mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom);
            make.height.mas_equalTo(2);
        }];
        
        self.enableSingleTapGesture = YES;
    }
}

-(void)refreshTimeUI {
    if ([self.player duration] == 0) {
        [self.labTime setText:[TimeStringFormatter formatTime:[self.player.mediaData mediaDuration]]];
    } else {
        if ([self.player currentPlayTime] > 0) {
            [self.labTime setText:[TimeStringFormatter formatTime:self.player.duration-self.player.currentPlayTime]];
        } else {
            [self.labTime setText:[TimeStringFormatter formatTime:self.player.duration]];
        }
    }
}

- (void)addPlayerObserver:(NSHashTable<RACDisposable *> *)disposables {
    @weakify(self)
    [disposables addObject:[[(NSObject*)self.player rac_valuesAndChangesForKeyPath:@"duration" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial observer:self] subscribeNext:^(RACTwoTuple<id,NSDictionary *> * _Nullable x) {
        @strongify(self)
        [self refreshTimeUI];
    }]];
    [disposables addObject:[[(NSObject*)self.player rac_valuesAndChangesForKeyPath:@"currentPlayTime" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial observer:self] subscribeNext:^(RACTwoTuple<id,NSDictionary *> * _Nullable x) {
        @strongify(self)
        [self refreshTimeUI];
    }]];
    [disposables addObject:[[(NSObject*)self.player rac_valuesAndChangesForKeyPath:@"mediaData" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial observer:self] subscribeNext:^(RACTwoTuple<id,NSDictionary *> * _Nullable x) {
        @strongify(self)
        [self refreshTimeUI];
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
