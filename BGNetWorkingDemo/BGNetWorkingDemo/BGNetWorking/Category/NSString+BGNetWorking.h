//
//  NSString+BGNetWorking.h
//  BGNSURLSessionProject
//
//  Created by 冉彬 on 2018/9/25.
//  Copyright © 2018年 Binge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (BGNetWorking)


/**
 url字符串编码（处理汉字与特殊字符）

 @return 编码后的字符串
 */
/* -(NSString *)BGNet_urlEncoding;*/


/**
参数字典中汉字与特殊字符处理

 @return 编码后的字符串
 */
-(NSString *)BGNet_paramEncoding;



/**
 参数字典转换为参数字符串拼接到url后面
 
 @param dic 参数字典
 @return 转换后的字符串
 */
+ (NSString *)BGNet_paramString:(NSDictionary *)dic;


/**
 字典转换为json参数字符串
 
 @param dict 字典
 @return 转换后的字符串
 */
+(NSString *)BGNet_jsonString:(NSDictionary *)dict;

@end
