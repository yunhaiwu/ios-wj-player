//
//  PlayerBottomOperationBar.m
//  WJPlayerKit-example
//
//  Created by ada on 2018/10/18.
//  Copyright © 2018年 PN. All rights reserved.
//

#import "PlayerBottomOperationBar.h"
#import <Masonry/Masonry.h>

@interface PlayerBottomOperationBar()

@property(nonatomic, weak) UIButton *btnTransform, *btnPlayOrPause;

@property(nonatomic, weak) UILabel *currentTime, *totalTime;

@property(nonatomic, copy) PlayerBottomOperationBarActionBlock copyActionBlock;

@property(nonatomic, weak) CAGradientLayer *gradientLayer;

@end

@implementation PlayerBottomOperationBar

-(void)setActionBlock:(PlayerBottomOperationBarActionBlock)actionBlock {
    self.copyActionBlock = actionBlock;
}

-(instancetype)init {
    self = [super init];
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

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self performInitialize];
    }
    return self;
}

- (void)performInitialize {
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
        
        UIButton *btnPlayOrPause = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btnPlayOrPause];
        _btnPlayOrPause = btnPlayOrPause;
        @weakify(self)
        [[btnPlayOrPause rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            if (self.copyActionBlock != NULL) self.copyActionBlock(0, YES, NO);
        }];
        [btnPlayOrPause mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(44, 30));
            make.left.equalTo(self).offset(2);
            make.bottom.equalTo(self).offset(-2);
        }];
        
        UIButton *btnTransform = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btnTransform];
        _btnTransform = btnTransform;
        [[btnTransform rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            if (self.copyActionBlock != NULL) self.copyActionBlock(0, NO, YES);
        }];
        [btnTransform mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(44, 30));
            make.right.equalTo(self).offset(-2);
            make.bottom.equalTo(self).offset(-2);
        }];
        
        UILabel *currentTimeLab = [UILabel new];
        [currentTimeLab setBackgroundColor:[UIColor clearColor]];
        [currentTimeLab setTextAlignment:NSTextAlignmentCenter];
        [currentTimeLab setTextColor:[UIColor whiteColor]];
        [currentTimeLab setFont:[UIFont fontWithName:@"HelveticaNeue" size:10]];
        [self addSubview:currentTimeLab];
        _currentTime = currentTimeLab;
        [currentTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self)
            make.width.mas_greaterThanOrEqualTo(10);
            make.height.mas_equalTo(30);
            make.left.equalTo(self.btnPlayOrPause.mas_right).offset(2);
            make.bottom.equalTo(self).offset(-2);
        }];
        
        UILabel *totalTimeLab = [UILabel new];
        [totalTimeLab setBackgroundColor:[UIColor clearColor]];
        [totalTimeLab setTextAlignment:NSTextAlignmentCenter];
        [totalTimeLab setTextColor:[UIColor whiteColor]];
        [totalTimeLab setFont:[UIFont fontWithName:@"HelveticaNeue" size:10]];
        [self addSubview:totalTimeLab];
        _totalTime = totalTimeLab;
        [totalTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self)
            make.width.mas_greaterThanOrEqualTo(10);
            make.height.mas_equalTo(30);
            make.right.equalTo(self.btnTransform.mas_left).offset(-2);
            make.bottom.equalTo(self).offset(-2);
        }];
        
        PlayerSlider *slider = [[PlayerSlider alloc] init];
        [self addSubview:slider];
        _slider = slider;
        [slider mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self)
            make.height.mas_equalTo(30);
            make.bottom.equalTo(self).offset(-2);
            make.left.equalTo(self.currentTime.mas_right).offset(12);
            make.right.equalTo(self.totalTime.mas_left).offset(-12);
        }];
        
        [[self rac_valuesAndChangesForKeyPath:@"progress" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial observer:self] subscribeNext:^(RACTwoTuple<id,NSDictionary *> * _Nullable x) {
            @strongify(self)
            if (![self.slider isTracking]) {
                [self.slider setValue:self.progress];
            }
        }];
        [[self rac_valuesAndChangesForKeyPath:@"playing" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial observer:self] subscribeNext:^(RACTwoTuple<id,NSDictionary *> * _Nullable x) {
            @strongify(self)
            [self.btnPlayOrPause setImage:[UIImage imageNamed:(self.playing ? @"player-operation-bar-pause" : @"player-operation-bar-play")] forState:UIControlStateNormal];
        }];
    }
    [self setBackgroundColor:[UIColor clearColor]];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [_gradientLayer setFrame:self.bounds];
    [CATransaction commit];
}

@end
