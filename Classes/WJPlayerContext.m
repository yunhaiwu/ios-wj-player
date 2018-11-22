//
//  WJPlayerContext.m
//  WJPlayer
//
//  Created by Yunhai.Wu on 2018/9/8.
//  Copyright © 2018年 PN. All rights reserved.
//

#import "WJPlayerContext.h"
#import "WJConfig.h"




@interface WJPlayerSnapshot : NSObject

@property(nonatomic, weak) id<IWJPlayer> player;
    
@property(nonatomic, assign) WJPlayerStatus status;

-(instancetype)initWithPlayer:(id<IWJPlayer>)player;
    
@end

@implementation WJPlayerSnapshot
    
-(instancetype)initWithPlayer:(id<IWJPlayer>)player {
    self = [super init];
    if (self) {
        self.player = player;
        self.status = [player status];
    }
    return self;
}

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@interface WJPlayerContext()

@property(nonatomic, strong) NSMutableDictionary *timesCache;

@property(nonatomic, strong) WJPlayerSnapshot *playerSnapshot;
    
@end

@implementation WJPlayerContext
    
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)handleApplicationDidBecomeActiveNotification:(NSNotification*)notification {
    if (self.currentPlayer && self.currentPlayer == self.playerSnapshot.player && (self.playerSnapshot.status == WJPlayerStatusPlaying || self.playerSnapshot.status == WJPlayerStatusLoading)) {
        [self.currentPlayer play];
    }
    self.playerSnapshot = nil;
}
    
-(void)handleApplicationWillResignActiveNotification:(NSNotification*)notification {
    if (self.currentPlayer) {
        self.playerSnapshot = [[WJPlayerSnapshot alloc] initWithPlayer:self.currentPlayer];
        if (self.currentPlayer.status == WJPlayerStatusPlaying || self.currentPlayer.status == WJPlayerStatusLoading) {
            [self.currentPlayer pause];
        }
    }
    
}
    
- (instancetype)init {
    self = [super init];
    if (self) {
        self.timesCache = [[NSMutableDictionary alloc] init];
//        NSDictionary *config = [WJConfig objectForKey:@"WJPlayerKit"];
//        if (config && [config[@"playProgressCacheCount"] isKindOfClass:[NSNumber class]]) {
//            NSInteger count = [config[@"playProgressCacheCount"] integerValue];
//            if (count > 0) {
//                [self.timesCache setCountLimit:(count > 200 ? 200 : count)];
//            } else {
//                self.timesCache  = nil;
//            }
//        } else {
//            [self.timesCache setCountLimit:2];
//        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleApplicationDidBecomeActiveNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleApplicationWillResignActiveNotification:) name:UIApplicationWillResignActiveNotification object:nil];
    }
    return self;
}

- (void)setTime:(int)time forKey:(NSString *)key {
    if (key && time >= 0) {
        [self.timesCache setObject:@(time) forKey:key];
    }
}

- (int)timeForKey:(NSString *)key {
    if (key) {
        NSNumber *obj = [self.timesCache objectForKey:key];
        if (obj) return [obj intValue];
    }
    return 0;
}

- (id)copy {
    return self;
}

- (id)mutableCopy {
    return self;
}

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id singleton;
    dispatch_once( &once, ^{
        singleton = [[self alloc] init];
    });
    return singleton;
}

-(void)pauseCurrentPlayer {
    if (_currentPlayer && [_currentPlayer status] == WJPlayerStatusLoading || [_currentPlayer status] == WJPlayerStatusPlaying) {
        [_currentPlayer pause];
    }
}

@end
