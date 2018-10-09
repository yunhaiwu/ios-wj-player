//
//  SimpleVideoMedia.m
//  WJPlayer
//
//  Created by ada on 2018/9/13.
//  Copyright © 2018年 PN. All rights reserved.
//

#import "SimpleVideoMedia.h"

@implementation SimpleVideoMedia

- (instancetype)initWithVideoUrl:(NSString*)videoUrl posterUrl:(NSString*)posterUrl {
    self = [super init];
    if (self) {
        if (videoUrl) self.videoUrl = [NSURL URLWithString:videoUrl];
        if (posterUrl) self.posterUrl = [NSURL URLWithString:posterUrl];
    }
    return self;
}

#pragma mark IWJMedia
-(NSInteger)type {
    return WJMediaTypeVideo;
}

-(NSURL*)posterURL {
    return _posterUrl;
}

-(NSURL*)mediaURL {
    return _videoUrl;
}

@end
