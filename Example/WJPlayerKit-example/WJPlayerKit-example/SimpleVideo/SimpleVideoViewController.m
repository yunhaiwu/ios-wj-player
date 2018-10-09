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
#import "FullViewController.h"

@interface SimpleVideoViewController ()

@property(nonatomic, weak) SimpleVideoControlView *controlView;

@property(nonatomic, weak) WJPlayerView *playerView;

@end

@implementation SimpleVideoViewController

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.playerView pause];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Simple Video";
    
    if (!_playerView) {
        SimpleVideoControlView *controlView = [SimpleVideoControlView instance];
        WJPlayerView *p = [[WJPlayerView alloc] initWithControlView:controlView];
        [p setBackgroundColor:[UIColor blackColor]];
        [p playMedia:[[SimpleVideoMedia alloc] initWithVideoUrl:@"https://video.piaoniu.com/review/15244807024027823.mp4" posterUrl:nil] autoPlay:YES];
        [self.view addSubview:p];
        [p setFrame:CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.width*9/16.0f)];
        [p setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin];
        [self.view addSubview:p];
        _playerView = p;
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"全屏" style:UIBarButtonItemStyleDone target:self action:@selector(rightExec:)];
}

-(void)rightExec:(id)sender {
    //进入全屏
    FullViewController *vc = [[FullViewController alloc] init];
    [self.navigationController presentViewController:vc animated:NO completion:NULL];
}


@end
