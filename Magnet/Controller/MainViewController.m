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
#import "SSZipArchive.h"
#import "UserInfoModel.h"
#import <objc/message.h>
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



@interface MainViewController ()<WKUIDelegate,WKNavigationDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UserInfoModel * userInfo;
@property (weak, nonatomic) IBOutlet UILabel *curLabel;
@property (weak, nonatomic) IBOutlet UITextField *keyTextField;
@property (nonatomic,assign) SiteType siteType;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (nonatomic,strong) NSMutableArray<Class>*viewControllers;
@property (nonatomic,strong) NSMutableDictionary * dataDic;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.viewControllers = [@[[WebViewController class],[URLKeyViewController class],[BarTabViewController class],[UIViewController class],[UINavigationController class]] mutableCopy];
    
    
    [self bingAction:nil];
    
    [self willPasteboard];
    [self initNotification];
    [self showAffirmation];

    [self initTextField];
    
    [self downJson];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [SVProgressHUD dismiss];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger number = 0;
    if (self.dataDic[@"present"]) {
        NSArray *array = self.dataDic[@"present"];
        number = array.count;
    }
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdentifier = @"cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    }
    
    NSArray *array = self.dataDic[@"present"];
    NSDictionary *dic = array[indexPath.row];
    if (array&&dic) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ 介绍",dic[@"name"]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *array = self.dataDic[@"present"];
    NSDictionary *dic = array[indexPath.row];
    WebViewController *web = [self.storyboard instantiateViewControllerWithIdentifier:[self.viewControllers[0] className]];
    
    web.view.backgroundColor = [UIColor whiteColor];
    web.siteType = 0;
    web.string = dic[@"url"];
    web.title = dic[@"name"];
    [self.navigationController pushViewController:web animated:YES];
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
    
//    if (![searchString hasPrefix:@"1024"]) {
//
//
//        WebViewController *web = [self.storyboard instantiateViewControllerWithIdentifier:[self.viewControllers[0] className]];
//
//        web.view.backgroundColor = [UIColor whiteColor];
//        web.siteType = self.siteType;
//        web.string = searchString;
//        [self.navigationController pushViewController:web animated:YES];
//        return;
//    }
    
    NSString *regexString = @"http(s)?://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&=]*)?";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexString];
    BOOL isMatch = [pred evaluateWithObject:searchString];
    NSString * keyString =  [searchString stringByReplacingOccurrencesOfString:@"1024" withString:@""];
    if (isMatch) {
        UIViewController *urlKeyVC = [self.storyboard instantiateViewControllerWithIdentifier:[self.viewControllers[1] className]];
        [urlKeyVC setValue:keyString forKey:@"urlString"];
        [self.navigationController pushViewController:urlKeyVC animated:YES];
    }else{
        UIViewController *barTabVC = [self.storyboard instantiateViewControllerWithIdentifier:[self.viewControllers[2] className]];
        [barTabVC setValue:keyString forKey:@"keyString"];
        [self.navigationController pushViewController:barTabVC animated:YES];

    }
    
    [self addHistoricalLogs:searchString];
}
- (BOOL)unZip:(NSString *)docPath {
    return [SSZipArchive unzipFileAtPath:[docPath stringByAppendingString:@"/rule.zip"] toDestination:[docPath stringByAppendingString:@"/"] progressHandler:^(NSString * _Nonnull entry, unz_file_info zipInfo, long entryNumber, long total) {
        //                NSLog(@"entry %@",entry);
        
    } completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nonnull error) {
        
        //                NSLog(@"path %@",path);
        if (succeeded) {
            NSString *pathStr = [docPath stringByAppendingPathComponent:@"/rule-master/magnetRule.json"];
            NSData *data = [NSData dataWithContentsOfFile:pathStr];
            self.dataDic = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil] mutableCopy];
            
            NSString*vStr = KBundleShortVersionString;
            NSString*vData= self.dataDic[@"v"];
            NSArray *v_arry =[vStr componentsSeparatedByString:@"."];
            NSInteger vStrInt =(([v_arry[0] integerValue]*100)+[v_arry[1] integerValue]*10+[v_arry[2] integerValue]);
            v_arry =[vData componentsSeparatedByString:@"."];
            NSInteger vDataInt =(([v_arry[0] integerValue]*100)+[v_arry[1] integerValue]*10+[v_arry[2] integerValue]);
            NSString*bStr = KFBundleVersion;
            NSString*bData= self.dataDic[@"b"];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [SVProgressHUD dismiss];
            });
            
            if (vDataInt>=vStrInt) {
                if ([bData doubleValue]<[bStr doubleValue]) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        
                        [self.myTableView reloadData];
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        self.myTableView.hidden = YES;
                    });
                }
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.myTableView reloadData];
                    
                });
            }
        }
    }];
}

- (void)downJson{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [SVProgressHUD show];
    });
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[docPath stringByAppendingString:@"/rule-master"]]) {
        
        [[NSFileManager defaultManager]removeItemAtPath:[docPath stringByAppendingString:@"/rule-master"] error:nil];
        
        [self unZip:docPath];
    }else{
        NSURL*url = [NSURL URLWithString:MagnetUpdateRuleURL];
        NSURLRequest * request = [NSURLRequest requestWithURL:url];
        NSURLSession * session = [NSURLSession sharedSession];
        NSURLSessionDataTask * dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            [data writeToFile:[docPath stringByAppendingString:@"/rule.zip"] atomically:YES ];
            
            [[NSFileManager defaultManager]removeItemAtPath:[docPath stringByAppendingString:@"/rule-master"] error:nil];
            
            [self unZip:docPath];
            
        }];
        [dataTask resume];
        
    }
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
