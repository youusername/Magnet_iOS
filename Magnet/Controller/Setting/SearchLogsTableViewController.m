//
//  SearchLogsTableViewController.m
//  Magnet
//
//  Created by zhangjing on 2017/10/31.
//  Copyright © 2017年 214644496@qq.com. All rights reserved.
//

#import "SearchLogsTableViewController.h"
#import "URLKeyViewController.h"
#import "BarTabViewController.h"


@interface SearchLogsTableViewController ()

@end

@implementation SearchLogsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
}
- (void)setUserInfo:(UserInfoModel *)userInfo{
    if (userInfo) {
        _userInfo = userInfo;
        [self.tableView reloadData];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.userInfo.searchLogsSet.allObjects.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * reuseIdentifier = @"logsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell)
    {
        
        cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    }
    UILabel *label = [cell.contentView viewWithTag:222];
    label.text = self.userInfo.searchLogsSet.allObjects[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *label = [cell.contentView viewWithTag:222];
    NSString *searchString = label.text;
    
    if (!searchString || [searchString isEqualToString:@""]) {
        NSLog(@"textField nil");
        return;
    }
    
    NSString *regexString = @"http(s)?://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&=]*)?";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexString];
    BOOL isMatch = [pred evaluateWithObject:searchString];
    
    if (isMatch) {
        URLKeyViewController * urlKeyVC = [self.storyboard instantiateViewControllerWithIdentifier:@"URLKeyViewController"];
        urlKeyVC.urlString = searchString;
        [self.navigationController pushViewController:urlKeyVC animated:YES];
    }else{
        BarTabViewController *barTabVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BarTabViewController"];
        barTabVC.keyString = searchString;
        [self.navigationController pushViewController:barTabVC animated:YES];
        
    }
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        UILabel *label = [cell.contentView viewWithTag:222];
        [self.userInfo.searchLogsSet removeObject:label.text];
        [self.userInfo save];
        [self.tableView reloadData];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
