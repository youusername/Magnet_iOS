//
//  LocalSearchViewController.m
//  Magnet
//
//  Created by zhangjing on 2018/4/26.
//  Copyright © 2018年 214644496@qq.com. All rights reserved.
//

#import "LocalSearchViewController.h"
#import <YYKit/YYKit.h>
#import "ResultDataModel.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "KeywordsViewController.h"

#define kAllCollectData    @"allCollectData"

@interface LocalSearchViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@end

@implementation LocalSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)searchAction:(id)sender {
    
    if (self.nameTextField.text.length<1) {
        [SVProgressHUD showErrorWithStatus:@"关键字错误"];
        return;
    }
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kAllCollectData];
    
    NSArray *list  = [NSArray modelArrayWithClass:[ResultDataModel class] json:data];
    
    NSMutableArray *array = [NSMutableArray array];
    
    [list enumerateObjectsUsingBlock:^(ResultDataModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.name componentsSeparatedByString:self.nameTextField.text].count >= 2) {
            [array addObject:obj];
        }
    }];
    
    KeywordsViewController *allCollect = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"KeywordsViewController"];
    [allCollect showListArray:array];
    [self.navigationController pushViewController:allCollect animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
