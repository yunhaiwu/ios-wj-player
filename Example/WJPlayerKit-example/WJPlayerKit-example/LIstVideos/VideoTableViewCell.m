//
//  VideoTableViewCell.m
//  WJPlayer
//
//  Created by Yunhai.Wu on 2018/9/10.
//  Copyright © 2018年 PN. All rights reserved.
//

#import "VideoTableViewCell.h"
#import "GaussianBlurPlayerPosterView.h"
#import "SimplePlayerControlView.h"

@interface VideoTableViewCell ()

@end

@implementation VideoTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //加载自视图
        [self loadSubviews];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

-(void)setData:(SimpleVideoMedia *)data {
    if (_data == data) return;
    _data = data;
    [_playerView playMedia:data autoPlay:NO];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [_playerView setFrame:self.contentView.bounds];
}

-(void)loadSubviews {
    if ([self contentView] && !_playerView) {
        WJPlayerView *v = [[WJPlayerView alloc] initWithControlView:[[SimplePlayerControlView alloc] init] posterView:[[GaussianBlurPlayerPosterView alloc] init]];
        [self.contentView addSubview:v];
        [v setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        _playerView = v;
    }
}

@end
