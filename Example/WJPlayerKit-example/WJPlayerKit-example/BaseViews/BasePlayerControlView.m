//
//  BasePlayerControlView.m
//  WJPlayerKit-example
//
//  Created by ada on 2018/10/18.
//  Copyright © 2018年 PN. All rights reserved.
//

#import "BasePlayerControlView.h"

@interface BasePlayerControlView ()

@property(nonatomic, strong) NSHashTable<RACDisposable *> *disposables;

@end

@implementation BasePlayerControlView

-(void)startLoadingAnimated {
    [_loadingView startAnimating];
}

-(void)stopLoadingAnimated {
    [_loadingView stopAnimating];
}

-(void)removePlayerObserver {
    NSArray *objects = [_disposables allObjects];
    if ([objects count] > 0) {
        [objects makeObjectsPerformSelector:@selector(dispose)];
        [_disposables removeAllObjects];
    }
}

-(void)addPlayerObserver:(NSHashTable<RACDisposable *> *)disposables {}

-(void)setPlayer:(id<IWJPlayer>)player {
    if (_player == player) return;
    [self removePlayerObserver];
    _player = player;
    if (_player) [self addPlayerObserver:_disposables];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [_loadingView setFrame:CGRectMake((self.bounds.size.width-24.0f)/2.0f, (self.bounds.size.height-24.0f)/2.0f, 24.0f, 24.0f)];
    [CATransaction commit];
}

-(void)performInitialize {
    if (!_disposables) self.disposables = [[NSHashTable alloc] initWithOptions:NSPointerFunctionsWeakMemory capacity:0];
    if (!_loadingView) {
        PlayerLoadingView *v = [[PlayerLoadingView alloc] init];
        [self addSubview:v];
        _loadingView = v;
    }
    [self setClipsToBounds:YES];
    [self setBackgroundColor:[UIColor clearColor]];
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
