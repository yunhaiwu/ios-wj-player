//
//  HomePlayerBottomOperationBar.m
//  WJPlayerKit-example
//
//  Created by ada on 2018/10/19.
//  Copyright © 2018年 PN. All rights reserved.
//

#import "HomePlayerBottomOperationBar.h"
#import <Masonry/Masonry.h>
#import "TimeStringFormatter.h"

@interface HomePlayerBottomOperationBar()

@property(nonatomic, copy) HomePlayerBottomOperationBarActionBlock copyActionBlock;

@property(nonatomic, weak) CAGradientLayer *gradientLayer;

@property(nonatomic, weak) UIButton *btnMuted,*btnPlayOrPause;

@property (nonatomic, strong) UILabel *labCurrentTime;//当前时间

@property (nonatomic, strong) UILabel *labTotalTime;//总时间

@end

@implementation HomePlayerBottomOperationBar

-(void)setActionBlock:(HomePlayerBottomOperationBarActionBlock)actionBlock {
    self.copyActionBlock = actionBlock;
}

-(void)loadSubviews {
    if (!_gradientLayer) {
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = self.bounds;
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(0, 1);
        gradientLayer.colors = @[(__bridge id)[[UIColor blackColor] colorWithAlphaComponent:0].CGColor,
                                 (__bridge id)[[UIColor blackColor] colorWithAlphaComponent:0.5f].CGColor];
        gradientLayer.locations = @[@(0.0f), @(1.0f)];
        [self.layer addSublayer:gradientLayer];
        _gradientLayer = gradientLayer;
        
        @weakify(self)
        UIButton *play = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:play];
        self.btnPlayOrPause = play;
        [[play rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            self.copyActionBlock(YES, NO);
        }];
        [play mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 30));
            make.left.equalTo(self.mas_left).offset(7);
            make.bottom.equalTo(self.mas_bottom).offset(-3);
        }];
        
        UIButton *muted = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:muted];
        _btnMuted = muted;
        [[muted rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            self.copyActionBlock(NO, YES);
        }];
        [muted mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(34, 30));
            make.right.equalTo(self.mas_right).offset(0);
            make.bottom.equalTo(self.mas_bottom).offset(-3);
        }];
        
        UILabel *currentTime = [UILabel new];
        currentTime.textAlignment = NSTextAlignmentCenter;
        currentTime.textColor = [UIColor whiteColor];
        currentTime.font = [UIFont fontWithName:@"HelveticaNeue" size:10];
        [self addSubview:currentTime];
        _labCurrentTime = currentTime;
        [currentTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_greaterThanOrEqualTo(10);
            make.height.mas_equalTo(30);
            make.left.equalTo(self.btnPlayOrPause.mas_right).offset(0);
            make.bottom.equalTo(self.mas_bottom).offset(-3);
        }];
        
        UILabel *totalTime = [UILabel new];
        totalTime.textAlignment = NSTextAlignmentCenter;
        totalTime.textColor = [UIColor whiteColor];
        totalTime.font = [UIFont fontWithName:@"HelveticaNeue" size:10];
        [self addSubview:totalTime];
        _labTotalTime = totalTime;
        [totalTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_greaterThanOrEqualTo(10).priorityHigh();
            make.height.mas_equalTo(30);
            make.right.equalTo(self.btnMuted.mas_left).offset(0);
            make.bottom.equalTo(self.mas_bottom).offset(-3);
        }];
        
        PlayerSlider *slider = [[PlayerSlider alloc] init];
        [self addSubview:slider];
        _slider = slider;
        [slider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(30);
            make.bottom.equalTo(self.mas_bottom).offset(-3);
            make.left.equalTo(self.labCurrentTime.mas_right).offset(8);
            make.right.equalTo(self.labTotalTime.mas_left).offset(-8);
        }];
        
        [[self rac_valuesAndChangesForKeyPath:@"playing" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial observer:self] subscribeNext:^(RACTwoTuple<id,NSDictionary *> * _Nullable x) {
            @strongify(self)
            [self.btnPlayOrPause setImage:[UIImage imageNamed:(self.playing ? @"home-video-pause" : @"home-video-play")] forState:UIControlStateNormal];
        }];
        [[self rac_valuesAndChangesForKeyPath:@"mute" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial observer:self] subscribeNext:^(RACTwoTuple<id,NSDictionary *> * _Nullable x) {
            @strongify(self)
            [self.btnMuted setImage:[UIImage imageNamed:self.mute?@"home-video-mute":@"home-video-not-mute"] forState:UIControlStateNormal];
        }];
        [[self rac_valuesAndChangesForKeyPath:@"currentTime" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial observer:self] subscribeNext:^(RACTwoTuple<id,NSDictionary *> * _Nullable x) {
            @strongify(self)
            [self refreshTimeUI];
        }];
        [[self rac_valuesAndChangesForKeyPath:@"totalTime" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial observer:self] subscribeNext:^(RACTwoTuple<id,NSDictionary *> * _Nullable x) {
            @strongify(self)
            [self refreshTimeUI];
        }];
    }
    [self setBackgroundColor:[UIColor clearColor]];
}

-(void)refreshTimeUI {
    [self.labCurrentTime setText:[TimeStringFormatter formatTime:_currentTime]];
    [self.labTotalTime setText:[TimeStringFormatter formatTime:_totalTime]];
    if (![self.slider isTracking]) {
        [self.slider setValue:(self.currentTime*1.0f/self.totalTime) animated:NO];
    }
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [_gradientLayer setFrame:self.bounds];
    [CATransaction commit];
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
