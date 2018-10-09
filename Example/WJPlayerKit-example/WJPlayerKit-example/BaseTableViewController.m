//
//  BaseTableViewController.m
//  WJPlayer
//
//  Created by ada on 2018/9/27.
//  Copyright © 2018年 PN. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

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
