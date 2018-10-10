//
//  BaseControlView.h
//  WJPlayerKit-example
//
//  Created by ada on 2018/10/9.
//  Copyright © 2018年 PN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IWJPlayerControlView.h"

@interface BaseControlView : UIView<IWJPlayerControlView>

@property(nonatomic, weak) id<IWJPlayer> player;

-(void)startLoadingAnimated;

-(void)stopLoadingAnimated;

@end
