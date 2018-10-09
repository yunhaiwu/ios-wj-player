//
//  SimplePlayerPosterView.h
//  WJPlayer
//
//  Created by Yunhai.Wu on 2018/9/13.
//  Copyright © 2018年 PN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IWJPlayerPosterView.h"

//普通海报视图
@interface SimplePlayerPosterView : UIView<IWJPlayerPosterView>

@property(nonatomic, strong) id<IWJMedia> media;

@end
