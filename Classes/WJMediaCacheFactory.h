//
//  PNCacheFactory.h
//  WJPlayer
//
//  Created by ada on 2018/9/29.
//  Copyright © 2018年 PN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IWJMediaCache.h"

//第三方缓存需要 实现一个类名为WJMediaCacheBuilder
@interface WJMediaCacheFactory : NSObject

+(id<IWJMediaCache>)getMediaCache;

@end
