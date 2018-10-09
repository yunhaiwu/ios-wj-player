//
//  BaseViewController.m
//  WJPlayer
//
//  Created by ada on 2018/9/27.
//  Copyright © 2018年 PN. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

-(UIRectEdge)edgesForExtendedLayout {
    return UIRectEdgeNone;
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
