//
//  BGNetWorkingJsonRPC.m
//  BGNetWorking
//
//  Created by 冉彬 on 2019/4/1.
//  Copyright © 2019 Bingle. All rights reserved.
//

#import "BGNetWorkingJsonRPC.h"

@implementation BGNetWorkingJsonRPC






/**
 Post请求
 
 @param URL URL
 @param param 参数字典
 @param completeBlock 完成后的回调block
 */
+(void)BG_postRequestWithURL:(NSURL *)URL param:(NSDictionary *)param completeBlock:(JsonRPCCompleteBlock)completeBlock
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSDictionary *headDic = @{
                              @"Content-Type": @"application/json"
                              };
    [self BG_startRequestWithURL:URL param:param outTime:10.0 cachePolicy:NSURLSessionTaskPriorityDefault requwstHead:headDic configuration:configuration completeBlock:completeBlock];
}






/**
 基本请求
 
 @param URL URL
 @param param 参数字典
 @param outTime 超时时间
 @param cachePolicy 缓存策略
 @param requwstHead 请求头
 @param configuration 配置（请求头，超时时间也可以在这里设置）
 @param completeBlock 完成请求
 */
+(void)BG_startRequestWithURL:(NSURL *)URL param:(NSDictionary *)param outTime:(NSTimeInterval)outTime cachePolicy:(NSURLRequestCachePolicy)cachePolicy requwstHead:(NSDictionary *)requwstHead configuration:(NSURLSessionConfiguration *)configuration completeBlock:(JsonRPCCompleteBlock)completeBlock
{
    // 创建Request请求
    NSMutableURLRequest *request;
    
    // 设置请求方法以及参数
    request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"POST"];
    // 参数配置
    NSString *paramStr = [NSString BGNet_jsonString:param];
    NSData *parameData = [paramStr dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:parameData];
    
    // 设置请求超时 默认超时时间60s
    [request setTimeoutInterval:outTime];
    
    //    // 设置头部参数
    //    [request addValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
    //    //或者下面这种方式 添加所有请求头信息
    request.allHTTPHeaderFields = requwstHead;
    
    //设置缓存策略
    [request setCachePolicy:cachePolicy];
    
    // 创建网络会话
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    // 创建会话任务
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        completeBlock(data, error);
    }];
    // 执行任务
    [task resume];
}

@end
