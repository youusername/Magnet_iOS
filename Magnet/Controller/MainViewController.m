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
#import "MainViewController.h"
#import "URLKeyViewController.h"
#import "BarTabViewController.h"
#import "CAPopUpViewController.h"
#import "KeywordsViewController.h"
#import "TTGTextTagCollectionView.h"

@interface MainViewController ()<WKUIDelegate,WKNavigationDelegate>
@property (strong, nonatomic) LRTextField *keyTextField;

@property (nonatomic,strong) UserInfoModel * userInfo;
@property (weak, nonatomic) IBOutlet TTGTextTagCollectionView *tagView;



@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self willPasteboard];
    [self initNotification];
    [self showAffirmation];
    [self initTagView];
    [self initTextField];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [SVProgressHUD dismiss];
}

#pragma mark - init
- (void)initTextField{
    LRTextField *textFieldValidation = [[LRTextField alloc] initWithFrame:CGRectMake(15, 320, 260, 30) labelHeight:15];
    textFieldValidation.placeholder = @"输入关键字或者完整的URL";
    textFieldValidation.borderStyle = UITextBorderStyleNone;
    textFieldValidation.hintText = @"";
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, textFieldValidation.frame.size.height-1, textFieldValidation.frame.size.width, 0.5)];
    line.backgroundColor = [UIColor grayColor];
    [textFieldValidation addSubview:line];
    [textFieldValidation setValidationBlock:^NSDictionary *(LRTextField *textField, NSString *text) {
        [NSThread sleepForTimeInterval:1.0];
        if ([text isEqualToString:@"abc"]) {
            return @{ VALIDATION_INDICATOR_YES : @"Correct" };
        }
        return @{ VALIDATION_INDICATOR_NO : @"Error" };
    }];
    [self.view addSubview:textFieldValidation];
    self.keyTextField = textFieldValidation;
}

- (void)initTagView{
    NSArray *tags = @[@"AutoLayout", @"dynamically", @"calculates", @"the", @"size", @"and", @"position",
                      @"of", @"all", @"the", @"views", @"in", @"your", @"view", @"hierarchy", @"based",
                      @"on", @"constraints", @"placed", @"on", @"those", @"views", @"all", @"the", @"views", @"in", @"your", @"view", @"hierarchy", @"based",
                      @"on", @"constraints", @"placed", @"on", @"those", @"views"];
//    _tagView.clipsToBounds = NO;
    _tagView.numberOfLines = 4;
    _tagView.defaultConfig.tagShadowOffset = CGSizeMake(0, 0);
    _tagView.defaultConfig.tagBorderWidth = 0;
    _tagView.defaultConfig.tagSelectedBorderWidth = 0;
    _tagView.defaultConfig.tagCornerRadius = 3;
    _tagView.defaultConfig.tagTextFont = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
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
    NSString *str = @"《隐私协议和服务条款》\n【导言】\n欢迎您使用-磁力搜索APP！\n为使用磁力搜索服务，您应当阅读并遵守《磁力搜索使用条款和隐私政策协议》（以下简称“本协议”）。请您务必审慎阅读、充分理解各条款内容，特别是免除或限制责任的相应条款，以及开通或使用某项服务的单独协议，并选择接受或不接受。限制或免除责任条款可能以加粗形式提示您注意。\n除非您已阅读并接受本协议所有条款，否则您无权使用磁力搜索服务（以下简称“本服务”）。您对本服务的登录、查看、发布信息等使用行为即视为您已阅读并同意本协议的约束。\n如果您未满18周岁，请在法定监护人的陪同下阅读本协议，并特别注意未成年人使用条款\n一、【协议的范围】\n\n本协议是您与磁力搜索之间关于您使用磁力搜索服务所订立的协议。\n\n二、【用户行为规范】\n\n［信息内容规范］\n1. 本条所述信息内容是指用户使用本服务过程中所制作、复制、发布、传播 、偷拍的任何内容，包括但不限于磁力搜索功能的视频、图片、用户说明等注册信息及认证资料，或文字、语音、图片、视频、图文等发送、回复或自动回复消息和相关链接页面，以及其他使用本服务所产生的内容。\n2. 您理解并同意，磁力搜索一直致力于为用户提供便利的一款服务应用，您不得利用本服务制作、复制、发布、传播如下干扰磁力搜索 App正常运营，以及侵犯其他用户或第三方合法权益的内容：\n3. 发布、传送、传播、储存违反国家法律法规禁止的内容：\n（1）违反宪法确定的基本原则的；\n（2）危害国家安全，泄露国家秘密，颠覆国家政权，破坏国家统一的；\n（3）损害国家荣誉和利益的；\n（4）煽动民族仇恨、民族歧视，破坏民族团结的；\n（5）破坏国家宗教政策，宣扬邪教和封建迷信的；\n（6）散布谣言，扰乱社会秩序，破坏社会稳定的；\n（7）散布淫秽、色情、赌博、暴力、恐怖或者教唆犯罪的；\n（8）侮辱或者诽谤他人，侵害他人合法权益的；\n（9）煽动非法集会、结社、游行、示威、聚众扰乱社会秩序的；\n（10）以非法偷拍或摄像等不正当手段；\n（11）含有法律、行政法规禁止的其他内容的。\n\n发布、传送、传播、储存侵害他人名誉权、肖像权、知识产权、商业秘密等合法权利的内容；\n 涉及他人隐私、个人信息或资料的；\n发布、传送、传播骚扰信息、广告信息及垃圾信息或含有任何性暗示的；\n其他违反法律法规、政策及公序良俗、社会公德或干扰磁力搜索正常运营和侵犯其他用户或第三方合法权益内容的信息。\n九、【特别声明】\n\n磁力搜索APP搜索到的内容均来自各大磁力用户分享内容，非用户个人私有或者说隐私内容。本APP(磁力搜索)仅对分享内容做显示，任何涉及 用户登录、分享传播等行为都属于磁力站点，我们承诺不做任何钓鱼，获取私人信息等侵害用户行为。搜索内容最终解释权归原磁力所有。 本APP非人工检索方式，不代表本APP立场，本APP不对其真实合法性负责，亦不承担任何法律责任。\n 九、【投诉反馈】\n投诉邮箱：386935679@qq.com\nQQ:386935679";
    
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
