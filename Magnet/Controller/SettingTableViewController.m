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
                    logsTable.logsArray = self.userInfo.searchLogsSet.allObjects;
                    [self.navigationController pushViewController:logsTable animated:YES];
                }
                    
                    break;
                case 1:{
//                    清除搜索记录
                }
                    
                    break;
                default:
                    break;
            }
        }
            
            break;
        case 1:{
            switch (indexPath.section) {
                case 0:{
//                    法律声明
                }
                    
                    break;
                case 1:{
//                    为APP评分
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
