# WJPlayer

媒体播放器

### CocoaPods 安装
	
	pod WJPlayerKit
	
	source:https://github.com/yunhaiwu/ios-wj-framework-cocoapods-specs.git

### 要求

* ARC支持
* iOS 7.0+


### 使用方法

```objc
WJPlayerView *playerView = [[WJPlayerView alloc] init];

SimpleVideoMedia *media = [[SimpleVideoMedia alloc] initWithVideoUrl:@"https://video.piaoniu.com/review/15244807024027823.mp4" posterUrl:nil];

[playerView setMedia:media autoPlay:YES];


//如果需要使用4G播放时需要询问，请在WJConfig中设置

WJPlayerKit:
    {
        "askPlayControlView":(String)配置流量播放时询问视图类名
        "playProgressCacheCount":(Number)缓存播放进度个数（默认为2，如果<=0不缓存，最大缓存200）
    }
    
注意：
askPlayControlView需要继承 AbstractAskPlayControlView类

```

### 
