//
//  ViewController.m
//  Magnet
//
//  Created by zhangjing on 2017/10/20.
//  Copyright © 2017年 214644496@qq.com. All rights reserved.
//

#import "YYKit.h"
#import "DownHtml.h"
#import "RuleModel.h"
#import "CommonMacro.h"
#import <WebKit/WebKit.h>
#import "ResultDataModel.h"
#import "MainViewController.h"
#import "URLKeyViewController.h"
#import "BarTabViewController.h"
#import "CAPopUpViewController.h"
#import "KeywordsViewController.h"
#import "UserInfoModel.h"
#import "SVProgressHUD.h"


@interface MainViewController ()<WKUIDelegate,WKNavigationDelegate>
@property (weak, nonatomic) IBOutlet UITextField *keyTextField;

@property (nonatomic,strong) UserInfoModel * userInfo;



@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self willPasteboard];
    [self initNotification];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [SVProgressHUD dismiss];
}

#pragma mark - init

- (void)initNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willPasteboard)
                                                 name:kAppDidBecomeActiveNotification
                                               object:nil];
}

- (void)willPasteboard{
    
    if (!self || self.navigationController.topViewController!=self) {
        return;
    }
    
    UIPasteboard*pasteboard = [UIPasteboard generalPasteboard];
    if (pasteboard.URL) {
        [self popPasteboardMenu:@[pasteboard.URL.absoluteString]];
    }else if (pasteboard.string){
        [self popPasteboardMenu:@[pasteboard.string]];
    }

}

- (void)popPasteboardMenu:(NSArray*)op{
    dispatch_async(dispatch_get_main_queue(), ^{
        CAPopUpViewController *popup = [[CAPopUpViewController alloc] init];
        popup.itemsArray = op;
        popup.sourceView = self.keyTextField;
        popup.backgroundColor = [UIColor whiteColor];
        popup.backgroundImage = nil;
        popup.itemTitleColor = [UIColor blackColor];
        popup.itemSelectionColor = [UIColor lightGrayColor];
        popup.arrowDirections = UIPopoverArrowDirectionAny;
        popup.arrowColor = [UIColor whiteColor];
        @WEAKSELF(self);
        [popup setPopCellBlock:^(CAPopUpViewController *popupVC, UITableViewCell *popupCell, NSInteger row, NSInteger section) {
            selfWeak.keyTextField.text = op[row];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [popupVC dismissViewControllerAnimated:YES completion:^{
                    [selfWeak beginAction:nil];
                    
                }];
            });

        }];
        
        [self presentViewController:popup animated:YES completion:^{
            
        }];
        
    });
}



- (IBAction)beginAction:(id)sender {

    
    NSString *searchString = self.keyTextField.text;
    
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
    
    [self addHistoricalLogs:searchString];
}

- (void)addHistoricalLogs:(NSString*)str{
    if (!str) {
        return;
    }
    
    if (!self.userInfo.isSearchLogs) {
        [self.userInfo.searchLogsSet addObject:str];
        [self.userInfo save];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(nullable UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
     [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
#pragma mark - WKNavigationDelegate
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
//    NSLog(@"Commit");
}
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
//    NSLog(@"Start");
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
//    NSLog(@"Finish");
    NSString *jsToGetHTMLSource =  [self createGetHTMLJavaScript];
    
//    @WEAKSELF(self);
    [webView evaluateJavaScript:jsToGetHTMLSource completionHandler:^(id _Nullable HTMLSource, NSError * _Nullable error) {
        NSLog(@"web_Done");
//        [selfWeak reloadCollectionInHtml:HTMLSource inURL:selfWeak.web.URL.absoluteString];
//        [selfWeak.web removeFromSuperview];
    }];
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    
}
- (NSString*)createGetHTMLJavaScript{
    NSString *js = @"document.getElementsByTagName('html')[0].innerHTML";
    return js;
    
}

- (UserInfoModel *)userInfo{
    if (!_userInfo) {
        _userInfo = [UserInfoModel getUserInfoInstance];
    }
    return _userInfo;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
