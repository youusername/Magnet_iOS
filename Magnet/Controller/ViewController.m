//
//  ViewController.m
//  Magnet
//
//  Created by zhangjing on 2017/10/20.
//  Copyright © 2017年 214644496@qq.com. All rights reserved.
//

#import "ViewController.h"
#import "TagsScrollView.h"
#import "YYKit.h"
#import <WebKit/WebKit.h>
#import "DownHtml.h"

@interface ViewController ()<WKUIDelegate,WKNavigationDelegate>
@property (nonatomic,strong) WKWebView*web;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    TagsScrollView *tagView = [[TagsScrollView alloc]initWithFrame:CGRectMake(0, 100, kScreenWidth, 40)];
    [tagView loadTagScrollViewButton:@[@"asd",@"dsdw",@"fdwg",@"ferb",@"ebr",@"asd",@"dsdw",@"fdwg",@"ferb",@"ebr"]];
    [self.view addSubview:tagView];
    NSString *url = @"http://www.cilizhuzhu.org/torrent/%E6%88%91%E7%9A%84%E6%88%98%E4%BA%89.html";
    self.web =[[WKWebView alloc]initWithFrame:CGRectZero];
    self.web.UIDelegate = self;
    self.web.navigationDelegate = self;
    [self.web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
//    [self.view addSubview:self.web];
    [[DownHtml downloader] downloadHtmlURLString:url willStartBlock:^{
        
    } success:^(NSData*data) {
        NSLog(@"DownHtml_Done");

    } failure:^(NSError *error) {
        
    }];
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
