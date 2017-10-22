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
#import "TagsScrollView.h"
#import "KeywordsTableViewCell.h"
#import "KeywordsViewController.h"

@interface KeywordsViewController ()<TagsScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) RuleModel * curRuleModel;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic,strong) NSArray<RuleModel*> * ruleArray;
@property (nonatomic,strong) NSMutableArray<ResultDataModel*> *listArray;
@property (nonatomic,strong) TagsScrollView *tagView;
@property (nonatomic,strong) NSURLSessionDataTask *curTask;

@end

@implementation KeywordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.keyString;
    self.curRuleModel = self.ruleArray[0];
    [self loadDataForRule:self.curRuleModel];
    self.myTableView.tableFooterView = [UIView new];
}
- (void)initTagsScrollView{
    TagsScrollView *tagView = [[TagsScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    tagView.backgroundColor = [UIColor whiteColor];
    [tagView loadTagScrollViewButton:@[@"asd",@"dsdw",@"fdwg",@"ferb",@"ebr",@"asd",@"dsdw",@"fdwg",@"ferb",@"ebr"]];
    [self.view addSubview:tagView];
}

- (void)loadDataForRule:(RuleModel*)model{
    
    if (self.curTask) {
        [self.curTask suspend];
        self.curTask = nil;
    }
    NSString*beseURL = [model.source stringByReplacingOccurrencesOfString:@"XXX" withString:self.keyString];
    NSString*url = [beseURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    self.curTask = [[DownHtml downloader]downloadHtmlURLString:url progressBlock:^(NSProgress *downloadProgress) {
        
    } success:^(NSURLSessionDataTask * task,NSData *data) {
        if (task != self.curTask) {
            return ;
        }
        [self.listArray removeAllObjects];
        [self.listArray addObjectsFromArray:[ResultDataModel HTMLDocumentWithData:data ruleModel:model]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myTableView reloadData];
            
        });
    } failure:^(NSError *error) {
        
        NSLog(@"down _ error");
        
    }];
}

#pragma mark - TableView
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    CGFloat height = 40;
    
    return height;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    return self.tagView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
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

    KeywordsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell)
    {
        
        cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    }

    cell.model = self.listArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ResultDataModel * result = self.listArray[indexPath.row];
    UIPasteboard*pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:result.magnet];
}
#pragma mark - TagsScrollView Delegate
-(void)TagsScrollView:(TagsScrollView*)TagsScrollView didSelectTag:(NSInteger)index TagTitle:(NSString*)title{
    self.curRuleModel = self.ruleArray[index];

    [self loadDataForRule:self.curRuleModel];
}
#pragma mark - GET
- (TagsScrollView *)tagView{
    if (!_tagView) {
        NSMutableArray *tags = [NSMutableArray array];
        [self.ruleArray enumerateObjectsUsingBlock:^(RuleModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [tags addObject:obj.site];
        }];
        
        _tagView = [[TagsScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        _tagView.TagsDelegate = self;
        _tagView.backgroundColor = [UIColor whiteColor];
        [_tagView loadTagScrollViewButton:tags];
        
    }
    return _tagView;
}
- (NSMutableArray<ResultDataModel *> *)listArray{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}
- (NSArray<RuleModel *> *)ruleArray{
    if (!_ruleArray) {
        NSString * jsonPath = [[NSBundle mainBundle] pathForResource:@"rule" ofType:@"json"];
        NSData * jsonData = [NSData dataWithContentsOfFile:jsonPath];
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
        _ruleArray = [NSArray modelArrayWithClass:[RuleModel class] json:dic];
    }
    return _ruleArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
