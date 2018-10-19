//
//  TimeStringFormatter.m
//  WJPlayerKit-example
//
//  Created by ada on 2018/10/19.
//  Copyright © 2018年 PN. All rights reserved.
//

#import "TimeStringFormatter.h"

@implementation TimeStringFormatter

+ (NSString *)formatTime:(int)seconds {
    int dMinutes = floor(seconds % 3600 / 60);
    int dSeconds = floor(seconds % 3600 % 60);
    if (seconds <= 0) {
        return @"00:00";
    } else {
        return [NSString stringWithFormat:@"%02i:%02i", dMinutes, dSeconds];
    }
}

@end
