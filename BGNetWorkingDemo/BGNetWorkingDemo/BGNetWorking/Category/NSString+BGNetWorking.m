//
//  NSString+BGNetWorking.m
//  BGNSURLSessionProject
//
//  Created by 冉彬 on 2018/9/25.
//  Copyright © 2018年 Binge. All rights reserved.
//

#import "NSString+BGNetWorking.h"

@implementation NSString (BGNetWorking)


/**
 url字符串编码（处理汉字与特殊字符）
 
 @return 编码后的字符串
 */
//-(NSString *)BGNet_urlEncoding
//{
//    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
//                                                                                                     (CFStringRef)self,
//                                                                                                     (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
//                                                                                                     NULL,
//                                                                                                     kCFStringEncodingUTF8));
//    return encodedString;
//    
//}


/**
 参数字典中汉字与特殊字符处理
 
 @return 编码后的字符串
 */
-(NSString *)BGNet_paramEncoding
{
    NSString *charactersToEscape = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    NSString *encodedUrl = [self stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    return encodedUrl;
}


/**
 参数字典转换为参数字符串拼接到url后面

 @param dic 参数字典
 @return 转换后的字符串
 */
+ (NSString *)BGNet_paramString:(NSDictionary *)dic
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *key in dic)
    {
        NSString *value = [NSString stringWithFormat:@"%@", [dic objectForKey:key]];
        [array addObject:[NSString stringWithFormat:@"%@=%@", [key BGNet_paramEncoding], [value BGNet_paramEncoding]]];
    }
    return [array componentsJoinedByString:@"&"];
}


/**
 字典转换为json参数字符串
 
 @param dict 字典
 @return 转换后的字符串
 */
+(NSString *)BGNet_jsonString:(NSDictionary *)dict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData)
    {
        NSLog(@"%@",error);
    }
    else
    {
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
    
}




@end
