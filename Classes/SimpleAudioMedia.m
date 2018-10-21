//
//  SimpleAudioMedia.m
//  WJPlayer
//
//  Created by ada on 2018/9/24.
//  Copyright © 2018年 PN. All rights reserved.
//

#import "SimpleAudioMedia.h"

@implementation SimpleAudioMedia

- (instancetype)initWithVideoUrl:(NSString*)videoUrl posterUrl:(NSString*)posterUrl {
    self = [super init];
    if (self) {
        if (videoUrl) self.videoUrl = [NSURL URLWithString:videoUrl];
        if (posterUrl) self.posterUrl = [NSURL URLWithString:posterUrl];
    }
    return self;
}

#pragma mark IWJMedia
- (NSInteger)mediaType {
    return WJMediaTypeAudio;
}

- (NSURL*)mediaPosterURL {
    return _posterUrl;
}

- (NSURL*)mediaURL {
    return _videoUrl;
}

- (int)mediaDuration {
    return 0;
}

@end
