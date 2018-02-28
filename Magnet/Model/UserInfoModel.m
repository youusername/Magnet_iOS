//
//  UserInfoModel.m
//  Magnet
//
//  Created by zhangjing on 2017/10/31.
//  Copyright © 2017年 214644496@qq.com. All rights reserved.
//

#import "UserInfoModel.h"
#import "YYKit.h"
#import "CommonMacro.h"

static UserInfoModel*userInfo = nil;

@implementation UserInfoModel

+(UserInfoModel*)getUserInfoInstance{
    
    @synchronized(self){
        
        if(nil== userInfo){
            userInfo =[[UserInfoModel alloc] init];
             NSString * json = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsKey];
            if (json) {
                userInfo = [UserInfoModel modelWithJSON:json];
            }
            
        }
        return userInfo;
    }
    
}

- (void)save{
    NSString * json = [self modelToJSONString];
    [[NSUserDefaults standardUserDefaults] setObject:json forKey:kUserDefaultsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSMutableSet *)searchLogsSet{
    if (!_searchLogsSet) {
        _searchLogsSet = [NSMutableSet set];
    }
    return _searchLogsSet;
}
@end
