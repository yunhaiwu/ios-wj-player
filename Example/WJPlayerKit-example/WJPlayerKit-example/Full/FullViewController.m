//
//  FullViewController.m
//  WJPlayer
//
//  Created by ada on 2018/9/27.
//  Copyright © 2018年 PN. All rights reserved.
//

#import "FullViewController.h"
#import "ReactiveObjC.h"

@interface FullViewController ()

@end

@implementation FullViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] init];
    [doubleTap setNumberOfTapsRequired:2];
    [[doubleTap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        [self dismissViewControllerAnimated:NO completion:NULL];
    }];
    [self.view addGestureRecognizer:doubleTap];
    [self.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7f]];
    
}

-(BOOL)shouldAutorotate {
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeRight;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeRight;
}

@end
