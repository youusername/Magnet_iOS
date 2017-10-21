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
#import <WebKit/WebKit.h>

#import "ResultDataModel.h"
#import "MainViewController.h"
#import "KeywordsViewController.h"

@interface MainViewController ()<WKUIDelegate,WKNavigationDelegate>
@property (weak, nonatomic) IBOutlet UITextField *keyTextField;




@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

 
}

#pragma mark - init





- (IBAction)beginAction:(id)sender {
    
    NSString *searchString = self.keyTextField.text;
    
    if (!searchString || [searchString isEqualToString:@""]) {
        NSLog(@"textField nil");
        return;
    }
    
    NSString *regexString = @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexString];
    BOOL isMatch = [pred evaluateWithObject:searchString];
    
    if (isMatch) {
     
    }else{
        
        KeywordsViewController *keyVC = [self.storyboard instantiateViewControllerWithIdentifier:@"KeywordsViewController"];
        keyVC.keyString = searchString;
        [self.navigationController pushViewController:keyVC animated:YES];
        
    }
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
