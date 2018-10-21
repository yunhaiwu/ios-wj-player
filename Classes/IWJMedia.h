//
//  IWJMedia.h
//  WJPlayer
//
//  Created by Yunhai.Wu on 2018/9/9.
//  Copyright © 2018年 PN. All rights reserved.
//

#import <UIKit/UIKit.h>


//媒体文件类型
typedef NS_ENUM (NSInteger, WJMediaType) {
  
    //视频文件
    WJMediaTypeVideo = 0,
    
    //音频文件
    WJMediaTypeAudio = 1
};

/**
 媒体文件
 */
@protocol IWJMedia <NSObject>

/**
 媒体类型
 */
-(NSInteger)mediaType;

/**
 海报图url
 */
-(NSURL*)mediaPosterURL;

/**
 媒体资源url
 */
-(NSURL*)mediaURL;

/**
 媒体总时长
 */
-(int)mediaDuration;

@optional

/**
 海报占位符图片
 */
-(UIImage*)mediaPosterPlaceholder;

@end
