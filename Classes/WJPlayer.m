//
//  PNVideoDisplayView.m
//  WJPlayer
//
//  Created by Yunhai.Wu on 2018/9/8.
//  Copyright © 2018年 PN. All rights reserved.
//

#import "WJPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import "WJPlayerContext.h"
#import "WJMediaCacheFactory.h"
#import "WJLoggingAPI.h"

@interface WJPlayer()

@property(nonatomic, strong) AVPlayer *player;

@property(nonatomic, strong) AVPlayerItem *playerItem;

@property(nonatomic, weak) AVPlayerLayer *playerLayer;

@property(nonatomic, strong) id timeObserver;

@end

@implementation WJPlayer

static NSDictionary *playerObserveOptions;
static NSDictionary *playerItemObserveOptions;


+(void)load {
    playerObserveOptions = @{
                            @"rate":@(NSKeyValueObservingOptionNew),
                            @"timeControlStatus":@(NSKeyValueObservingOptionNew),
                            @"muted":@(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial)
                            };
    playerItemObserveOptions = @{
                                 @"status":@(NSKeyValueObservingOptionNew),
                                 @"loadedTimeRanges":@(NSKeyValueObservingOptionNew),
                                 @"playbackBufferEmpty":@(NSKeyValueObservingOptionNew),
                                 @"playbackLikelyToKeepUp":@(NSKeyValueObservingOptionNew)
                                 };
}

-(instancetype)init {
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

-(void)dealloc {
    [self cleanPlayer];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [self.playerLayer setFrame:self.bounds];
    [CATransaction commit];
}


#pragma mark play finish notification
-(void)handlePlayerDidFinishPlayingNotification:(NSNotification*)notification {
    WJLogDebug(@"\n play finish notification :%@",_mediaData.mediaURL.absoluteString);
    WJ_PLAYER_CONTEXT_TIME_SET([[_mediaData mediaURL] absoluteString], 0);
    [self changeStatus:WJPlayerStatusCompleted];
}

#pragma mark observe
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus itemStatus = [change[NSKeyValueChangeNewKey] integerValue];
        switch (itemStatus) {
            case AVPlayerItemStatusUnknown: {
                [self changeStatus:WJPlayerStatusUnknown];
                break;
            }
            case AVPlayerItemStatusReadyToPlay: {
                [self changeStatus:WJPlayerStatusReadyToPlay];
                [self performSelectorOnMainThread:@selector(play) withObject:nil waitUntilDone:NO];
                break;
            }
            case AVPlayerItemStatusFailed: {
                [self changeStatus:WJPlayerStatusFailed];
                break;
            }
            default:
                break;
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSArray *loadedTimeRanges = [[self.player currentItem] loadedTimeRanges];
        CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];      // 获取缓冲区域
        int startSeconds = CMTimeGetSeconds(timeRange.start);
        int durationSeconds = CMTimeGetSeconds(timeRange.duration);
        [self changeLoadedTime:startSeconds + durationSeconds];
    }
//    else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
        //缓存开始
//        [self changeStatus:WJPlayerStatusLoading];
//    } else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
//        //缓存完成
//    }
    else if ([keyPath isEqualToString:@"muted"]) {
        [self changeMuted:self.player.muted];
    } else {
        if (@available(iOS 10.0, *)) {
            if ([keyPath isEqualToString:@"timeControlStatus"]) {
                AVPlayerTimeControlStatus status = [change[NSKeyValueChangeNewKey] integerValue];
                if (status == AVPlayerTimeControlStatusPaused) {
                    [self changeStatus:(_currentPlayTime == _duration) ? WJPlayerStatusCompleted : WJPlayerStatusPaused];
                }
                if (status == AVPlayerTimeControlStatusPlaying) {
                    [self changeStatus:WJPlayerStatusPlaying];
                }
                if (status == AVPlayerTimeControlStatusWaitingToPlayAtSpecifiedRate) {
                    [self changeStatus:WJPlayerStatusLoading];
                }
            }
        } else {
            if ([keyPath isEqualToString:@"rate"]) {
                NSInteger rate = [change[NSKeyValueChangeNewKey] integerValue];
                //当rate==0时为暂停,rate==1时为播放,当rate等于负数时为回放
                [self changeStatus:(rate == 0) ? WJPlayerStatusPaused : WJPlayerStatusPlaying];
            }
        }
    }
    
}

