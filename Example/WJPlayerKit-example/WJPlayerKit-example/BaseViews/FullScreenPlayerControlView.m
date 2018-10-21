//
//  FullScreenPlayerControlView.m
//  WJPlayerKit-example
//
//  Created by ada on 2018/10/19.
//  Copyright © 2018年 PN. All rights reserved.
//

#import "FullScreenPlayerControlView.h"
#import "PlayerTopOperationBar.h"
#import "PlayerBottomOperationBar.h"

@interface FullScreenPlayerControlView()

@property(nonatomic, weak) PlayerBottomOperationBar *bottomBar;

@property(nonatomic, weak) PlayerTopOperationBar *topBar;

@property(nonatomic, copy) FullScreenPlayerControlViewActionBlock copyActionBlock;

@end

@implementation FullScreenPlayerControlView

-(void)setActionBlock:(FullScreenPlayerControlViewActionBlock)actionBlock {
    self.copyActionBlock = actionBlock;
}

- (void)loadSubviews {
    if (!_topBar) {
        PlayerTopOperationBar *topBar = [[PlayerTopOperationBar alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 44.0f)];
        [self addSubview:topBar];
        [topBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin];
        _topBar = topBar;
        self.topOperationBar = topBar;
        @weakify(self)
        [topBar setActionBlock:^{
            @strongify(self)
            if (NULL != self.copyActionBlock) self.copyActionBlock(YES);
        }];
        
        PlayerBottomOperationBar *bottomBar = [[PlayerBottomOperationBar alloc] initWithFrame:CGRectMake(0, self.bounds.size.height, self.bounds.size.width, 44.0f)];
        [self addSubview:bottomBar];
        [bottomBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin];
        _bottomBar = bottomBar;
        self.bottomOperationBar = bottomBar;
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
    }
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
