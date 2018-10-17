//
//  Default4GAskControlView.m
//  WJPlayerKit-example
//
//  Created by ada on 2018/10/17.
//  Copyright © 2018年 PN. All rights reserved.
//

#import "Default4GAskControlView.h"
#import "ReactiveObjC.h"

@interface Default4GAskControlView()

@property(nonatomic, weak) UIButton *btnContinue;

@end

@implementation Default4GAskControlView

-(void)loadSubviews {
    if (!_btnContinue) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"继续播放" forState:UIControlStateNormal];
        [[button titleLabel] setFont:[UIFont systemFontOfSize:12]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor blackColor]];
        [self addSubview:button];
        _btnContinue = button;
        @weakify(self)
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self continuePlay];
        }];
    }
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [_btnContinue setFrame:CGRectMake((self.bounds.size.width-60.0f)/2.0f, (self.bounds.size.height-30.0f)/2.0f, 60, 30)];
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
