//
//  URLKeyViewController.m
//  Magnet
//
//  Created by zhangjing on 2017/10/22.
//  Copyright © 2017年 214644496@qq.com. All rights reserved.
//
#import "Ono.h"
#import "YYKit.h"
#import "DownHtml.h"
#import "RuleModel.h"
#import "URLKeyModel.h"
#import "URLKeyTableViewCell.h"
#import "URLKeyViewController.h"

@interface URLKeyViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong,nonatomic) NSMutableArray *listArray;
@end

@implementation URLKeyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[DownHtml downloader]downloadHtmlURLString:self.urlString progressBlock:^(NSProgress *downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, NSData *data) {
        [self.listArray addObjectsFromArray:[self resultAnalysis:data]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myTableView reloadData];
            
        });
    } failure:^(NSError *error) {
        
    }];
}
- (NSArray*)resultAnalysis:(NSData*)htmlData{
    
    NSMutableArray *resultArray = [NSMutableArray array];
    NSString *htmlString = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
    
    NSString * regulaStr = @"ed2k://.*.\\|\\/";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    
    NSArray *arrayOfAllMatches = [regex matchesInString:htmlString options:0 range:NSMakeRange(0, [htmlString length])];
    //如果电驴搜索不到结果就换磁力搜索
    if (arrayOfAllMatches.count == 0) {
        regulaStr = @"magnet:?[^\"]+";
        regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                          options:NSRegularExpressionCaseInsensitive
                                                            error:nil];
        
        arrayOfAllMatches = [regex matchesInString:htmlString options:0 range:NSMakeRange(0, [htmlString length])];
    }
    if (arrayOfAllMatches.count == 0) {
        
        NSLog(@"搜索不动任何结果");
        return resultArray;
    }
    for (NSTextCheckingResult *match in arrayOfAllMatches)
    {
        NSRange range = match.range;
        range.location = 1;
        NSString* substringForMatch = [htmlString substringWithRange:match.range];
        
        URLKeyModel *model = [URLKeyModel new];
        model.string = substringForMatch;
        
        [resultArray addObject:model];
    }
    
    return resultArray;
}
#pragma mark - TableView
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    CGFloat height = 40;
    
    return height;
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//
//    return self.tagView;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 65;
//}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdentifier = @"urlKeyCell";
    
    URLKeyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell)
    {
        
        cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    }
    URLKeyModel *model = self.listArray[indexPath.row];
    cell.model = model;
    cell.accessoryType = model.isSelect? UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    URLKeyModel *model = self.listArray[indexPath.row];
    model.isSelect = !model.isSelect;
    
    [tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationFade];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GET
- (NSMutableArray *)listArray{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

@end
