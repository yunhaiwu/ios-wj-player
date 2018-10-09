//
//  RootViewController.m
//  WJPlayer
//
//  Created by Yunhai.Wu on 2018/9/13.
//  Copyright © 2018年 PN. All rights reserved.
//

#import "RootViewController.h"
#import "ListVideoViewController.h"
#import "SimpleVideoViewController.h"
#import "AudioPlayViewController.h"
//#import "TaskViewController.h"

@interface RootViewController ()

@property(nonatomic, copy) NSDictionary *dataSource;
@property(nonatomic, copy) NSArray *keys;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Video Demos";
    self.dataSource = @{
                        @"Simple Video":@"SimpleVideoViewController",
                        @"List Video":@"ListVideoViewController",
                        @"Simple Audio":@"AudioPlayViewController"
//                        @"Task":@"TaskViewController"
                        };
    self.keys = [self.dataSource allKeys];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_keys count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kCellIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kCellIdentifier"];
    }
    [[cell textLabel] setText:_keys[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *vcName = _dataSource[_keys[indexPath.row]];
    UIViewController *vc = [[NSClassFromString(vcName) alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
