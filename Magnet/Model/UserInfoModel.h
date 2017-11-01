//
//  UserInfoModel.h
//  Magnet
//
//  Created by zhangjing on 2017/10/31.
//  Copyright © 2017年 214644496@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject

+ (UserInfoModel*)getUserInfoInstance;
- (void)save;

@property (nonatomic,strong) NSMutableSet *searchLogsSet;
///是否禁用历史记录
@property (nonatomic,assign) BOOL isSearchLogs;
//是否同意免责声明
@property (nonatomic,assign) BOOL isAffirmation;
@end
