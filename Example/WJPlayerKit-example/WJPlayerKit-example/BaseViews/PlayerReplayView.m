//
//  PlayerReplayView.m
//  WJPlayerKit-example
//
//  Created by ada on 2018/10/18.
//  Copyright © 2018年 PN. All rights reserved.
//

#import "PlayerReplayView.h"
#import "ReactiveObjC.h"

@interface PlayerReplayView ()

@property(nonatomic, weak) UIButton *btnReplay;

@property(nonatomic, copy) PlayerReplayViewActionBlock copyActionBlock;

@end

@implementation PlayerReplayView

-(void)setActionBlock:(PlayerReplayViewActionBlock)actionBlock {
    self.copyActionBlock = actionBlock;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [_btnReplay setFrame:CGRectMake((self.bounds.size.width-97)/2.0f, (self.bounds.size.height-32.0f)/2.0f, 97, 32)];
    [CATransaction commit];
}

-(void)performInitialize {
    if (!_btnReplay) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        @weakify(self)
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            if (self.copyActionBlock != NULL) self.copyActionBlock();
        }];
        [button setImage:[UIImage imageNamed:@"player-replay"] forState:UIControlStateNormal];
        [self addSubview:button];
        _btnReplay = button;
    }
    [self setBackgroundColor:[UIColor blackColor]];
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
