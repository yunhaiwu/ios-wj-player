//
//  BaseWJWanPlayControlView.m
//  WJPlayerKit-example
//
//  Created by ada on 2018/10/15.
//  Copyright © 2018年 PN. All rights reserved.
//

#import "AbstractAskPlayControlView.h"


@implementation AbstractAskPlayControlView


-(void)continuePlay {
    [_askDelegate askPlayControlViewDidContinue:self];
}

@end
