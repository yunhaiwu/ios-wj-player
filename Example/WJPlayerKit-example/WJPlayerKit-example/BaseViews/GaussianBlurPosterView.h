//
//  GaussianBlurPosterView.h
//  WJPlayerKit-example
//
//  Created by ada on 2018/10/18.
//  Copyright © 2018年 PN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IWJPlayerPosterView.h"


@interface GaussianBlurPosterView : UIView<IWJPlayerPosterView>

/**
 媒体数据
 */
@property(nonatomic, strong) id<IWJMedia> media;

@end
