//
//  ViewController.m
//  Magnet
//
//  Created by zhangjing on 2017/10/20.
//  Copyright © 2017年 214644496@qq.com. All rights reserved.
//

#import "ViewController.h"
#import "TagsScrollView.h"
#import "YYKit.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    TagsScrollView *tagView = [[TagsScrollView alloc]initWithFrame:CGRectMake(0, 100, kScreenWidth, 40)];
    [tagView loadTagScrollViewButton:@[@"asd",@"dsdw",@"fdwg",@"ferb",@"ebr",@"asd",@"dsdw",@"fdwg",@"ferb",@"ebr"]];
    [self.view addSubview:tagView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
