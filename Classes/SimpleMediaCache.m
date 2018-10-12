//
//  DefaultMediaCache.m
//  WJPlayer
//
//  Created by ada on 2018/9/29.
//  Copyright © 2018年 PN. All rights reserved.
//

#import "SimpleMediaCache.h"
#import <UIKit/UIKit.h>

#define PN_DEFAULT_MEDIA_ASSET_MAX_CACHE_NUMBER     20

@interface SimpleMediaCache ()

@property(nonatomic, strong) NSCache *assetsCache;

@end

@implementation SimpleMediaCache

-(instancetype)init {
    self = [super init];
    if (self) {
        self.assetsCache = [[NSCache alloc] init];
        [self.assetsCache setTotalCostLimit:PN_DEFAULT_MEDIA_ASSET_MAX_CACHE_NUMBER];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleApplicationDidReceiveMemoryWarningNotification:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}


/**
 处理内存警告通知
 */
-(void)handleApplicationDidReceiveMemoryWarningNotification:(NSNotification*)notification {
    [self cleanAllCache];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(AVURLAsset*)getAssetWithUrl:(NSURL*)url {
    if (url == nil) return nil;
    NSString *key = url.absoluteString;
    AVURLAsset *asset = [self.assetsCache objectForKey:key];
    if (!asset) {
        asset = [AVURLAsset assetWithURL:url];
        [self.assetsCache setObject:asset forKey:key];
    }
    return asset;
}

#pragma mark IWJMediaCache
-(AVPlayerItem*)getPlayerItem:(NSURL*)url {
    AVURLAsset *asset = [self getAssetWithUrl:url];
    if (asset) {
        return [AVPlayerItem playerItemWithAsset:asset];
    }
    return nil;
}

-(void)cancelLoading:(NSURL *)url {}


-(void)cleanAllCache {
    [_assetsCache removeAllObjects];
}

-(void)cleanCacheWithURL:(NSURL *)url {
    if (url) [_assetsCache removeObjectForKey:url.absoluteString];
}

-(unsigned long long)cachedSize {
    return 0;
}

@end
