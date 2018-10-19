//
//  GaussianBlurPosterView.m
//  WJPlayerKit-example
//
//  Created by ada on 2018/10/18.
//  Copyright © 2018年 PN. All rights reserved.
//

#import "GaussianBlurPosterView.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "ReactiveObjC.h"

@interface GaussianBlurPosterView ()

@property(nonatomic, weak) UIImageView *posterImgView;

@property(nonatomic, weak) UIImageView *gaussianBlurImgView;

@end

@implementation GaussianBlurPosterView

- (void)setMedia:(id<IWJMedia>)media {
    if (_media == media) return;
    _media = media;
    if (_media) {
        UIImage *posterPlaceholder = nil;
        if ([_media respondsToSelector:@selector(posterPlaceholder)]) {
            posterPlaceholder = [_media posterPlaceholder];
        }
        [self.posterImgView setImage:nil];
        [self.gaussianBlurImgView setImage:nil];
        
        [self.posterImgView sd_setImageWithURL:[self.media posterURL] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            [self.posterImgView setImage:image];
            [self.gaussianBlurImgView setImage:image];
        }];
    } else {
        
        [_posterImgView setImage:nil];
        [_gaussianBlurImgView setImage:nil];
    }
}

- (void)loadSubviews {
    if (!_posterImgView) {
        UIImageView *gaussianBlurBg = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:gaussianBlurBg];
        [gaussianBlurBg setClipsToBounds:YES];
        [gaussianBlurBg setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [gaussianBlurBg setContentMode:UIViewContentModeScaleAspectFill];
        _gaussianBlurImgView = gaussianBlurBg;
        
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
        [effectview setFrame:gaussianBlurBg.bounds];
        [gaussianBlurBg addSubview:effectview];
        [effectview setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        
        UIImageView *poster = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:poster];
        [poster setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [poster setContentMode:UIViewContentModeScaleAspectFit];
        _posterImgView = poster;
    }
    [self setBackgroundColor:[UIColor blackColor]];
}

-(instancetype)init {
    self = [super init];
    if (self) {
        [self loadSubviews];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self loadSubviews];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadSubviews];
    }
    return self;
}

@end
