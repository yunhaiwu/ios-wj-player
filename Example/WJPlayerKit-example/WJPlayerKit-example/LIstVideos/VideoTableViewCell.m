//
//  VideoTableViewCell.m
//  WJPlayer
//
//  Created by Yunhai.Wu on 2018/9/10.
//  Copyright © 2018年 PN. All rights reserved.
//

#import "VideoTableViewCell.h"
//#import "SimpleVideoPlayView.h"
#import "CanFullScreenVideoPlayView.h"


@interface VideoTableViewCell ()

//@property(nonatomic, weak) SimpleVideoPlayView *simpleVideoPlayView;
@property(nonatomic, weak) CanFullScreenVideoPlayView *videoPlayView;

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
//    [[_simpleVideoPlayView playerView] setMedia:data autoPlay:NO];
    [[_videoPlayView playerView] setMedia:data autoPlay:NO];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [_videoPlayView setFrame:self.contentView.bounds];
//    [_simpleVideoPlayView setFrame:self.contentView.bounds];
}

-(void)loadSubviews {
    if ([self contentView] && !_videoPlayView) {
        CanFullScreenVideoPlayView *v = [[CanFullScreenVideoPlayView alloc] init];
        [self.contentView addSubview:v];
        _videoPlayView = v;
        [self setClipsToBounds:YES];
    }
}

@end
