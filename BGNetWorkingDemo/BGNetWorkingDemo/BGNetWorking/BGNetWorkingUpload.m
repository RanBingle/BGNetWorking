//
//  BGNetWorkingUpload.m
//  BGCommonProject
//
//  Created by 冉彬 on 2018/10/25.
//  Copyright © 2018 Binge. All rights reserved.
//

#import "BGNetWorkingUpload.h"

@implementation BGNetWorkingUpload



/**
 文件上传(路径)
 
 @param URLStr 上传地址
 @param params 参数字典
 @param fileURL 文件url
 @param fileName 文件名称
 @param name 上传名称
 @param block 回调block
 @return 上传任务
 */
+(NSURLSessionUploadTask *)BG_uploadWithURLStr:(NSString *)URLStr params:(NSDictionary *)params fileURL:(NSURL *)fileURL fileName:(NSString *)fileName name:(NSString *)name block:(BGUploadBlock)block
{
    BGNetWorkingUpload *upload = [[BGNetWorkingUpload alloc] init];
    upload.uploadBlock = block;
    // 请求体
    NSMutableURLRequest *mutableRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLStr]];
    mutableRequest.HTTPMethod = @"POST";
    // 参数拼接
    NSData *pData = [upload splitBodyDataWithParams:params fileURLs:@[fileURL] fileNames:@[fileName] name:name];
    [mutableRequest setHTTPBody:pData];
    // 头
    NSString *headerString = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", upload.boundary];
    [mutableRequest setValue:headerString forHTTPHeaderField:@"Content-Type"];
    
    upload.uploadTask = [upload.session uploadTaskWithStreamedRequest:mutableRequest];
    // 执行任务
    [upload.uploadTask resume];
    return upload.uploadTask;
}


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
+(NSURLSessionUploadTask *)BG_uploadWithURLStr:(NSString *)URLStr params:(NSDictionary *)params fileData:(NSURL *)fileData fileName:(NSString *)fileName name:(NSString *)name block:(BGUploadBlock)block
{
    BGNetWorkingUpload *upload = [[BGNetWorkingUpload alloc] init];
    upload.uploadBlock = block;
    // 请求体
    NSMutableURLRequest *mutableRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLStr]];
    mutableRequest.HTTPMethod = @"POST";
    // 参数拼接
    NSData *pData = [upload splitBodyDataWithParams:params fileDatas:@[fileData] fileNames:@[fileName] name:name];
    [mutableRequest setHTTPBody:pData];
    // 头
    NSString *headerString = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", upload.boundary];
    [mutableRequest setValue:headerString forHTTPHeaderField:@"Content-Type"];
    
    upload.uploadTask = [upload.session uploadTaskWithStreamedRequest:mutableRequest];
    // 执行任务
    [upload.uploadTask resume];
    return upload.uploadTask;
}


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
+(NSURLSessionUploadTask *)BG_uploadWithURLStr:(NSString *)URLStr params:(NSDictionary *)params fileURLs:(NSArray *)fileURLs fileNames:(NSArray *)fileNames name:(NSString *)name block:(BGUploadBlock)block
{
    BGNetWorkingUpload *upload = [[BGNetWorkingUpload alloc] init];
    upload.uploadBlock = block;
    // 请求体
    NSMutableURLRequest *mutableRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLStr]];
    mutableRequest.HTTPMethod = @"POST";
    // 参数拼接
    NSData *pData = [upload splitBodyDataWithParams:params fileURLs:fileURLs fileNames:fileNames name:name];
    [mutableRequest setHTTPBody:pData];
    // 头
    NSString *headerString = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", upload.boundary];
    [mutableRequest setValue:headerString forHTTPHeaderField:@"Content-Type"];
    
    upload.uploadTask = [upload.session uploadTaskWithStreamedRequest:mutableRequest];
    // 执行任务
    [upload.uploadTask resume];
    return upload.uploadTask;
}


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
+(NSURLSessionUploadTask *)BG_uploadWithURLStr:(NSString *)URLStr params:(NSDictionary *)params fileDatas:(NSArray *)fileDatas fileNames:(NSArray *)fileNames name:(NSString *)name block:(BGUploadBlock)block
{
    BGNetWorkingUpload *upload = [[BGNetWorkingUpload alloc] init];
    upload.uploadBlock = block;
    // 请求体
    NSMutableURLRequest *mutableRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLStr]];
    mutableRequest.HTTPMethod = @"POST";
    // 参数拼接
    NSData *pData = [upload splitBodyDataWithParams:params fileDatas:fileDatas fileNames:fileNames name:name];
    [mutableRequest setHTTPBody:pData];
    // 头
    NSString *headerString = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", upload.boundary];
    [mutableRequest setValue:headerString forHTTPHeaderField:@"Content-Type"];
    
    upload.uploadTask = [upload.session uploadTaskWithStreamedRequest:mutableRequest];
    // 执行任务
    [upload.uploadTask resume];
    return upload.uploadTask;
}


