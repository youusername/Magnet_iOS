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
#import "LRTextField.h"
#import "UserInfoModel.h"
#import "SVProgressHUD.h"
#import <WebKit/WebKit.h>
#import "ResultDataModel.h"
#import "WebViewController.h"
#import "MainViewController.h"
#import "URLKeyViewController.h"
#import "BarTabViewController.h"
#import "CAPopUpViewController.h"
#import "KeywordsViewController.h"
#import "TTGTextTagCollectionView.h"


@interface MainViewController ()<WKUIDelegate,WKNavigationDelegate,TTGTextTagCollectionViewDelegate>

@property (nonatomic,strong) UserInfoModel * userInfo;
@property (weak, nonatomic) IBOutlet TTGTextTagCollectionView *tagView;
@property (weak, nonatomic) IBOutlet UILabel *curLabel;
@property (weak, nonatomic) IBOutlet UITextField *keyTextField;
@property (nonatomic,assign) SiteType siteType;


@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self bingAction:nil];
    
    [self willPasteboard];
    [self initNotification];
    [self showAffirmation];
//    [self initTagView];
    [self initTextField];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [SVProgressHUD dismiss];
}

#pragma mark - init
- (void)initTextField{
    UITextField *textFieldValidation = self.keyTextField;;
    textFieldValidation.placeholder = @"输入关键字或者完整的URL";
    textFieldValidation.borderStyle = UITextBorderStyleNone;
//    textFieldValidation.hintText = @"";
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, textFieldValidation.frame.size.height-1, textFieldValidation.frame.size.width, 0.5)];
    line.backgroundColor = [UIColor grayColor];
    [textFieldValidation addSubview:line];

//    [self.view addSubview:textFieldValidation];
//    self.keyTextField = textFieldValidation;
}

- (void)initTagView{
    NSArray *tags = @[@"如何掌控你的自由时间",@"公开课", @"TED", @"文学",@"爱情应有的样子",@"数学", @"语言", @"社会", @"商业",
                      @"传媒", @"工程", @"心理", @"医学", @"历史", @"哲学", @"天文", @"政治"];
//    _tagView.clipsToBounds = NO;
    _tagView.numberOfLines = 4;
    _tagView.defaultConfig.tagShadowOffset = CGSizeMake(0, 0);
    _tagView.defaultConfig.tagBorderWidth = 0;
    _tagView.defaultConfig.tagSelectedBorderWidth = 0;
    _tagView.defaultConfig.tagCornerRadius = 3;
    _tagView.delegate = self;
    if (@available(iOS 8.2, *)) {
        _tagView.defaultConfig.tagTextFont = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
    } else {
        // Fallback on earlier versions
    }
    _tagView.scrollView.clipsToBounds = NO;
//    _tagView = [TTGTextTagCollectionView new];
    _tagView.alignment = TTGTagCollectionAlignmentFillByExpandingWidth;
    _tagView.layer.borderColor = [UIColor grayColor].CGColor;
//    _tagView.layer.borderWidth = 1;
    _tagView.translatesAutoresizingMaskIntoConstraints = NO;
//    [self.view addSubview:_tagView];
    
    NSArray *hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[tagView]-20-|"
                                                                    options:(NSLayoutFormatOptions) 0 metrics:nil
                                                                      views:@{@"tagView": _tagView}];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:_tagView
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.view
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1 constant:130];
    [self.view addConstraint:topConstraint];
    [self.view addConstraints:hConstraints];
    
    [_tagView addTags:tags];
    for (NSInteger i = 0; i < 5; i++) {
        [_tagView setTagAtIndex:arc4random_uniform((uint32_t)tags.count) selected:YES];
    }
    [_tagView reload];
}
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

//免责声明弹窗
- (void)showAffirmation{
    if (self.userInfo.isAffirmation) {
        return ;
    }
    NSString * jsonPath = [[NSBundle mainBundle] pathForResource:@"statement" ofType:@"json"];
    NSString *str = [NSString stringWithContentsOfFile:jsonPath encoding:NSUTF8StringEncoding error:nil];
    
    UIAlertController *alvCtrl = [UIAlertController alertControllerWithTitle:@"免责声明" message:str preferredStyle:UIAlertControllerStyleAlert];
    @WEAKSELF(self);
    [alvCtrl addAction:[UIAlertAction actionWithTitle:@"不同意" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [selfWeak showAffirmation];
    }]];
    [alvCtrl addAction:[UIAlertAction actionWithTitle:@"同意" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        selfWeak.userInfo.isAffirmation = YES;
        [selfWeak.userInfo save];
    }]];
    
    [self presentViewController:alvCtrl animated:YES completion:nil];
}

- (IBAction)beginAction:(id)sender {

    
    NSString *searchString = self.keyTextField.text;
    
    if (!searchString || [searchString isEqualToString:@""]) {
        NSLog(@"textField nil");
        return;
    }
    
    if (![searchString hasPrefix:@"1024"]) {
        
        WebViewController *web = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
        web.view.backgroundColor = [UIColor whiteColor];
        web.siteType = self.siteType;
        web.string = searchString;
        [self.navigationController pushViewController:web animated:YES];
        return;
    }
    
    
    NSString *regexString = @"http(s)?://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&=]*)?";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexString];
    BOOL isMatch = [pred evaluateWithObject:searchString];
    NSString * keyString =  [searchString stringByReplacingOccurrencesOfString:@"1024" withString:@""];
    if (isMatch) {
        URLKeyViewController * urlKeyVC = [self.storyboard instantiateViewControllerWithIdentifier:@"URLKeyViewController"];
        urlKeyVC.urlString = keyString;
        [self.navigationController pushViewController:urlKeyVC animated:YES];
    }else{
        BarTabViewController *barTabVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BarTabViewController"];
        barTabVC.keyString = keyString;
        [self.navigationController pushViewController:barTabVC animated:YES];

    }
    
    [self addHistoricalLogs:searchString];
}

- (void)addHistoricalLogs:(NSString*)str{
    if (!str) {
        return;
    }
    //先判断是否禁用历史记录
    if (!self.userInfo.isSearchLogs) {
        [self.userInfo.searchLogsSet addObject:str];
        [self.userInfo save];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(nullable UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
     [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (IBAction)googleAction:(id)sender {
    [self setCurLabelText:@"Google"];
    self.siteType = SiteTypeGoogle;
}
- (IBAction)bingAction:(id)sender {
    [self setCurLabelText:@"bing"];
    self.siteType = SiteTypeBing;
}
- (IBAction)sogouAction:(id)sender {
    [self setCurLabelText:@"sogou"];
    self.siteType = SiteTypeSogou;
}
- (IBAction)baiduAction:(id)sender {
    [self setCurLabelText:@"baidu"];
    self.siteType = SiteTypeBaidu;
}

- (void)setCurLabelText:(NSString*)str{
    self.curLabel.text = [NSString stringWithFormat:@"当前搜索站点:%@",str];
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
#pragma mark - TTGTextTagCollectionViewDelegate
- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView didTapTag:(NSString *)tagText atIndex:(NSUInteger)index selected:(BOOL)selected{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.keyTextField.text = tagText;

        [self beginAction:nil];
        
    });
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