-(void)removeObservers {
    [playerObserveOptions enumerateKeysAndObjectsUsingBlock:^(NSString *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [self.player removeObserver:self forKeyPath:key];
    }];
    [playerItemObserveOptions enumerateKeysAndObjectsUsingBlock:^(NSString *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [self.playerItem removeObserver:self forKeyPath:key];
    }];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (_timeObserver) [_player removeTimeObserver:_timeObserver];
}

-(void)addObservers {
    
    [playerObserveOptions enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSNumber *obj, BOOL * _Nonnull stop) {
        [self.player addObserver:self forKeyPath:key options:[obj unsignedIntegerValue] context:nil];
    }];
    [playerItemObserveOptions enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSNumber *obj, BOOL * _Nonnull stop) {
        [self.playerItem addObserver:self forKeyPath:key options:[obj unsignedIntegerValue] context:nil];
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePlayerDidFinishPlayingNotification:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    __weak typeof(self) weakSelf = self;
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.f, 1.f) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        int seconds = CMTimeGetSeconds(weakSelf.player.currentItem.currentTime);
        NSArray* loadedRanges = weakSelf.player.currentItem.seekableTimeRanges;
        if (loadedRanges.count > 0) {
            CMTimeRange range = [[loadedRanges objectAtIndex:0] CMTimeRangeValue];
            Float64 duration = CMTimeGetSeconds(range.start) + CMTimeGetSeconds(range.duration);
            [weakSelf changeDuration:duration];
        }
        if (!CMTIME_IS_INDEFINITE(weakSelf.player.currentItem.asset.duration)) {
            [weakSelf changeCurrentPlayTime:seconds];
            WJ_PLAYER_CONTEXT_TIME_SET(weakSelf.mediaData.mediaURL.absoluteString, seconds);
        }
    }];
}
-(void)setMuted:(BOOL)muted {
    if (_muted == muted) return;
    [self willChangeValueForKey:@"muted"];
    _muted = muted;
    [self didChangeValueForKey:@"muted"];
    if (self.player) [self.player setMuted:_muted];
}
-(void)changeMuted:(BOOL)muted {
    if (_muted == muted) return;
    [self willChangeValueForKey:@"muted"];
    _muted = muted;
    [self didChangeValueForKey:@"muted"];
}
-(void)changeCurrentPlayTime:(int)time {
    if (_currentPlayTime == time) return;
    [self willChangeValueForKey:@"currentPlayTime"];
    _currentPlayTime = time;
    [self didChangeValueForKey:@"currentPlayTime"];
}

-(void)changeStatus:(WJPlayerStatus)status {
    if (_status == status) return;
    [self willChangeValueForKey:@"status"];
    _status = status;
    [self didChangeValueForKey:@"status"];
}

-(void)changeDuration:(int)duration {
    if (_duration == duration) return;
    [self willChangeValueForKey:@"duration"];
    _duration = duration;
    [self didChangeValueForKey:@"duration"];
}

-(void)changeLoadedTime:(int)loadedTime {
    if (_loadedTime == loadedTime) return;
    [self willChangeValueForKey:@"loadedTime"];
    _loadedTime = loadedTime;
    [self didChangeValueForKey:@"loadedTime"];
}

-(void)cleanPlayer {
    WJLogDebug(@"\n clean player:%@",[_mediaData mediaURL].absoluteString);
    [self pause];
    [self removeObservers];
    if (_playerLayer) [_playerLayer removeFromSuperlayer];
    [self.playerItem cancelPendingSeeks];
    [self.player replaceCurrentItemWithPlayerItem:nil];
    [[WJMediaCacheFactory getMediaCache] cancelLoading:self.mediaData.mediaURL];
    self.player = nil;
    self.playerItem = nil;
    self.playerLayer = nil;
    self.timeObserver = nil;
    [self changeLoadedTime:0];
    [self changeCurrentPlayTime:0];
    [self changeDuration:0];
    [self changeStatus:WJPlayerStatusUnknown];
}

