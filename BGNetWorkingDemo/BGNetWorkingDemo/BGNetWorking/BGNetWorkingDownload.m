//
//  BGNetWorkingDownload.m
//  BGCommonProject
//
//  Created by 冉彬 on 2018/10/23.
//  Copyright © 2018 Binge. All rights reserved.
//

#import "BGNetWorkingDownload.h"


@implementation BGNetWorkingDownload



/**
 下载文件
 
 @param urlStr url
 @param block 回调block
 @return 下载管理对象
 */
+(BGNetWorkingDownload *)BG_downloadWithUrlStr:(NSString *)urlStr block:(BGDownloadBlock)block
{
    BGNetWorkingDownload *download = [[BGNetWorkingDownload alloc] init];
    download.downloadBlock = block;
    [download startDownloadWithUrlStr:urlStr block:block];
    return download;
}


/**
 开始下载

 @param urlStr 下载rul字符串
 @param block 回调block
 */
-(void)startDownloadWithUrlStr:(NSString *)urlStr block:(BGDownloadBlock)block
{
    NSURL *url = [NSURL URLWithString:urlStr];
    self.downloadTask = [self.session downloadTaskWithURL:url];
    [self.downloadTask resume];
}


/**
 暂停下载
 */
-(void)suspendDownload
{
    if (self.downloadTask)
    {
        [self.downloadTask suspend];
    }
}


/**
 继续下载
 */
-(void)resumeDownload
{
    if (self.downloadTask)
    {
        [self.downloadTask resume];
    }
}


/**
 取消下载
 */
-(void)cancelDownload
{
    if (self.downloadTask)
    {
        [self.downloadTask cancel];
    }
}



#pragma mark - Get
- (NSURLSession *)session
{
    if (!_session) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
//        config.timeoutIntervalForRequest = 20.0;
//        config.timeoutIntervalForResource = 5.0;
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    }
    return _session;
}



#pragma mark - NSURLSessionDelegate
/**
 下载完成方法

 @param session session
 @param downloadTask 下载任务
 @param location 本地存储路径
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
//    NSLog(@"finish %@\n%@",location, downloadTask.response.textEncodingName);
    NSData *data = [NSData dataWithContentsOfURL:location];
    if (self.downloadBlock)
    {
        self.downloadBlock(data, YES, 1.0, nil);
    }
    
}


//下载进度
/*
 bytesWritten               本次下载的字节数
 totalBytesWritten          已经下载的字节数
 totalBytesExpectedToWrite  期望下载的字节数：文件总大小
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    
    float progress = (float)totalBytesWritten/totalBytesExpectedToWrite;
    if (self.downloadBlock)
    {
        self.downloadBlock(nil, NO, progress, nil);
    }
}

/**
 下载续传数据（resume之后会调用这个方法）

 @param session 网络会话
 @param downloadTask 下载任务
 @param fileOffset 已下载数据大小
 @param expectedTotalBytes 预期数据总大小
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    NSLog(@"task:%ld 续传", (long)downloadTask.taskIdentifier);
}

/**
 下载任务结束时调用

 @param session 网络会话
 @param task 下载任务
 @param error 错误
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error
{
    if (error)
    {
        if (self.downloadBlock)
        {
            self.downloadBlock(nil, YES, 0.0, error);
        }
    }
//    NSLog(@"task:%ld 结束", (long)task.taskIdentifier);
    
}





@end
