//
//  KeywordsViewController.m
//  Magnet
//
//  Created by zhangjing on 2017/10/21.
//  Copyright © 2017年 214644496@qq.com. All rights reserved.
//
#import "YYKit.h"
#import "DownHtml.h"
#import "RuleModel.h"
#import "KeywordsTableViewCell.h"
#import "KeywordsViewController.h"
#import "SVProgressHUD.h"
#import "CommonMacro.h"

@interface KeywordsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (nonatomic,strong) NSMutableArray<ResultDataModel*> *listArray;
@property (nonatomic,strong) NSURLSessionDataTask *curTask;
@property (nonatomic,strong) NSMutableDictionary *dataDic;
@property (nonatomic,assign) NSInteger onePageCount;
@property (nonatomic,assign) NSInteger moreCount;
@end

@implementation KeywordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.onePageCount = 0;
    self.moreCount  = 1;
    [self loadDataForRule:self.curRuleModel];
    self.myTableView.tableFooterView = [UIView new];
    
}

- (void)loadDataForRule:(RuleModel*)model{
    
    if (self.curTask) {
        [self.curTask suspend];
        self.curTask = nil;
    }
    NSString*beseURL = [model.source stringByReplacingOccurrencesOfString:@"XXX" withString:self.keyString];
    NSString*url = [beseURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSString*key = [NSString stringWithFormat:@"%ld",url.hash];
    
    if ([self.dataDic objectForKey:key]) {
        self.listArray = self.dataDic[key];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myTableView reloadData];
            
        });
    }else{
    
        [SVProgressHUD show];
        @WEAKSELF(self);
        self.curTask = [[DownHtml downloader]downloadHtmlURLString:url progressBlock:^(NSProgress *downloadProgress) {
            
        } success:^(NSURLSessionDataTask * task,NSData *data) {
            if (task != selfWeak.curTask) {
                return ;
            }
            [SVProgressHUD dismiss];
            NSArray * array = [ResultDataModel HTMLDocumentWithData:data ruleModel:model];
            [selfWeak.listArray addObjectsFromArray:array];
            if (selfWeak.onePageCount == 0) {
                selfWeak.onePageCount = array.count;
            }else{
                if (array.count == selfWeak.onePageCount) {
                    selfWeak.moreCount = 1;
                }else{
                    selfWeak.moreCount = 0;
                }
            }
            [selfWeak.dataDic setObject:selfWeak.listArray forKey:key];
            dispatch_async(dispatch_get_main_queue(), ^{
                [selfWeak.myTableView reloadData];
                
            });
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
            NSLog(@"down _ error");
            
        }];
    }
}



#pragma mark - TableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.listArray.count && self.listArray.count != 0) {
        return 48;
    }
    return 65;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count + self.moreCount;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdentifier = @"tableCell";
    if (indexPath.row == self.listArray.count && self.listArray.count != 0) {
        reuseIdentifier = @"moreDataCell";
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    }
    if ([reuseIdentifier isEqualToString:@"tableCell"]&& self.listArray.count != 0) {
        KeywordsTableViewCell *table_cell = (KeywordsTableViewCell *)cell;
        table_cell.model = self.listArray[indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
      if (indexPath.row == self.listArray.count && self.listArray.count != 0) {
          
      }else{
          ResultDataModel * result = self.listArray[indexPath.row];
          UIPasteboard*pasteboard = [UIPasteboard generalPasteboard];
          [pasteboard setString:result.magnet];
          [SVProgressHUD showSuccessWithStatus:@"复制成功!"];
      }
}

#pragma mark - GET

- (NSMutableArray<ResultDataModel *> *)listArray{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (NSMutableDictionary *)dataDic{
    if (!_dataDic) {
        _dataDic = [NSMutableDictionary dictionary];
    }
    return _dataDic;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc{
    NSLog(@"KeywordsViewController dealloc");
}

@end
