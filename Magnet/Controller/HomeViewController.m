//
//  HomeViewController.m
//  Magnet
//
//  Created by zhangjing on 2018/4/25.
//  Copyright © 2018年 214644496@qq.com. All rights reserved.
//

#import "HomeViewController.h"
#import <AFNetworking/AFNetworking.h>

#define KFBundleVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define KBundleShortVersionString [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIButton *networkSearchButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *localSearchButtonHeight;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (0) {
        self.networkSearchButton.hidden = YES;
        self.localSearchButtonHeight.constant = 70+73+8;
    }else{
        self.networkSearchButton.hidden = NO;
        self.localSearchButtonHeight.constant = 70;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
//    AFHTTPSessionManager * http = [AFHTTPSessionManager manager];
//    [http POST:@"https://itunes.apple.com/lookup?id=1375299209" parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSArray *array = responseObject[@"results"];
//        NSDictionary *dict = [array lastObject];

//        NSString * shortV = KBundleShortVersionString;
//        if (dict == nil || [dict[@"version"] floatValue] <= [shortV floatValue]) {
//            self.networkSearchButton.hidden = YES;
//            self.localSearchButtonHeight.constant = 70+73+8;
//        }else{
//            self.networkSearchButton.hidden = NO;
//            self.localSearchButtonHeight.constant = 70;
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//    }];
}
#pragma mark - TableView


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdentifier = @"tableCell";
//    if (indexPath.row == self.listArray.count && self.listArray.count != 0) {
//        reuseIdentifier = @"moreDataCell";
//    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"row %ld",indexPath.row];
//    if ([reuseIdentifier isEqualToString:@"tableCell"]&& self.listArray.count != 0) {
//        KeywordsTableViewCell *table_cell = (KeywordsTableViewCell *)cell;
//        table_cell.model = self.listArray[indexPath.row];
//    }
    
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
 
}
@end
