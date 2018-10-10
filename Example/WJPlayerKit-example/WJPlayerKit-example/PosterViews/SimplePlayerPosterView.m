//
//  SimplePlayerPosterView.m
//  WJPlayer
//
//  Created by Yunhai.Wu on 2018/9/13.
//  Copyright © 2018年 PN. All rights reserved.
//

#import "SimplePlayerPosterView.h"

@interface SimplePlayerPosterView()

@property(nonatomic, weak) UIImageView *posterImgView;

@end

@implementation SimplePlayerPosterView

- (void)setMedia:(id<IWJMedia>)media {
    if (_media == media) return;
    _media = media;
}

- (void)loadSubviews {
    if (!_posterImgView) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:imgView];
        [imgView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [imgView setContentMode:UIViewContentModeScaleAspectFit];
        _posterImgView = imgView;
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
