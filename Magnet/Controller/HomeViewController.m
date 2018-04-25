//
//  HomeViewController.m
//  Magnet
//
//  Created by zhangjing on 2018/4/25.
//  Copyright © 2018年 214644496@qq.com. All rights reserved.
//

#import "HomeViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "SettingTableViewController.h"
#import "KeywordsViewController.h"
#import "ResultDataModel.h"
#import <YYKit/YYKit.h>

#define kAllCollectData    @"allCollectData"
#define KFBundleVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define KBundleShortVersionString [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIButton *networkSearchButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *localSearchButtonHeight;
@property (assign,nonatomic) BOOL isNetworkSearch;
@property (nonatomic,strong) NSMutableArray *listArray;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.listArray = [NSMutableArray array];
//    if (0) {
//        self.networkSearchButton.hidden = YES;
//        self.localSearchButtonHeight.constant = 70+73+8;
//    }else{
//        self.networkSearchButton.hidden = NO;
//        self.localSearchButtonHeight.constant = 70;
//    }
}

#pragma mark - IBAction

- (IBAction)allCollect:(id)sender {
    
    KeywordsViewController *allCollect = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"KeywordsViewController"];
    [allCollect showAllCollectList];
    [self.navigationController pushViewController:allCollect animated:YES];
}
- (IBAction)setting:(id)sender {
    SettingTableViewController *setting = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SettingTableViewController"];
    
    [self.navigationController pushViewController:setting animated:YES];
}
- (IBAction)localSearch:(id)sender {
}
- (IBAction)addCollect:(id)sender {
    [self performSegueWithIdentifier:@"homePushAdd" sender:nil];
}
- (IBAction)networkSearch:(id)sender {
    
    if (self.isNetworkSearch) {
        [self performSegueWithIdentifier:@"homePushMain" sender:nil];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!self.isNetworkSearch) {
        
            AFHTTPSessionManager * http = [AFHTTPSessionManager manager];
            [http POST:@"https://itunes.apple.com/lookup?id=1375299209" parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSArray *array = responseObject[@"results"];
                NSDictionary *dict = [array lastObject];
        
                NSString * shortV = KBundleShortVersionString;
//                if (dict == nil || [dict[@"version"] floatValue] <= [shortV floatValue]) {
//                    self.networkSearchButton.hidden = YES;
//                    self.localSearchButtonHeight.constant = 70+73+8;
//                    self.isNetworkSearch = NO;
//                }else{
                    self.networkSearchButton.hidden = NO;
                    self.localSearchButtonHeight.constant = 70;
                    self.isNetworkSearch = YES;
//                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
            }];
    }
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kAllCollectData];
    NSArray *list  = [NSArray modelArrayWithClass:[ResultDataModel class] json:data];
    if (list.count != self.listArray.count) {
        [self.listArray removeAllObjects];
        [self.listArray addObjectsFromArray:list];
        [self.myTableView reloadData];
    }
    
}
#pragma mark - TableView


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
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
    ResultDataModel *model = self.listArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",model.name];
//    if ([reuseIdentifier isEqualToString:@"tableCell"]&& self.listArray.count != 0) {
//        KeywordsTableViewCell *table_cell = (KeywordsTableViewCell *)cell;
//        table_cell.model = self.listArray[indexPath.row];
//    }
    
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
 
}
@end
