# WJLoggingAPI

日志组件统一API,目前所有组件全部支持WJLoggingAPI

### CocoaPods 安装
    pod WJLoggingAPI
    
### 要求
* ARC支持
* iOS 5.0+

### 使用方法

* 最好在App全局宏中导入： #import "WJLoggingAPI.h"

```objective-c

	WJLogError(frmt, ...);
	
	WJLogWarn(frmt, ...);
	
	WJLogInfo(frmt, ...)
	
	WJLogDebug(frmt, ...)
	
	WJLogVerbose(frmt, ...)
	
```

### 依赖实现

* 实现库创建类名：WJLoggerFactory 并实现接口 IWJLoggerFactory （日志工厂）
* 实现：IWJLogger 日志接口


### 备注

* error > warn > info > debug > verbose
