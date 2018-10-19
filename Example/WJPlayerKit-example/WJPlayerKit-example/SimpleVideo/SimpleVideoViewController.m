//
//  SimpleVideoViewController.m
//  WJPlayer
//
//  Created by Yunhai.Wu on 2018/9/13.
//  Copyright © 2018年 PN. All rights reserved.
//

#import "SimpleVideoViewController.h"
#import "SimpleVideoControlView.h"
#import "WJPlayerView.h"
#import "SimpleVideoMedia.h"
#import "SimpleVideoPlayView.h"
#import "GaussianBlurPosterView.h"
#import "HomePlayerControlView.h"

@interface SimpleVideoViewController ()

@property(nonatomic, weak) WJPlayerView *playerView;

@end

@implementation SimpleVideoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Simple Video";
    
//    if (!_simpleVideoPlayView) {
//        SimpleVideoPlayView *v = [[SimpleVideoPlayView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.width*9/16.0f)];
//        [self.view addSubview:v];
//        [v setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin];
//        _simpleVideoPlayView = v;
//        [v.playerView setMedia:[[SimpleVideoMedia alloc] initWithVideoUrl:@"https://video.piaoniu.com/review/15244807024027823.mp4" posterUrl:nil] autoPlay:YES];
//    }
    
    if (!_playerView) {
        WJPlayerView *v = [[WJPlayerView alloc] initWithControlView:[HomePlayerControlView new] posterView:[GaussianBlurPosterView new]];
        [v setFrame:CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.width*9/16.0f)];
        [self.view addSubview:v];
        [v setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin];
        _playerView = v;
        [v setMedia:[[SimpleVideoMedia alloc] initWithVideoUrl:@"https://video.piaoniu.com/tweet/15348319108120791_trans.mp4" posterUrl:@"https://img.piaoniu.com/video/ea9ac5419b5e1930b685a98529436e9aef9c3575.jpg"] autoPlay:NO];
    }
    
}


-(BOOL)shouldAutorotate {
    return NO;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

@end
