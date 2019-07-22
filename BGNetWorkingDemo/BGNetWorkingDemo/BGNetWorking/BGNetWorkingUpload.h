//
//  BGNetWorkingUpload.h
//  BGCommonProject
//
//  Created by 冉彬 on 2018/10/25.
//  Copyright © 2018 Binge. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^BGUploadBlock)(NSData *obj, float progress, NSError *error, BOOL isFinish);

@interface BGNetWorkingUpload : NSObject <NSURLSessionDataDelegate>

// 网络会话
@property (nonatomic , strong) NSURLSession *session;
// 上传任务
@property (nonatomic , strong) NSURLSessionUploadTask *uploadTask;
// 上传回调
@property (nonatomic, copy) BGUploadBlock uploadBlock;
// 接受响应体信息
@property (nonatomic, strong) NSMutableData *resultData;
//
@property (nonatomic, strong) NSString *boundary;


/**
 文件上传（路径）

 @param URLStr 上传地址
 @param params 参数字典
 @param fileURL 文件url
 @param fileName 文件名称
 @param name 上传名称
 @param block 回调block
 @return 上传任务
 */
+(NSURLSessionUploadTask *)BG_uploadWithURLStr:(NSString *)URLStr params:(NSDictionary *)params fileURL:(NSURL *)fileURL fileName:(NSString *)fileName name:(NSString *)name block:(BGUploadBlock)block;


/**
 文件上传（二进制）
 
 @param URLStr 上传地址
 @param params 参数字典
 @param fileData 文件二进制数据
 @param fileName 文件名称
 @param name 上传名称
 @param block 回调block
 @return 上传任务
 */
+(NSURLSessionUploadTask *)BG_uploadWithURLStr:(NSString *)URLStr params:(NSDictionary *)params fileData:(NSURL *)fileData fileName:(NSString *)fileName name:(NSString *)name block:(BGUploadBlock)block;


/**
 多文件上传（路径）
 
 @param URLStr 上传地址
 @param params 参数字典
 @param fileURLs 文件url列表
 @param fileNames 文件名称列表
 @param name 上传名称
 @param block 回调block
 @return 上传任务
 */
+(NSURLSessionUploadTask *)BG_uploadWithURLStr:(NSString *)URLStr params:(NSDictionary *)params fileURLs:(NSArray *)fileURLs fileNames:(NSArray *)fileNames name:(NSString *)name block:(BGUploadBlock)block;


/**
 多文件上传（二进制）
 
 @param URLStr 上传地址
 @param params 参数字典
 @param fileDatas 文件二进制列表
 @param fileNames 文件名称列表
 @param name 上传名称
 @param block 回调block
 @return 上传任务
 */
+(NSURLSessionUploadTask *)BG_uploadWithURLStr:(NSString *)URLStr params:(NSDictionary *)params fileDatas:(NSArray *)fileDatas fileNames:(NSArray *)fileNames name:(NSString *)name block:(BGUploadBlock)block;


@end
