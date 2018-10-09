//
//  ListVideoViewController.m
//  WJPlayer
//
//  Created by Yunhai.Wu on 2018/9/13.
//  Copyright © 2018年 PN. All rights reserved.
//

#import "ListVideoViewController.h"
#import "SimpleVideoMedia.h"
#import "VideoTableViewCell.h"

@interface ListVideoViewController ()
@property(nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation ListVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"List Video";
    if (!_dataSource) {
        self.dataSource = [[NSMutableArray alloc] init];
        
        SimpleVideoMedia *m0 = [[SimpleVideoMedia alloc] init];
        [m0 setPosterUrl:[NSURL URLWithString:@"https://img.piaoniu.com/video/ea9ac5419b5e1930b685a98529436e9aef9c3575.jpg"]];
        [m0 setVideoUrl:[NSURL URLWithString:@"https://video.piaoniu.com/tweet/15348319108120791_trans.mp4"]];
        [self.dataSource addObject:m0];
        
        SimpleVideoMedia *m1 = [[SimpleVideoMedia alloc] init];
        [m1 setPosterUrl:[NSURL URLWithString:@"https://img.piaoniu.com/video/b503bdab8fdc509807c7ec39e7c5b052568fa52d.jpg"]];
        [m1 setVideoUrl:[NSURL URLWithString:@"https://video.piaoniu.com/tweet/15348204584767877_trans.mp4"]];
        [self.dataSource addObject:m1];
        
        SimpleVideoMedia *m2 = [[SimpleVideoMedia alloc] init];
        [m2 setPosterUrl:[NSURL URLWithString:@"https://img.piaoniu.com/video/efd5bc65da8e47802d0b1c798f16731afbd6e3c0.jpg"]];
        [m2 setVideoUrl:[NSURL URLWithString:@"https://video.piaoniu.com/tweet/15348210211634918_trans.mp4"]];
        [self.dataSource addObject:m2];
        
        SimpleVideoMedia *m3 = [[SimpleVideoMedia alloc] init];
        [m3 setPosterUrl:[NSURL URLWithString:@"https://img.piaoniu.com/video/c7df3a831317df49dc111ca253c8993f1b2e24b0.jpg"]];
        [m3 setVideoUrl:[NSURL URLWithString:@"https://video.piaoniu.com/tweet/15348217198298711_trans.mp4"]];
        [self.dataSource addObject:m3];
        
        SimpleVideoMedia *m4 = [[SimpleVideoMedia alloc] init];
        [m4 setPosterUrl:[NSURL URLWithString:@"https://img.piaoniu.com/video/fc734d9f66b5fb62c1ea6cf7aba65513f3e5e1fa.jpg"]];
        [m4 setVideoUrl:[NSURL URLWithString:@"https://video.piaoniu.com/tweet/15348221605437910_trans.mp4"]];
        [self.dataSource addObject:m4];
        
        SimpleVideoMedia *m5 = [[SimpleVideoMedia alloc] init];
        [m5 setPosterUrl:[NSURL URLWithString:@"https://img.piaoniu.com/video/6933133337ca225b3bea50ed318cf316af9f6f5c.jpg"]];
        [m5 setVideoUrl:[NSURL URLWithString:@"https://video.piaoniu.com/tweet/15348228538940033_trans.mp4"]];
        [self.dataSource addObject:m5];
        
        SimpleVideoMedia *m6 = [[SimpleVideoMedia alloc] init];
        [m6 setPosterUrl:[NSURL URLWithString:@"https://img.piaoniu.com/video/cb9181fe3d81b70478f4aed83c699f30aa7cc46f.jpg"]];
        [m6 setVideoUrl:[NSURL URLWithString:@"https://video.piaoniu.com/tweet/15348234381245062_trans.mp4"]];
        [self.dataSource addObject:m6];
        
        SimpleVideoMedia *m7 = [[SimpleVideoMedia alloc] init];
        [m7 setPosterUrl:[NSURL URLWithString:@"https://img.piaoniu.com/video/81b07bec0ccde1c203ffd6b5478ece92dc0bdd21.jpg"]];
        [m7 setVideoUrl:[NSURL URLWithString:@"https://video.piaoniu.com/tweet/15348241842388259_trans.mp4"]];
        [self.dataSource addObject:m7];
        
        SimpleVideoMedia *m8 = [[SimpleVideoMedia alloc] init];
        [m8 setPosterUrl:[NSURL URLWithString:@"https://img.piaoniu.com/video/7d0510d1d57530b213d128ca69fcf05957348e71.jpg"]];
        [m8 setVideoUrl:[NSURL URLWithString:@"https://video.piaoniu.com/tweet/15348312774778601_trans.mp4"]];
        [self.dataSource addObject:m8];
        
        SimpleVideoMedia *m9 = [[SimpleVideoMedia alloc] init];
        [m9 setPosterUrl:[NSURL URLWithString:@"https://img.piaoniu.com/video/62a1ba48baf9c47c1c3a34ac88850ed721f78706.jpg"]];
        [m9 setVideoUrl:[NSURL URLWithString:@"https://video.piaoniu.com/tweet/15348195669105099_trans.mp4"]];
        [self.dataSource addObject:m9];
        
        
        
        
        SimpleVideoMedia *m10 = [[SimpleVideoMedia alloc] init];
        [m10 setPosterUrl:[NSURL URLWithString:@"https://img.piaoniu.com/video/ea9ac5419b5e1930b685a98529436e9aef9c3575.jpg"]];
        [m10 setVideoUrl:[NSURL URLWithString:@"https://video.piaoniu.com/tweet/15348319108120791_trans.mp4"]];
        [self.dataSource addObject:m10];
        
        SimpleVideoMedia *m11 = [[SimpleVideoMedia alloc] init];
        [m11 setPosterUrl:[NSURL URLWithString:@"https://img.piaoniu.com/video/b503bdab8fdc509807c7ec39e7c5b052568fa52d.jpg"]];
        [m11 setVideoUrl:[NSURL URLWithString:@"https://video.piaoniu.com/tweet/15348204584767877_trans.mp4"]];
        [self.dataSource addObject:m11];
        
        SimpleVideoMedia *m12 = [[SimpleVideoMedia alloc] init];
        [m12 setPosterUrl:[NSURL URLWithString:@"https://img.piaoniu.com/video/efd5bc65da8e47802d0b1c798f16731afbd6e3c0.jpg"]];
        [m12 setVideoUrl:[NSURL URLWithString:@"https://video.piaoniu.com/tweet/15348210211634918_trans.mp4"]];
        [self.dataSource addObject:m12];
        
        SimpleVideoMedia *m13 = [[SimpleVideoMedia alloc] init];
        [m13 setPosterUrl:[NSURL URLWithString:@"https://img.piaoniu.com/video/c7df3a831317df49dc111ca253c8993f1b2e24b0.jpg"]];
        [m13 setVideoUrl:[NSURL URLWithString:@"https://video.piaoniu.com/tweet/15348217198298711_trans.mp4"]];
        [self.dataSource addObject:m13];
        
        SimpleVideoMedia *m14 = [[SimpleVideoMedia alloc] init];
        [m14 setPosterUrl:[NSURL URLWithString:@"https://img.piaoniu.com/video/fc734d9f66b5fb62c1ea6cf7aba65513f3e5e1fa.jpg"]];
        [m14 setVideoUrl:[NSURL URLWithString:@"https://video.piaoniu.com/tweet/15348221605437910_trans.mp4"]];
        [self.dataSource addObject:m14];
        
        SimpleVideoMedia *m15 = [[SimpleVideoMedia alloc] init];
        [m15 setPosterUrl:[NSURL URLWithString:@"https://img.piaoniu.com/video/6933133337ca225b3bea50ed318cf316af9f6f5c.jpg"]];
        [m15 setVideoUrl:[NSURL URLWithString:@"https://video.piaoniu.com/tweet/15348228538940033_trans.mp4"]];
        [self.dataSource addObject:m15];
        
        SimpleVideoMedia *m16 = [[SimpleVideoMedia alloc] init];
        [m16 setPosterUrl:[NSURL URLWithString:@"https://img.piaoniu.com/video/cb9181fe3d81b70478f4aed83c699f30aa7cc46f.jpg"]];
        [m16 setVideoUrl:[NSURL URLWithString:@"https://video.piaoniu.com/tweet/15348234381245062_trans.mp4"]];
        [self.dataSource addObject:m16];
        
        SimpleVideoMedia *m17 = [[SimpleVideoMedia alloc] init];
        [m17 setPosterUrl:[NSURL URLWithString:@"https://img.piaoniu.com/video/81b07bec0ccde1c203ffd6b5478ece92dc0bdd21.jpg"]];
        [m17 setVideoUrl:[NSURL URLWithString:@"https://video.piaoniu.com/tweet/15348241842388259_trans.mp4"]];
        [self.dataSource addObject:m17];
        
        SimpleVideoMedia *m18 = [[SimpleVideoMedia alloc] init];
        [m18 setPosterUrl:[NSURL URLWithString:@"https://img.piaoniu.com/video/7d0510d1d57530b213d128ca69fcf05957348e71.jpg"]];
        [m18 setVideoUrl:[NSURL URLWithString:@"https://video.piaoniu.com/tweet/15348312774778601_trans.mp4"]];
        [self.dataSource addObject:m18];
        
        SimpleVideoMedia *m19 = [[SimpleVideoMedia alloc] init];
        [m19 setPosterUrl:[NSURL URLWithString:@"https://img.piaoniu.com/video/62a1ba48baf9c47c1c3a34ac88850ed721f78706.jpg"]];
        [m19 setVideoUrl:[NSURL URLWithString:@"https://video.piaoniu.com/tweet/15348195669105099_trans.mp4"]];
        [self.dataSource addObject:m19];
        
    }
    
    [self.tableView registerClass:[VideoTableViewCell class] forCellReuseIdentifier:@"VideoTableViewCellReuseIdentifier"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataSource count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoTableViewCellReuseIdentifier"];
    [cell setData:_dataSource[indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UIScreen mainScreen].bounds.size.width * (9.0f/16.0f);
}

@end
