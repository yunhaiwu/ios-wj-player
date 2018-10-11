//
//  SimpleVideoControlView.m
//  WJPlayer
//
//  Created by Yunhai.Wu on 2018/9/9.
//  Copyright © 2018年 PN. All rights reserved.
//

#import "SimpleVideoControlView.h"
#import "KVOController.h"
#import "ReactiveObjC.h"

@interface SimpleVideoControlView()

@property(nonatomic, weak) IBOutlet UISlider *slider;

@property(nonatomic, weak) IBOutlet UIButton *btn;

@property(nonatomic, weak) IBOutlet UILabel *lab;

-(IBAction)sliderChangeValue:(id)sender;

-(IBAction)sliderTouchUpInside:(id)sender;
-(IBAction)btnExec:(id)sender;

-(IBAction)replayExec:(id)sender;
-(IBAction)fullScreenExec:(id)sender;
@end

@implementation SimpleVideoControlView

-(void)fullScreenExec:(id)sender {
    [_delegate simpleVideoControlViewDidFullScreen:self];
}

-(void)sliderTouchUpInside:(id)sender {
    NSLog(@"TouchUpInside");
}

-(void)btnExec:(id)sender {
    if ([_player status] == WJPlayerStatusPlaying) {
        [_player pause];
    } else {
        [_player play];
    }
}

-(void)replayExec:(id)sender {
    [_player replay];
}

-(void)sliderChangeValue:(id)sender {
    if (![self.slider isTracking]) {
        int duration = [_player duration];
        int t = duration * _slider.value;
        NSLog(@"%i",t);
        [_player seekToTime:t];
    }
}

-(void)awakeFromNib {
    [super awakeFromNib];
    [self.slider setContinuous:NO];
}

-(void)setPlayer:(id<IWJPlayer>)player {
    if (_player == player || player == nil) return;
    [self.KVOController unobserveAll];
    _player = player;
    //添加观察者
    @weakify(self)
    [self.KVOController observe:_player keyPaths:@[@"status",@"duration",@"currentPlayTime",@"loadedTime"] options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        @strongify(self)
        int duration = [self.player duration];
        int currentTime = [self.player currentPlayTime];
        
        [self.lab setText:[NSString stringWithFormat:@"%i / %i",currentTime, duration]];
        
        if (self.player.status == WJPlayerStatusPlaying) {
            [self.btn setTitle:@"暂停" forState:UIControlStateNormal];
            [self.btn setHidden:NO];
        } else {
            [self.btn setTitle:@"播放" forState:UIControlStateNormal];
            [self.btn setHidden:NO];
        }
        if (![self.slider isTracking]) {
            float f = currentTime / (float)duration;
            [self.slider setValue:f animated:YES];
        }
    }];
}

+(instancetype)instance {
    SimpleVideoControlView *instance = nil;
    @try {
        NSString *className = NSStringFromClass(self);
        NSString *nibFile = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.nib",className]];
        NSString *iphoneNibFile = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@~iphone.nib",className]];
        NSString *ipadNibFile = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@~ipad.nib",className]];
        NSFileManager *fm = [NSFileManager defaultManager];
        if ([fm fileExistsAtPath:iphoneNibFile] || [fm fileExistsAtPath:nibFile] || [fm fileExistsAtPath:ipadNibFile]) {
            id o = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
            if ([o isKindOfClass:self]) {
                instance = o;
            }
        }
        if (!instance) {
            instance = [[self alloc] init];
        }
    }
    @catch (NSException *exception) {
        instance = [[self alloc] init];
    }
    return instance;
}

-(void)dealloc {
    NSLog(@"%@ dealloc ...",NSStringFromClass(self.class));
}

@end
