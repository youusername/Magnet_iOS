//
//  breakDownHtml.m
//  magnetX
//
//  Created by phlx-mac1 on 16/10/21.
//  Copyright © 2016年 214644496@qq.com. All rights reserved.
//

#import "DownHtml.h"
#import "Ono.h"
#import "AFHTTPSessionManager.h"

@implementation DownHtml
+ (DownHtml *)downloader{
    static DownHtml *downHtml = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        downHtml = [[DownHtml alloc] init];
    });
    return downHtml;
}
- (NSURLSessionDataTask *)downloadHtmlURLString:(NSString *)urlString certificatesName:(NSString*)certificates progressBlock:(void(^)(NSProgress * downloadProgress)) progress success:(void(^)(NSURLSessionDataTask * _Nonnull task,NSData*data)) successHandler failure:(void(^)(NSError *error)) failureHandler{
//    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
//    NSURLSession * session = [NSURLSession sharedSession];
//    NSURLSessionDataTask * dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        dispatch_async(dispatch_queue_create("download html queue", nil), ^{
//            NSMutableArray*array = [NSMutableArray new];
//            ONOXMLDocument *doc = [ONOXMLDocument HTMLDocumentWithData:data error:nil];
//            [doc enumerateElementsWithXPath:selectSideRule.group usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
//                movieModel*movie = [movieModel entity:element];
//                movie.source = urlString;
//                [array addObject:movie];
//            }];
//            if (successHandler) {
//                successHandler(array);
//            }
//        });
//    }];
//    [dataTask resume];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    if (certificates && ![certificates isEqualToString:@""]) {
        
        manager.securityPolicy=[DownHtml policy:certificates];
    }
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json", nil];
    manager.requestSerializer.timeoutInterval = 5;
    return [manager GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            progress(downloadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        dispatch_async(dispatch_queue_create("download html queue", nil), ^{
            
            if (successHandler) {
                successHandler(task,responseObject);
            }
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureHandler) {
            failureHandler(error);
        }
    }];
}

+ (AFSecurityPolicy *)policy:(NSString*)certificates{
    NSArray *cerArray = [certificates componentsSeparatedByString:@"."];
    //根证书路径
    NSString * path = [[NSBundle mainBundle] pathForResource:cerArray[0] ofType:cerArray[1]];
    //
    NSData * cerData = [NSData dataWithContentsOfFile:path];
    //
    NSSet * dataSet = [NSSet setWithObject:cerData];
    //AFNetworking验证证书的object,AFSSLPinningModeCertificate参数决定了验证证书的方式
    AFSecurityPolicy * policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:dataSet];
    //是否可以使用自建证书（不花钱的）
    policy.allowInvalidCertificates=YES;
    //是否验证域名（一般不验证）
    policy.validatesDomainName=NO;
    return policy;
}

@end
