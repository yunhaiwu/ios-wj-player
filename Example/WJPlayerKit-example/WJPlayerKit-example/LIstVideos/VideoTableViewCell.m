//
//  VideoTableViewCell.m
//  WJPlayer
//
//  Created by Yunhai.Wu on 2018/9/10.
//  Copyright © 2018年 PN. All rights reserved.
//

#import "VideoTableViewCell.h"
#import "SimpleVideoPlayView.h"


@interface VideoTableViewCell ()

@property(nonatomic, weak) SimpleVideoPlayView *simpleVideoPlayView;

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
    [[_simpleVideoPlayView playerView] setMedia:data autoPlay:NO];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [_simpleVideoPlayView setFrame:self.contentView.bounds];
}

-(void)loadSubviews {
    if ([self contentView] && !_simpleVideoPlayView) {
        SimpleVideoPlayView *v = [[SimpleVideoPlayView alloc] initWithFrame:self.contentView.bounds];
        [self.contentView addSubview:v];
        [v setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        _simpleVideoPlayView = v;
    }
}

@end
