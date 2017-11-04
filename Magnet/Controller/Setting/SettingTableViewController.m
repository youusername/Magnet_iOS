//
//  SettingTableViewController.m
//  Magnet
//
//  Created by zhangjing on 2017/10/31.
//  Copyright © 2017年 214644496@qq.com. All rights reserved.
//

#import "SettingTableViewController.h"
#import "UserInfoModel.h"
#import "SearchLogsTableViewController.h"
#import "CommonMacro.h"
#import "StatementViewController.h"
#import <StoreKit/StoreKit.h>

@interface SettingTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel * versionLabel;
@property (weak, nonatomic) IBOutlet UISwitch * searchSwitch;
@property (nonatomic,strong) UserInfoModel * userInfo;

@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.versionLabel.text = [NSString stringWithFormat:@"V %@  B %@",KBundleShortVersionString,KFBundleVersion];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadStat];
}
- (IBAction)switchAction:(UISwitch*)sender {
    self.userInfo.isSearchLogs = sender.on;
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.userInfo save];
}


- (void)reloadStat{
    self.searchSwitch.on = self.userInfo.isSearchLogs;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            switch (indexPath.row) {
                case 0:{
//                    搜索记录
                    SearchLogsTableViewController *logsTable = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchLogsTableViewController"];
                    logsTable.view.backgroundColor = [UIColor whiteColor];
                    logsTable.title = @"历史搜索";
                    logsTable.userInfo = self.userInfo;
                    [self.navigationController pushViewController:logsTable animated:YES];
                }
                    
                    break;
                case 1:{
//                    清除搜索记录
                    UIAlertController *alvCtrl = [UIAlertController alertControllerWithTitle:nil message:@"是否清除历史记录？" preferredStyle:UIAlertControllerStyleAlert];
                    @WEAKSELF(self);
                    [alvCtrl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }]];
                    [alvCtrl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        [selfWeak.userInfo.searchLogsSet removeAllObjects];
                        [selfWeak.userInfo save];
                    }]];
                    
                    [self presentViewController:alvCtrl animated:YES completion:nil];
                    
                }
                    
                    break;
                default:
                    break;
            }
        }
            
            break;
        case 1:{
            switch (indexPath.row) {
                case 0:{
//                    法律声明
                    
                    StatementViewController * aff = [self.storyboard instantiateViewControllerWithIdentifier:@"AffirmationViewController"];
                    [self.navigationController pushViewController:aff animated:YES];
                }
                    
                    break;
                case 1:{
//                    为APP评分
                    
                    static NSString *templateReviewURL = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1306575398";
                    static NSString *templateReviewURLiOS7 = @"itms-apps://itunes.apple.com/app/id1306575398";
                    static NSString *templateReviewURLiOS8 = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1306575398&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software";
                    
                    NSString *reviewURL = templateReviewURL;
                    // iOS 7 needs a different templateReviewURL @see https://github.com/arashpayan/appirater/issues/131
                    if (@available(iOS 10.3, *)) {
                        [SKStoreReviewController requestReview];
                    } else if (IOS_VERSION >= 7.0 && IOS_VERSION < 7.1) {
                        reviewURL = templateReviewURLiOS7;
                    }
                    // iOS 8 needs a different templateReviewURL also @see https://github.com/arashpayan/appirater/issues/182
                    else if (IOS_VERSION >= 8.0) {
                        reviewURL = templateReviewURLiOS8;
                    }
                    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:reviewURL]]) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:reviewURL]];
                    }


                }
                    
                    break;
                default:
                    break;
            }
        }
            
            break;
        default:
            break;
    }
}



#pragma mark - GET
- (UserInfoModel *)userInfo{
    if (!_userInfo) {
        _userInfo = [UserInfoModel getUserInfoInstance];
    }
    return _userInfo;
}

@end
