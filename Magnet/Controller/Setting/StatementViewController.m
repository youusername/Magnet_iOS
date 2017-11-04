//
//  AffirmationViewController.m
//  Magnet
//
//  Created by zhangjing on 2017/11/1.
//  Copyright © 2017年 214644496@qq.com. All rights reserved.
//

#import "StatementViewController.h"

@interface StatementViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation StatementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString * jsonPath = [[NSBundle mainBundle] pathForResource:@"statement" ofType:@"json"];
    self.textView.text = [NSString stringWithContentsOfFile:jsonPath encoding:NSUTF8StringEncoding error:nil];
    
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
