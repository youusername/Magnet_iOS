//
//  BarTabViewController.m
//  HJTabViewControllerDemo
//
//  Created by haijiao on 2017/3/18.
//  Copyright © 2017年 olinone. All rights reserved.
//

#import "BarTabViewController.h"
#import "YYKit.h"
#import "DownHtml.h"
#import "RuleModel.h"
#import "TagsScrollView.h"
#import "KeywordsTableViewCell.h"
#import "KeywordsViewController.h"
#import "SVProgressHUD.h"
#import "HJTabViewControllerPlugin_TabViewBar.h"
#import "CommonMacro.h"

@interface BarTabViewController () <HJTabViewControllerDataSource, HJTabViewControllerDelagate,TagsScrollViewDelegate>
@property (nonatomic,strong) NSArray<RuleModel*> * ruleArray;
@property (nonatomic,strong) TagsScrollView *tagView;
@end

@implementation BarTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTagsScrollView];
    self.tabDataSource = self;
    self.tabDelegate = self;
    
    self.title = self.keyString;
}
- (void)initTagsScrollView{
    
    [self.view addSubview:self.tagView];
}


#pragma mark -
- (void)tabViewController:(HJTabViewController *)tabViewController scrollViewDidScrollToIndex:(NSInteger)index{
    self.tagView.selectIndex = index;
}

- (NSInteger)numberOfViewControllerForTabViewController:(HJTabViewController *)tabViewController {
    return self.ruleArray.count;
}

- (UIViewController *)tabViewController:(HJTabViewController *)tabViewController viewControllerForIndex:(NSInteger)index {
    
    KeywordsViewController *keyVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"KeywordsViewController"];
    keyVC.keyString = self.keyString;
    keyVC.curRuleModel = self.ruleArray[index];
//    keyVC.view.frame = CGRectMake(0, 40, kScreenWidth, kScreenHeight);
    return keyVC;
}

- (UIEdgeInsets)containerInsetsForTabViewController:(HJTabViewController *)tabViewController {
//    return UIEdgeInsetsMake(CGRectGetMaxY(self.navigationController.navigationBar.frame), 0, 0, 0);
    return UIEdgeInsetsMake(self.tagView.frame.size.height+self.tagView.frame.origin.y, 0, 0, 0);
}

#pragma mark - TagsScrollView Delegate
-(void)TagsScrollView:(TagsScrollView*)TagsScrollView didSelectTag:(NSInteger)index TagTitle:(NSString*)title{
    BOOL anim = labs(index - self.curIndex) > 1 ? NO: YES;
    [self scrollToIndex:index animated:anim];
}
#pragma mark - GET
- (TagsScrollView *)tagView{
    if (!_tagView) {
        NSMutableArray *tags = [NSMutableArray array];
        [self.ruleArray enumerateObjectsUsingBlock:^(RuleModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [tags addObject:obj.site];
        }];
        
        CGRect StatusRect = [[UIApplication sharedApplication] statusBarFrame];
        CGRect NavRect = self.navigationController.navigationBar.frame;
        
        _tagView = [[TagsScrollView alloc]initWithFrame:CGRectMake(0,CGRectGetHeight(StatusRect)+CGRectGetHeight(NavRect), kScreenWidth, 40)];
        _tagView.TagsDelegate = self;
        _tagView.backgroundColor = [UIColor whiteColor];
        [_tagView loadTagScrollViewButton:tags];
        
    }
    return _tagView;
}
- (NSArray<RuleModel *> *)ruleArray{
    if (!_ruleArray) {
        NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsJsonKey];
        
        if (!data) {
            NSString * jsonPath = [[NSBundle mainBundle] pathForResource:@"rule" ofType:@"json"];
            NSData * jsonData = [NSData dataWithContentsOfFile:jsonPath];
            [[NSUserDefaults standardUserDefaults] setObject:jsonData forKey:kUserDefaultsJsonKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            data = jsonData;
        }
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        _ruleArray = [NSArray modelArrayWithClass:[RuleModel class] json:dic];
    }
    return _ruleArray;
}

@end
