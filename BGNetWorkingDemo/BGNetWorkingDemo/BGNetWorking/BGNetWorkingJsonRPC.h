//
//  BGNetWorkingJsonRPC.h
//  BGNetWorking
//
//  Created by 冉彬 on 2019/4/1.
//  Copyright © 2019 Bingle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+BGNetWorking.h"

typedef void (^JsonRPCCompleteBlock)(NSData * _Nullable obj, NSError * _Nullable error);

NS_ASSUME_NONNULL_BEGIN

@interface BGNetWorkingJsonRPC : NSObject









/**
 Post请求
 
 @param URL URL
 @param param 参数字典
 @param completeBlock 完成后的回调block
 */
+(void)BG_postRequestWithURL:(NSURL *)URL param:(NSDictionary *)param completeBlock:(JsonRPCCompleteBlock)completeBlock;




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
+(void)BG_startRequestWithURL:(NSURL *)URL param:(NSDictionary *)param outTime:(NSTimeInterval)outTime cachePolicy:(NSURLRequestCachePolicy)cachePolicy requwstHead:(NSDictionary *)requwstHead configuration:(NSURLSessionConfiguration *)configuration completeBlock:(JsonRPCCompleteBlock)completeBlock;



@end

NS_ASSUME_NONNULL_END
