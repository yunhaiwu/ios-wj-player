//
//  WJPlayerContext.m
//  WJPlayer
//
//  Created by Yunhai.Wu on 2018/9/8.
//  Copyright © 2018年 PN. All rights reserved.
//

#import "WJPlayerContext.h"

@interface WJPlayerContext()

@property(nonatomic, strong) NSCache *timesCache;

@end

@implementation WJPlayerContext

- (instancetype)init {
    self = [super init];
    if (self) {
        self.timesCache = [[NSCache alloc] init];
        [self.timesCache setCountLimit:200];
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
