//
//  EditListViewController.m
//  Magnet
//
//  Created by zhangjing on 2018/2/28.
//  Copyright © 2018年 214644496@qq.com. All rights reserved.
//

#import "EditListViewController.h"
#import "CommonMacro.h"
#import "YYKit.h"

@interface EditListViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation EditListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsJsonKey];
    
    if (!data) {
        NSString * jsonPath = [[NSBundle mainBundle] pathForResource:@"rule" ofType:@"json"];
        NSData * jsonData = [NSData dataWithContentsOfFile:jsonPath];
        [[NSUserDefaults standardUserDefaults] setObject:jsonData forKey:kUserDefaultsJsonKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        data = jsonData;
    }
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSString *json = [dic modelToJSONString];
    self.textView.text = json;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)etitDone:(id)sender {
    
    NSData *jsonData = [self.textView.text dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if (![NSJSONSerialization isValidJSONObject:dic]) {
        return;
    }

    if (jsonData) {
        [[NSUserDefaults standardUserDefaults] setObject:jsonData forKey:kUserDefaultsJsonKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }

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
