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
#import "UIScrollView+EmptyDataSet.h"
#import "UIColor+Hexadecimal.h"

@interface KeywordsViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (nonatomic,strong) NSMutableArray<ResultDataModel*> *listArray;
@property (nonatomic,strong) NSURLSessionDataTask *curTask;

@property (nonatomic,assign) BOOL isShouldDisplayNoData;
@property (nonatomic, getter=isLoading) BOOL loading;
@property (nonatomic,assign) NSInteger page;
@end

@implementation KeywordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.page = 1;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.myTableView.emptyDataSetSource = self;
    self.myTableView.emptyDataSetDelegate = self;
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
- (void)pullDownToRefresh{
    self.page = 1;
    [self.listArray removeAllObjects];
    [self loadDataForRule:self.curRuleModel];
}
- (void)loadDataForRule:(RuleModel*)model{
    
    if (self.curTask) {
        [self.curTask suspend];
        self.curTask = nil;
    }

    NSString*beseURL = [model.source stringByReplacingOccurrencesOfString:@"XXX" withString:self.keyString];
    beseURL = [beseURL stringByReplacingOccurrencesOfString:@"PPP" withString:[NSString stringWithFormat:@"%ld",self.page]];
    NSString*url = [beseURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    

        if (self.page ==1) {
//            [SVProgressHUD show];
        }
        
        @WEAKSELF(self);
        self.curTask = [[DownHtml downloader]downloadHtmlURLString:url certificatesName:model.certificates progressBlock:^(NSProgress *downloadProgress) {
            
        } success:^(NSURLSessionDataTask * task,NSData *data) {
            selfWeak.loading = NO;
            if (task != selfWeak.curTask) {
                return ;
            }
            [SVProgressHUD dismiss];
            
            NSArray * array = [ResultDataModel HTMLDocumentWithData:data ruleModel:model];
            [selfWeak.listArray addObjectsFromArray:array];
            [selfWeak.myTableView.mj_footer endRefreshing];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (array.count == 0) {
                    selfWeak.myTableView.mj_footer.hidden = YES;
                    selfWeak.isShouldDisplayNoData = YES;
                    [selfWeak.myTableView reloadEmptyDataSet];
                }
                [selfWeak.myTableView reloadData];
                
            });
        } failure:^(NSError *error) {
            selfWeak.isShouldDisplayNoData = YES;
            [selfWeak.myTableView reloadEmptyDataSet];
            selfWeak.loading = NO;
            [SVProgressHUD dismiss];
            NSLog(@"down _ error");
            
        }];
    
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc{
    NSLog(@"KeywordsViewController dealloc");
}
#pragma mark - DZNEmptyDataSetSource Methods

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = nil;
    UIFont *font = nil;
    UIColor *textColor = nil;
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    text = @"No Data";
    font = [UIFont fontWithName:@"IdealSans-Book-Pro" size:16.0];
    textColor = [UIColor colorWithHex:@"d9dce1"];
  
  
    
    if (!text) {
        return nil;
    }
    
    if (font) [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
 
    return nil;
 
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.isLoading) {
        return [UIImage imageNamed:@"loading_imgBlue_78x78"];
    }
    else {
        NSString *imageName = @"placeholder_vesper";
        
        return [UIImage imageNamed:imageName];
    }
}

- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0) ];
    animation.duration = 0.25;
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;
    
    return animation;
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
 
    return nil;

}


- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor colorWithHex:@"f8f8f8"];

}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return 0.0;
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    return 22.0;

}


#pragma mark - DZNEmptyDataSetDelegate Methods

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
//    空数据集应显示
    return self.isShouldDisplayNoData;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
//    空数据集应该允许触摸
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
//    空数据集应允许滚动
    return YES;
}

- (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView
{
//    空数据集应该生成图像视图
    return self.isLoading;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    self.loading = YES;
    
    [self pullDownToRefresh];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.loading = NO;
//    });
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
    self.loading = YES;
    
    [self pullDownToRefresh];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.loading = NO;
//    });
}
@end
