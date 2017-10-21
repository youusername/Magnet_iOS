//
//  movieModel.h
//  magnetX
//
//  Created by phlx-mac1 on 16/10/21.
//  Copyright © 2016年 214644496@qq.com. All rights reserved.
//

#import "Ono.h"
#import "RuleModel.h"
#import <Foundation/Foundation.h>


@interface ResultDataModel : NSObject

@property (nonatomic,strong)NSString* name;
@property (nonatomic,strong)NSString* size;
@property (nonatomic,strong)NSString* count;
@property (nonatomic,strong)NSString* source;
@property (nonatomic,strong)NSString* magnet;

+ (ResultDataModel*)entity:(ONOXMLElement *)element ruleModel:(RuleModel*)model;
+ (NSArray<ResultDataModel*>*)HTMLDocumentWithData:(NSData*)data ruleModel:(RuleModel*)model;
@end
