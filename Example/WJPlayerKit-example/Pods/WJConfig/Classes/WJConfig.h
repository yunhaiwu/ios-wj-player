//
//  WJConfig.h
//  WJConfig-example
//
//  Created by 吴云海 on 17/4/6.
//  Copyright © 2017年 wuyunhai. All rights reserved.
//

#import <Foundation/Foundation.h>



#define WJ_CONFIG_OBJECT(K)         [WJConfig objectForKey:K]
#define WJ_CONFIG_STRING(K)         [WJConfig stringForKey:K]
#define WJ_CONFIG_INTEGER(K)        [WJConfig integerForKey:K]
#define WJ_CONFIG_BOOL(K)           [WJConfig boolForKey:K]
#define WJ_CONFIG_ARRAY(K)          [WJConfig arrayForKey:K]
#define WJ_CONFIG_DICTIONARY(K)     [WJConfig dictionaryForKey:K]

/**
 
 组件配置中心(无依赖配置模块，业务模块也可以使用)
 
 1、在应用程序中配置名字为 application_config.plist 文件
 
 2、如果需要自定义文件名称，请在info.plist 中配置文件名 key:WJConfigFile
 
 */
@interface WJConfig : NSObject


/**
 获取任意值
 @param key 配置名
 @return value
 */
+ (id)objectForKey:(NSString*)key;

/**
 获取字符串值
 @param key 配置名
 @return value
 */
+ (NSString*)stringForKey:(NSString*)key;


/**
 获取Integer值
 @param key 配置名
 @return value
 */
+ (NSInteger)integerForKey:(NSString*)key;

/**
 获取Bool值
 @param key 配置名
 @return value
 */
+ (BOOL)boolForKey:(NSString*)key;

/**
 获取Float值
 @param key 配置名
 @return value
 */
+ (float)floatForKey:(NSString*)key;

/**
 获取Array值
 @param key 配置名
 @return value
 */
+ (NSArray*)arrayForKey:(NSString*)key;

/**
 获取Dictionary值
 @param key 配置名
 @return value
 */
+ (NSDictionary*)dictionaryForKey:(NSString*)key;

@end
