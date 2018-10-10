//
//  GaussianBlurPlayerPosterView.h
//  WJPlayer
//
//  Created by Yunhai.Wu on 2018/9/13.
//  Copyright © 2018年 PN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IWJPlayerPosterView.h"


/**
 高斯模糊海报视图
 */
@interface GaussianBlurPlayerPosterView : UIView<IWJPlayerPosterView>


/**
 媒体数据
 */
@property(nonatomic, strong) id<IWJMedia> media;

@end
