# WJConfig

    组建配置库，配置简单、无任何耦合

### CocoaPods 安装

    source：https://github.com/yunhaiwu/ios-wj-framework-cocoapods-specs.git

    pod WJConfig

### 要求
* ARC支持
* iOS 5.0+

### 使用方法
```
方法A:

1、在工程中添加一个plist配置文件，例如：a.plist

2、在info.list配置文件中添加 key：WJConfigFile   val:a.plist

```

```
方法B：

1、在工程中直接添加一个 application_config.plist 文件，配置库会自动找这个配置文件，就无需在info.plist中添加WJConfigFile key。

```




