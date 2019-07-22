//
//  BGNetWorking.h
//  BGNSURLSessionProject
//
//  Created by 冉彬 on 2018/9/25.
//  Copyright © 2018年 Binge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+BGNetWorking.h"


typedef void (^CompleteBlock)(NSData *obj, NSError *error);

typedef NS_ENUM(NSInteger, BGRequestType)
{
    BGRequestTypeGet = 0,
    BGRequestTypePost,
};

@interface BGNetWorking : NSObject<NSURLSessionDelegate>



/**
 Get请求
 
 @param URL URL
 @param param 参数字典
 @param completeBlock 完成后的回调block
 */
+(void)BG_getRequestWithURL:(NSURL *)URL param:(NSDictionary *)param completeBlock:(CompleteBlock)completeBlock;


/**
 Post请求
 
 @param URL URL
 @param param 参数字典
 @param completeBlock 完成后的回调block
 */
+(void)BG_postRequestWithURL:(NSURL *)URL param:(NSDictionary *)param completeBlock:(CompleteBlock)completeBlock;


/**
 Get请求（带请求头）
 
 @param URL URL
 @param param 参数字典
 @param head 请求头
 @param completeBlock 完成后的回调block
 */
+(void)BG_getRequestWithURL:(NSURL *)URL param:(NSDictionary *)param head:(NSDictionary *)head completeBlock:(CompleteBlock)completeBlock;


/**
 Post请求（带请求头）
 
 @param URL URL
 @param param 参数字典
 @param head 请求头
 @param completeBlock 完成后的回调block
 */
+(void)BG_postRequestWithURL:(NSURL *)URL param:(NSDictionary *)param head:(NSDictionary *)head completeBlock:(CompleteBlock)completeBlock;




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
+(void)BG_startRequestWithURL:(NSURL *)URL param:(NSDictionary *)param type:(BGRequestType)type outTime:(NSTimeInterval)outTime cachePolicy:(NSURLRequestCachePolicy)cachePolicy requwstHead:(NSDictionary *)requwstHead configuration:(NSURLSessionConfiguration *)configuration completeBlock:(CompleteBlock)completeBlock;
@end
