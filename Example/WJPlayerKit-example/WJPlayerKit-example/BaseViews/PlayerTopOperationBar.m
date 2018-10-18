//
//  PlayerTopOperationBar.m
//  WJPlayerKit-example
//
//  Created by ada on 2018/10/18.
//  Copyright © 2018年 PN. All rights reserved.
//

#import "PlayerTopOperationBar.h"
#import "ReactiveObjC.h"

@interface PlayerTopOperationBar()

@property(nonatomic, weak) CAGradientLayer *gradientLayer;

@property(nonatomic, copy) PlayerTopOperationBarActionBlock copyActionBlock;

@property(nonatomic, weak) UIButton *btnGoBack;

@end

@implementation PlayerTopOperationBar

-(void)setActionBlock:(PlayerTopOperationBarActionBlock)actionBlock {
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
        gradientLayer.colors = @[(__bridge id)[[UIColor blackColor] colorWithAlphaComponent:0.25f].CGColor,
                                 (__bridge id)[[UIColor blackColor] colorWithAlphaComponent:0].CGColor];
        gradientLayer.locations = @[@(0.0f), @(1.0f)];
        [self.layer addSublayer:gradientLayer];
        _gradientLayer = gradientLayer;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"player-operation-bar-goback"] forState:UIControlStateNormal];
        [self addSubview:button];
        _btnGoBack = button;
        @weakify(self)
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            if (self.copyActionBlock != NULL) self.copyActionBlock();
        }];
    }
    [self setClipsToBounds:YES];
    [self setBackgroundColor:[UIColor clearColor]];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [_gradientLayer setFrame:self.bounds];
    [_btnGoBack setFrame:CGRectMake(4, (self.bounds.size.height-40.0f)/2.0f, 44, 40)];
    [CATransaction commit];
}

@end
