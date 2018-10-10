//
//  AudioPlayViewController.m
//  WJPlayer
//
//  Created by ada on 2018/9/29.
//  Copyright © 2018年 PN. All rights reserved.
//

#import "AudioPlayViewController.h"
#import "SimplePlayerControlView.h"
#import "WJPlayerView.h"
#import "SimpleAudioMedia.h"
#import "GaussianBlurPlayerPosterView.h"


@interface AudioPlayViewController ()

@property(nonatomic, weak) WJPlayerView *playerView;

@end

@implementation AudioPlayViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Simple Audio";
    
    if (!_playerView) {
        WJPlayerView *p = [[WJPlayerView alloc] initWithControlView:[[SimplePlayerControlView alloc] init] posterView:[[GaussianBlurPlayerPosterView alloc] init]];
        [self.view addSubview:p];
        [p setFrame:CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.width*9/16.0f)];
        [p setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin];
        [self.view addSubview:p];
        _playerView = p;
        [p setMedia:[[SimpleAudioMedia alloc] initWithVideoUrl:@"https://m10.music.126.net/20180929165532/044d87ba17c46883453b6ca8b0f3f535/ymusic/e47f/9bc5/2695/b74c4b8332994ffcb34a6f2c0080b9e6.mp3" posterUrl:@"https://p1.music.126.net/ADtuKwIN1n64E_DX8-N4ew==/109951163188720331.jpeg"] autoPlay:YES];
    }
    
}

@end
