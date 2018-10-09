//
//  SimpleVideoControlView.h
//  WJPlayer
//
//  Created by Yunhai.Wu on 2018/9/9.
//  Copyright © 2018年 PN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IWJPlayerControlView.h"

@interface SimpleVideoControlView : UIView<IWJPlayerControlView>

@property(nonatomic, weak) id<IWJPlayer> player;

+(instancetype)instance;

@end
