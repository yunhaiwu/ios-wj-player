//
//  VideoTableViewCell.h
//  WJPlayer
//
//  Created by Yunhai.Wu on 2018/9/10.
//  Copyright © 2018年 PN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimpleVideoMedia.h"
#import "WJPlayerView.h"

@interface VideoTableViewCell : UITableViewCell

@property(nonatomic, strong) SimpleVideoMedia *data;

@end
