//
//  KeywordsViewController.h
//  Magnet
//
//  Created by zhangjing on 2017/10/21.
//  Copyright © 2017年 214644496@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResultDataModel.h"

@interface KeywordsViewController : UIViewController

@property (nonatomic,strong) RuleModel * curRuleModel;
@property (nonatomic ,strong) NSString * keyString;
@property (nonatomic,assign) BOOL isEditing;

- (void)showAllCollectList;
- (void)showListArray:(NSMutableArray<ResultDataModel*> *)lisArray;
@end
