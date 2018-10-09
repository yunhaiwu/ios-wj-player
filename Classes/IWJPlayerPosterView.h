//
//  IWJPlayerPosterView.h
//  WJPlayer
//
//  Created by Yunhai.Wu on 2018/9/8.
//  Copyright © 2018年 PN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IWJMedia.h"

/**
 海报视图
 */
@protocol IWJPlayerPosterView <NSObject>

/**
 播放媒体文件
 */
@property(nonatomic, strong) id<IWJMedia> media;

@end
