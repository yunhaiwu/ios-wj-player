//
//  SimplePlayerControlView.m
//  WJPlayer
//
//  Created by ada on 2018/9/13.
//  Copyright © 2018年 PN. All rights reserved.
//

#import "Simple2PlayerControlView.h"
#import "ReactiveObjC.h"
#import "KVOController.h"

@interface Simple2PlayerControlView ()

@property(nonatomic, weak) UIButton *button;
@property(nonatomic, weak) UIActivityIndicatorView *loadingView;

@end

@implementation Simple2PlayerControlView

-(void)setPlayer:(id<IWJPlayer>)player {
    if (_player == player) return;
    _player = player;
    if (_player) {
        @weakify(self)
        [self.KVOController observe:_player keyPath:@"status" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
            @strongify(self)
            if (self.player.status == WJPlayerStatusPlaying) {
                [self.button setTitle:@"暂停" forState:UIControlStateNormal];
                [self.loadingView stopAnimating];
                [self.loadingView setHidden:YES];
            } else {
                [self.button setTitle:@"播放" forState:UIControlStateNormal];
            }
            if (self.player.status == WJPlayerStatusLoading) {
                [self.loadingView setHidden:NO];
                [self.loadingView startAnimating];
            }
        }];
    }
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [_loadingView setFrame:CGRectMake((self.bounds.size.width-_loadingView.bounds.size.width)/2.0f, (self.bounds.size.height-_loadingView.bounds.size.height)/2.0f, _loadingView.bounds.size.width, _loadingView.bounds.size.height)];
    [_button setFrame:CGRectMake(self.bounds.size.width-80.0f, self.bounds.size.height-50.0f, 70, 40)];
}

-(void)loadSubviews {
    if (!_button) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        @weakify(self)
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            if (self.player.status == WJPlayerStatusPlaying) {
                [self.player pause];
            } else {
                [self.player play];
            }
        }];
        [self addSubview:button];
        _button = button;
        
        UIActivityIndicatorView *v = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self addSubview:v];
        [v setHidesWhenStopped:YES];
        _loadingView = v;
    }
    [self setBackgroundColor:[UIColor clearColor]];
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

-(void)dealloc {
    NSLog(@"%@ dealloc ...",NSStringFromClass(self.class));
}

@end
