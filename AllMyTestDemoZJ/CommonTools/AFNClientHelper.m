//
//  AFNClientHelper.m
//  AllMyTestDemoZJ
//
//  Created by zjhaha on 16/1/19.
//  Copyright © 2016年 zhangjiang. All rights reserved.
//

#import "AFNClientHelper.h"

@implementation AFNClientHelper

+(void)getWithURLString:(NSString*)urlString param:(NSDictionary*)params success:(RequestSuccessBlock)successBlock fail:(RequestFailureBlock)failBlock{
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    //设置请求体
    sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    [sessionManager.requestSerializer setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    [sessionManager.requestSerializer setValue:@"en-us,en;q=0.5" forHTTPHeaderField:@"Accept-Language"];
    [sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [sessionManager GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(error.description);
    }];
    
}

+(void)postWithURLString:(NSString *)urlString param:(NSDictionary *)params success:(RequestSuccessBlock)successBlock fail:(RequestFailureBlock)failBlock{
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    //设置请求体
    sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    [sessionManager.requestSerializer setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    [sessionManager.requestSerializer setValue:@"en-us,en;q=0.5" forHTTPHeaderField:@"Accept-Language"];
    [sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [sessionManager POST:urlString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(error.description);
    }];
}

+(void)downLoadFileWithURLString:(NSString *)urlString path:(RequestPathBlock)pathBlock{
    //下载地址
    NSURL *url = [NSURL URLWithString:urlString];
    //保存路径
    NSString *rootPath = [self dirDoc];
    NSString *fileName = [urlString lastPathComponent];
    NSString *fileFullPath = [rootPath  stringByAppendingPathComponent:fileName];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        pathBlock(fileFullPath);
        
    }];
    [downloadTask resume];
}


//获取Documents目录
+(NSString *)dirDoc{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

@end
