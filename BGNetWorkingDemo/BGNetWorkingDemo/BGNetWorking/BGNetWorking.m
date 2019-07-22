//
//  BGNetWorking.m
//  BGNSURLSessionProject
//
//  Created by 冉彬 on 2018/9/25.
//  Copyright © 2018年 Binge. All rights reserved.
//

#import "BGNetWorking.h"

@interface BGNetWorking ()



@end



//定义一个变量
static BGNetWorking *netWork = nil;

@implementation BGNetWorking
//实例化对象
+ (instancetype)shareHelper
{
    @synchronized(self) {
        if (!netWork) {
            netWork = [[BGNetWorking alloc] init];
        }
        return netWork;
    }
}

/**
 Get请求

 @param URL URL
 @param param 参数字典
 @param completeBlock 完成后的回调block
 */
+(void)BG_getRequestWithURL:(NSURL *)URL param:(NSDictionary *)param completeBlock:(CompleteBlock)completeBlock
{
    [self BG_requestWithURL:URL type:BGRequestTypeGet param:param completeBlock:completeBlock];
}


/**
 Post请求
 
 @param URL URL
 @param param 参数字典
 @param completeBlock 完成后的回调block
 */
+(void)BG_postRequestWithURL:(NSURL *)URL param:(NSDictionary *)param completeBlock:(CompleteBlock)completeBlock
{
    [self BG_requestWithURL:URL type:BGRequestTypePost param:param completeBlock:completeBlock];
}


/**
 Get请求（带请求头）
 
 @param URL URL
 @param param 参数字典
 @param head 请求头
 @param completeBlock 完成后的回调block
 */
+(void)BG_getRequestWithURL:(NSURL *)URL param:(NSDictionary *)param head:(NSDictionary *)head completeBlock:(CompleteBlock)completeBlock
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    [self BG_startRequestWithURL:URL param:param type:BGRequestTypeGet outTime:10.0 cachePolicy:NSURLRequestUseProtocolCachePolicy requwstHead:head configuration:configuration completeBlock:completeBlock];
}


/**
 Post请求（带请求头）
 
 @param URL URL
 @param param 参数字典
 @param head 请求头
 @param completeBlock 完成后的回调block
 */
+(void)BG_postRequestWithURL:(NSURL *)URL param:(NSDictionary *)param head:(NSDictionary *)head completeBlock:(CompleteBlock)completeBlock
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    [self BG_startRequestWithURL:URL param:param type:BGRequestTypePost outTime:10.0 cachePolicy:NSURLRequestUseProtocolCachePolicy requwstHead:head configuration:configuration completeBlock:completeBlock];
}


/**
 请求
 
 @param URL URL
 @param type 类型（Get Post）
 @param param 参数字典
 @param completeBlock 完成后的回调block
 */
+(void)BG_requestWithURL:(NSURL *)URL type:(BGRequestType)type param:(NSDictionary *)param completeBlock:(CompleteBlock)completeBlock
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSDictionary *headDic = @{
//                              @"Authorization": tStr,
//                              @"Content-Type": @"application/json"
                              };
    [self BG_startRequestWithURL:URL param:param type:type outTime:10.0 cachePolicy:NSURLRequestUseProtocolCachePolicy requwstHead:headDic configuration:configuration completeBlock:completeBlock];
}







/**
 基本请求
 
 @param URL URL
 @param param 参数字典
 @param type 类型（Get Post）
 @param outTime 超时时间
 @param cachePolicy 缓存策略
 @param requwstHead 请求头
 @param configuration 配置（请求头，超时时间也可以在这里设置）
 @param completeBlock 完成请求
 */
+(void)BG_startRequestWithURL:(NSURL *)URL param:(NSDictionary *)param type:(BGRequestType)type outTime:(NSTimeInterval)outTime cachePolicy:(NSURLRequestCachePolicy)cachePolicy requwstHead:(NSDictionary *)requwstHead configuration:(NSURLSessionConfiguration *)configuration completeBlock:(CompleteBlock)completeBlock
{
    [self shareHelper];
    
    // 创建Request请求
    NSMutableURLRequest *request;
    // 设置请求方法以及参数
    NSData *parameData = nil;
    NSError *error;
    if (type == BGRequestTypePost)
    {
        request = [NSMutableURLRequest requestWithURL:URL];
        [request setHTTPMethod:@"POST"];
        // 参数配置
        if ([NSJSONSerialization isValidJSONObject:param])
        {
            // 创造一个json从Data, NSJSONWritingPrettyPrinted指定的JSON数据产的空白，使输出更具可读性。
            parameData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
        }
//        NSData *parameData = [[NSString BGNet_paramString:param] dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:parameData];
        
    }
    else
    {
        NSString *urlStr;
        // 参数配置
        if (param && param.allKeys.count>0)
        {
            urlStr = [NSString stringWithFormat:@"%@?%@",[URL absoluteString],[NSString BGNet_paramString:param]];
        }
        else
        {
            urlStr = [URL absoluteString];
        }
        URL = [[NSURL alloc] initWithString:urlStr];
        request = [NSMutableURLRequest requestWithURL:URL];
        [request setHTTPMethod:@"GET"];
    }
    
    // 设置请求超时 默认超时时间60s
    [request setTimeoutInterval:outTime];
    
    //    // 设置头部参数
    //    [request addValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
    //    //或者下面这种方式 添加所有请求头信息
        request.allHTTPHeaderFields = requwstHead;
    if (parameData != nil)
    {
        NSString *bodyLength = [NSString stringWithFormat:@"%lu", (unsigned long)[parameData length]];
        [request setValue:bodyLength forHTTPHeaderField:@"Content-Length"];
    }
    else
    {
        [request setValue:@"0" forHTTPHeaderField:@"Content-Length"];
    }
    [request setValue:@"application/json"forHTTPHeaderField:@"Content-Type"];
    //设置缓存策略
    [request setCachePolicy:cachePolicy];
    
    // 创建网络会话
    
    //2程序自动安装证书的方式
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:netWork delegateQueue:[[NSOperationQueue alloc] init]];
    // 创建会话任务
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        completeBlock(data, error);
    }];
    // 执行任务
    [task resume];
    
}



#pragma mark - NSURLSessionDelegate 代理方法
//主要就是处理HTTPS请求的
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler
{
    NSURLProtectionSpace *protectionSpace = challenge.protectionSpace;
    if ([protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        SecTrustRef serverTrust = protectionSpace.serverTrust;
        completionHandler(NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:serverTrust]);
    } else {
        completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
    }
}
@end
