//
//  BGNetWorkingDownload.h
//  BGCommonProject
//
//  Created by 冉彬 on 2018/10/23.
//  Copyright © 2018 Binge. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^BGDownloadBlock)(NSData *fileData, BOOL isFinish, float progress, NSError *error);

@interface BGNetWorkingDownload : NSObject <NSURLSessionDelegate>
//网络会话
@property (nonatomic , strong) NSURLSession *session;
//下载任务
@property (nonatomic , strong) NSURLSessionDownloadTask *downloadTask;
// 下载回调
@property (nonatomic, copy) BGDownloadBlock downloadBlock;


/**
 下载文件
 
 @param urlStr url
 @param block 回调block
 @return 下载管理对象
 */
+(BGNetWorkingDownload *)BG_downloadWithUrlStr:(NSString *)urlStr block:(BGDownloadBlock)block;


/**
 开始下载
 
 @param urlStr 下载rul字符串
 @param block 回调block
 */
-(void)startDownloadWithUrlStr:(NSString *)urlStr block:(BGDownloadBlock)block;


/**
 暂停下载
 */
-(void)suspendDownload;


/**
 继续下载
 */
-(void)resumeDownload;


/**
 取消下载
 */
-(void)cancelDownload;







@end
