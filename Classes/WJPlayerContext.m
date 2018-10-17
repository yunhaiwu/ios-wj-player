//
//  WJPlayerContext.m
//  WJPlayer
//
//  Created by Yunhai.Wu on 2018/9/8.
//  Copyright © 2018年 PN. All rights reserved.
//

#import "WJPlayerContext.h"
#import "WJConfig.h"

@interface WJPlayerContext()

@property(nonatomic, strong) NSCache *timesCache;

@end

@implementation WJPlayerContext

- (instancetype)init {
    self = [super init];
    if (self) {
        self.timesCache = [[NSCache alloc] init];
        NSDictionary *config = [WJConfig objectForKey:@"WJPlayerKit"];
        if (config && [config[@"playProgressCacheCount"] isKindOfClass:[NSNumber class]]) {
            NSInteger count = [config[@"playProgressCacheCount"] integerValue];
            if (count > 0) {
                [self.timesCache setCountLimit:(count > 200 ? 200 : count)];
            } else {
                self.timesCache  = nil;
            }
        } else {
            [self.timesCache setCountLimit:2];
        }
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

@end
