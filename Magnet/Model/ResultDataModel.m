//
//  movieModel.m
//  magnetX
//
//  Created by phlx-mac1 on 16/10/21.
//  Copyright © 2016年 214644496@qq.com. All rights reserved.
//

#import "ResultDataModel.h"

@implementation ResultDataModel
-(void)setName:(NSString *)name{
    if (name) {
        _name = [name stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }else{
        _name = @"";
    }
}
-(void)setMagnet:(NSString *)magnet{
    if (magnet) {
        _magnet = magnet;
    }else{
        _magnet = @"";
    }
}
-(void)setSize:(NSString *)size{
    if (size) {
        _size = size;
    }else{
        _size = @"";
    }
}
-(void)setCount:(NSString *)count{
    if (count) {
        _count = count;
    }else{
        _count = @"";
    }
}
- (void)setSource:(NSString *)source{
    if (source) {
        _source = source;
    }else{
        _source = @"";
    }
}

//==========================================================================================

+ (ResultDataModel*)entity:(ONOXMLElement *)element ruleModel:(RuleModel*)model{
    ResultDataModel*Model = [ResultDataModel new];
    NSString*firstMagnet = [element firstChildWithXPath:model.magnet].stringValue;
    if ([firstMagnet hasSuffix:@".html"]) {
        firstMagnet = [firstMagnet stringByReplacingOccurrencesOfString:@".html"withString:@""];
    }
    if ([firstMagnet componentsSeparatedByString:@"&"].count>1) {
        firstMagnet = [firstMagnet componentsSeparatedByString:@"&"][0];
    }
    NSString*magnet=[firstMagnet substringWithRange:NSMakeRange(firstMagnet.length-40,40)];
    Model.magnet = [NSString stringWithFormat:@"magnet:?xt=urn:btih:%@",magnet];
    Model.name = [[element firstChildWithXPath:model.name] stringValue];
    Model.size = [[element firstChildWithXPath:model.size] stringValue];
    Model.count = [[element firstChildWithXPath:model.count] stringValue];
    Model.source =model.site;
    return Model;
}

+ (NSArray*)HTMLDocumentWithData:(NSData*)data ruleModel:(RuleModel*)model{
    NSMutableArray*array = [NSMutableArray new];
    ONOXMLDocument *doc = [ONOXMLDocument HTMLDocumentWithData:data error:nil];
    [doc enumerateElementsWithXPath:model.group usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
        ResultDataModel*dataModel = [ResultDataModel entity:element ruleModel:model];
//        movie.source = url;
        [array addObject:dataModel];
    }];
    return array;
}





@end
