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
#import "MJRefresh.h"

@interface KeywordsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (nonatomic,strong) NSMutableArray<ResultDataModel*> *listArray;
@property (nonatomic,strong) NSURLSessionDataTask *curTask;
@property (nonatomic,strong) NSMutableDictionary *dataDic;
//@property (nonatomic,assign) NSInteger onePageCount;
//@property (nonatomic,assign) NSInteger moreCount;
@property (nonatomic,assign) NSInteger page;
@end

@implementation KeywordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.onePageCount = 0;
//    self.moreCount  = 1;
    self.page = 1;
    self.myTableView.tableFooterView = [UIView new];
    [self initRefresh];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self loadDataForRule:self.curRuleModel];
}

- (void)initRefresh{
    self.myTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.page +=1;
        [self loadDataForRule:self.curRuleModel];
    }];
}

- (void)loadDataForRule:(RuleModel*)model{
    
    if (self.curTask) {
        [self.curTask suspend];
        self.curTask = nil;
    }
    NSString*beseURL = [model.source stringByReplacingOccurrencesOfString:@"XXX" withString:self.keyString];
    beseURL = [beseURL stringByReplacingOccurrencesOfString:@"PPP" withString:[NSString stringWithFormat:@"%ld",self.page]];
    NSString*url = [beseURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSString*key = [NSString stringWithFormat:@"%ld",url.hash];
    
    if ([self.dataDic objectForKey:key]) {
        self.listArray = self.dataDic[key];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myTableView reloadData];
            
        });
    }else{
    
        if (self.page ==1) {
            [SVProgressHUD show];
        }
        
        @WEAKSELF(self);
        self.curTask = [[DownHtml downloader]downloadHtmlURLString:url certificatesName:model.certificates progressBlock:^(NSProgress *downloadProgress) {
            
        } success:^(NSURLSessionDataTask * task,NSData *data) {
            if (task != selfWeak.curTask) {
                return ;
            }
            [SVProgressHUD dismiss];
            NSArray * array = [ResultDataModel HTMLDocumentWithData:data ruleModel:model];
            [selfWeak.listArray addObjectsFromArray:array];
            [selfWeak.dataDic setObject:selfWeak.listArray forKey:key];
            [selfWeak.myTableView.mj_footer endRefreshing];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (array.count == 0) {
                    selfWeak.myTableView.mj_footer.hidden = YES;
                }
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
    return self.listArray.count;
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
          
          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
              [SVProgressHUD dismiss];
              });
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
