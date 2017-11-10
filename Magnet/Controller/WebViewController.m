//
//  WebViewController.m
//  Magnet
//
//  Created by zhangjing on 2017/11/6.
//  Copyright © 2017年 214644496@qq.com. All rights reserved.
//

#import "WebViewController.h"

#define curSite @"site:pan.baidu.com"

@interface WebViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *myWebView;
@property (weak, nonatomic) IBOutlet UIButton *boBackButton;
@property (weak, nonatomic) IBOutlet UIButton *goForwardButton;
@property (weak, nonatomic) IBOutlet UIButton *goHomeButton;

@property (nonatomic,strong) NSString * searchURL;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myWebView.delegate = self;
    

}

- (void)setSiteType:(SiteType)siteType{
    if (siteType) {
        _siteType = siteType;
        
        switch (siteType) {
            case SiteTypeGoogle:{
                self.searchURL = @"https://www.google.com/search?biw=1440&bih=733&ei=rS4AWt7ZKteYjwPzgJPwBw&q=-site-+-key-&oq=-site-+-key-";
            }
                
                break;
            case SiteTypeBaidu:{
                self.searchURL = @"";
            }
                
                break;
            case SiteTypeBing:{
                self.searchURL = @"http://cn.bing.com/search?q=-site-+-key-&qs=n&form=QBRE&sp=-1&pq=undefined&sc=0-22";
            }
                
                break;
            case SiteTypeSogou:{
                self.searchURL = @"https://www.sogou.com/web?query=-site-+-key-&ie=utf8";
            }
                
                break;
                
            default:
            {
            
                self.searchURL = @"";
            }
                break;
        }
    }
}

- (void)setString:(NSString *)string{
    if (string) {
        _string = string;
        
        NSURL * web_url;
        if (self.siteType != 0) {
        NSString *url = [self.searchURL stringByReplacingOccurrencesOfString:@"-site-" withString:curSite];
        url = [url stringByReplacingOccurrencesOfString:@"-key-" withString:string];
        
        NSString * urlStr = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        web_url = [NSURL URLWithString:urlStr];
        }else{
//            NSString * urlStr = [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
            web_url = [NSURL URLWithString:string];
        }
        
        [self.myWebView loadRequest:[NSURLRequest requestWithURL:web_url]];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    self.boBackButton.enabled = [self.myWebView canGoBack];
    self.goForwardButton.enabled = [self.myWebView canGoForward];
    
}
- (IBAction)goBack:(id)sender {
    [self.myWebView goBack];
}
- (IBAction)goForward:(id)sender {
    [self.myWebView goForward];
}
- (IBAction)goHome:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