/**
 拼接上传文件请求二进制数据（文件url）

 @param params 参数字典
 @param fileURLs 文件url列表
 @param fileNames 文件名称列表
 @param name 名称（服务要求 一般为 file）
 @return 二进制数据
 @return 上传任务
 */
- (NSData *)splitBodyDataWithParams:(NSDictionary *)params fileURLs:(NSArray *)fileURLs fileNames:(NSArray *)fileNames name:(NSString *)name
{
    NSMutableArray *fileDatas = [NSMutableArray array];
    for (NSURL *fileURL in fileURLs)
    {
        NSData *fileData = [NSData dataWithContentsOfURL:fileURL];
        [fileDatas addObject:fileData];
    }
    return [self splitBodyDataWithParams:params fileDatas:fileDatas fileNames:fileNames name:name];
}


/**
 拼接上传文件请求二进制数据（文件二进制数据）
 
 @param params 参数字典
 @param fileDatas 文件二进制数据列表
 @param fileNames 文件名称列表
 @param name 名称（服务要求 一般为 file）
 @return 二进制数据
 @return 上传任务
 */
- (NSData *)splitBodyDataWithParams:(NSDictionary *)params fileDatas:(NSArray *)fileDatas fileNames:(NSArray *)fileNames name:(NSString *)name
{
    NSMutableData *data = [NSMutableData data];
    NSString *boundary = self.boundary;
    
    // 文件参数
    [fileDatas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSData *fileData = (NSData *)obj;
        NSString *bodyStr = [NSString stringWithFormat:@"\r\n--%@\r\n", boundary];
        [data appendData:[bodyStr dataUsingEncoding:NSUTF8StringEncoding]];
        // 获取文件名字
        NSString *fileName;
        @try {
            fileName = fileNames[idx];
        } @catch (NSException *exception) {
            fileName = [NSString stringWithFormat:@"%08X", arc4random()];
        } @finally {
            //
        }
        // 文件二进制数据
        bodyStr = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\" \r\n", name, fileName];
        [data appendData:[bodyStr dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:fileData];
        [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    // 非文件参数
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        NSString *boStr = [NSString stringWithFormat:@"\r\n--%@\r\n", boundary];
        [data appendData:[boStr dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSString *disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\" \r\n \r\n", key];
        [data appendData:[disposition dataUsingEncoding:NSUTF8StringEncoding]];
        
        [data appendData:[[obj description] dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    NSString *tailStr = [NSString stringWithFormat:@"--%@--\r\n", boundary];
    [data appendData:[tailStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    return data;
}



#pragma mark - Get
-(NSURLSession *)session
{
    if (_session == nil) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        //是否运行蜂窝访问
        config.allowsCellularAccess = YES;
        //        config.timeoutIntervalForRequest = 15;
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}


-(NSMutableData *)resultData
{
    if (_resultData == nil) {
        _resultData = [NSMutableData data];
    }
    return _resultData;
}


-(NSString *)boundary
{
    if (!_boundary)
    {
        _boundary = [NSString stringWithFormat:@"Boundary+%08X%08X", arc4random(), arc4random()];
    }
    return _boundary;
}


#pragma mark -NSURLSessionDataDelegate
/**
 上传进度
 
 @param session 网络会话
 @param task 上传任务
 @param bytesSent 本次发送的数据
 @param totalBytesSent 上传完成数据大小
 @param totalBytesExpectedToSend 文件数据总大小
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    float progress = 1.0 *totalBytesSent / totalBytesExpectedToSend;
    if (self.uploadBlock)
    {
        self.uploadBlock(nil, progress, nil, NO);
    }
}


/**
 *  接收到服务器返回的数据 调用多次
 *
 *  @param session           会话对象
 *  @param dataTask          请求任务
 *  @param data              本次下载的数据
 */
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    //拼接数据
    [self.resultData appendData:data];
}



/**
 请求完成后调用

 @param session 会话
 @param task 任务
 @param error 错误
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error
{
    if (self.uploadBlock)
    {
        self.uploadBlock(self.resultData, 1, error, YES);
    }
//    NSLog(@"结果：%@",[[NSString alloc]initWithData:self.resultData encoding:NSUTF8StringEncoding]);
}






@end