-(void)loadPlayer:(NSURL*)url {
    if (!url) return;
    WJLogDebug(@"\n load player:%@",url.absoluteString);
    self.playerItem = [[WJMediaCacheFactory getMediaCache] getPlayerItem:url];
    self.player = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];
    //视频媒体需要添加到当前视图层上
    if ([_mediaData type] == WJMediaTypeVideo) {
        AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        [layer setBackgroundColor:[UIColor clearColor].CGColor];
        layer.player = self.player;
        [self.layer addSublayer:layer];
        layer.frame = self.bounds;
        [layer displayIfNeeded];
        layer.videoGravity = AVLayerVideoGravityResizeAspect;
        _playerLayer = layer;
    }
    
    [self addObservers];
}



/************************************************************************
 ************************************************************************/
-(void)setMedia:(id<IWJMedia>)media {
    if (_mediaData && [_mediaData.mediaURL.absoluteString isEqualToString:media.mediaURL.absoluteString]) return;
    WJLogDebug(@"\n set media :%@",media.mediaURL.absoluteString);
    [self cleanPlayer];
    [self willChangeValueForKey:@"mediaData"];
    _mediaData = media;
    [self didChangeValueForKey:@"mediaData"];
}

-(void)play {
    if (!self.mediaData) return;
    WJLogDebug(@"\n play :%@",_mediaData.mediaURL.absoluteString);
    //清理播放器
    WJPlayer *previousPlayer = (WJPlayer*)WJ_PLAYER_CONTEXT_CURRENT_PLAYER_GET;
    if (previousPlayer != self) {
        [previousPlayer cleanPlayer];
    }
    WJ_PLAYER_CONTEXT_CURRENT_PLAYER_SET(self);
    if (self.player) {
        if (self.status == WJPlayerStatusReadyToPlay || self.status == WJPlayerStatusPaused) {
            if (_currentPlayTime != WJ_PLAYER_CONTEXT_TIME_GET(_mediaData.mediaURL.absoluteString)) {
                [self seekToTime:WJ_PLAYER_CONTEXT_TIME_GET(_mediaData.mediaURL.absoluteString)];
            }
            [self.player play];
        } else if (self.status == WJPlayerStatusCompleted) {
            [self seekToTime:0];
            [self changeCurrentPlayTime:0];
            WJ_PLAYER_CONTEXT_TIME_SET(_mediaData.mediaURL.absoluteString, 0);
            [self.player play];
        }
    } else {
        [self loadPlayer:_mediaData.mediaURL];
    }
}

-(void)pause {
    if (!self.player) return;
    WJLogDebug(@"\n pause :%@",_mediaData.mediaURL.absoluteString);
    [self.player pause];
    [self.playerItem cancelPendingSeeks];
}

-(void)replay {
    if (!self.player) return;
    WJLogDebug(@"\n replay url:%@",_mediaData.mediaURL.absoluteString);
    [self pause];
    WJ_PLAYER_CONTEXT_TIME_SET(_mediaData.mediaURL.absoluteString, 0);
    [self seekToTime:0];
    [self play];
}

-(void)seekToTime:(int)t {
    if (!self.player) return;
    WJLogDebug(@"\n replay t:%i url:%@",t,_mediaData.mediaURL.absoluteString);
    if (self.player.status != AVPlayerStatusUnknown) {
        WJ_PLAYER_CONTEXT_TIME_SET(_mediaData.mediaURL.absoluteString, t);
        CMTime time = CMTimeMake(t, 1);
        if (isnan(CMTimeGetSeconds(time))) time = kCMTimeZero;
        [self.player seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    }
}

-(CGSize)videoSize {
    if (self.playerLayer) {
        return CGSizeMake(self.playerLayer.videoRect.size.width, self.playerLayer.videoRect.size.height);
    }
    return CGSizeZero;
}

@end
