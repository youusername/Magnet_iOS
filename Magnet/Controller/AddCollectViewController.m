//
//  AddCollectViewController.m
//  Magnet
//
//  Created by zhangjing on 2018/4/25.
//  Copyright © 2018年 214644496@qq.com. All rights reserved.
//

#import "AddCollectViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "ResultDataModel.h"
#import <YYKit/YYKit.h>

#define kAllCollectData    @"allCollectData"

@interface AddCollectViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextView *magnetTextView;

@end

@implementation AddCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)addAction:(id)sender {
    if (self.nameTextField.text.length <= 1) {
        [SVProgressHUD showErrorWithStatus:@"备注名称太短"];
        return;
    }
    if (self.magnetTextView.text.length <= 40) {
        [SVProgressHUD showErrorWithStatus:@"磁力内容好像不对哦"];
        return;
    }
    
    ResultDataModel *newModel = [ResultDataModel new];
    newModel.name = self.nameTextField.text;
    newModel.magnet = self.magnetTextView.text;
    // 获取系统当前时间
    NSDate * date = [NSDate date];
    NSTimeInterval sec = [date timeIntervalSinceNow];
    NSDate * currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
    
    //设置时间输出格式：
    NSDateFormatter * df = [[NSDateFormatter alloc] init ];
    [df setDateFormat:@"yyyy.MM.dd HH:mm:ss"];
    NSString * na = [df stringFromDate:currentDate];
    newModel.count = na;
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kAllCollectData];
    NSArray *list  = [NSArray modelArrayWithClass:[ResultDataModel class] json:data];
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:list];
    [array addObject:newModel];
    
    [[NSUserDefaults standardUserDefaults] setObject:[array modelToJSONData] forKey:kAllCollectData];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.navigationController popViewControllerAnimated:YES];
    [SVProgressHUD showSuccessWithStatus:@"添加成功！"];
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
