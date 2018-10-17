//
//  WJConfig.m
//  WJConfig-example
//
//  Created by 吴云海 on 17/4/6.
//  Copyright © 2017年 wuyunhai. All rights reserved.
//

#import "WJConfig.h"
#import "WJLoggingAPI.h"

#define WJ_CONFIG_INFO_PLIST_KEY        @"WJConfigFile"
#define WJ_CONFIG_DEFAULT_FILE_NAME     @"application_config.plist"


#define WJ_CONFIG_INSTANCE              [WJConfig sharedInstance]

@interface WJConfig ()

@property(nonatomic, copy) NSDictionary *configValues;

@end


@implementation WJConfig

+ (id)objectForKey:(NSString*)key {
    if (!key || ![WJConfig sharedInstance].configValues) return nil;
    return [[WJConfig sharedInstance] configValues][key];
}

+ (NSString*)stringForKey:(NSString*)key {
    if (!key || ![[WJConfig sharedInstance] configValues]) return nil;
    id result = [[WJConfig sharedInstance] configValues][key];
    if (![result isKindOfClass:[NSString class]]) return nil;
    return (NSString*)result;
}

+ (NSInteger)integerForKey:(NSString*)key {
    if (!key || ![WJConfig sharedInstance].configValues) return 0;
    id result = [[WJConfig sharedInstance] configValues][key];
    if (![result isKindOfClass:[NSNumber class]]) return 0;
    return [(NSNumber*)result integerValue];
}

+ (BOOL)boolForKey:(NSString*)key {
    if (!key || ![WJConfig sharedInstance].configValues) return NO;
    id result = [[WJConfig sharedInstance] configValues][key];
    if (![result isKindOfClass:[NSNumber class]]) return NO;
    return [(NSNumber*)result boolValue];
}

+ (float)floatForKey:(NSString*)key {
    if (!key || ![WJConfig sharedInstance].configValues) return 0.0f;
    id result = [[WJConfig sharedInstance] configValues][key];
    if (![result isKindOfClass:[NSNumber class]]) return 0.0f;
    return [(NSNumber*)result floatValue];
}

+ (NSArray*)arrayForKey:(NSString*)key {
    if (!key || ![WJConfig sharedInstance].configValues) return nil;
    id result = [[WJConfig sharedInstance] configValues][key];
    if (![result isKindOfClass:[NSArray class]]) return nil;
    return (NSArray*)result;
}

+ (NSDictionary*)dictionaryForKey:(NSString*)key {
    if (!key || ![WJConfig sharedInstance].configValues) return nil;
    id result = [[WJConfig sharedInstance] configValues][key];
    if (![result isKindOfClass:[NSDictionary class]]) return nil;
    return (NSDictionary*)result;
}

-(NSString*)readConfigurationFile:(NSError**)error {
    NSString *fileName = [[NSBundle mainBundle] infoDictionary][WJ_CONFIG_INFO_PLIST_KEY];
    if (!fileName) fileName = WJ_CONFIG_DEFAULT_FILE_NAME;
    if (!fileName) {
        *error = [NSError errorWithDomain:@"WJConfigDomain" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"配置文件不存在！请按照文档配置:https://github.com/yunhaiwu/ios-wj-config"}];
        return nil;
    }
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[fileName componentsSeparatedByString:@"."][0] ofType:@"plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        *error = [NSError errorWithDomain:@"WJConfigDomain" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"配置文件不存在！请按照文档配置:https://github.com/yunhaiwu/ios-wj-config"}];
        return nil;
    }
    return filePath;
}

-(void)performInitialize {
    NSError *error = nil;
    NSString *configurationFilePath = [self readConfigurationFile:&error];
    if (error) {
        WJLogError([error userInfo][NSLocalizedDescriptionKey]);
        return;
    }
    @try {
        self.configValues = [[NSDictionary alloc] initWithContentsOfFile:configurationFilePath];
    } @catch (NSException *exception) {
        self.configValues = nil;
        WJLogDebug(@"配置文件错误！请按照文档配置:https://github.com/yunhaiwu/ios-wj-config");
    }
}

-(id)copy {
    return self;
}

-(id)mutableCopy {
    return self;
}

+(instancetype)sharedInstance {
    static dispatch_once_t once;
    static id s;
    dispatch_once( &once, ^{
        s = [[self alloc] init];
        [s performInitialize];
    });
    return s;
}

@end
