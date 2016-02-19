//
//  AFNClientHelper.m
//  AllMyTestDemoZJ
//
//  Created by zjhaha on 16/1/19.
//  Copyright © 2016年 zhangjiang. All rights reserved.
//

#import "AFNClientHelper.h"
#define NetWorking_NoReachable @"请退出ZJTest,在iOS“设置”－“Wi-Fi”或“蜂窝移动数据”打开网络,然后回到ZJTest。"
@implementation AFNClientHelper


+ (void)startMonitoring
{
    //监控网络
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            if (IOS8_OR_LATER) {
                [HUDHelper confirmMsg:@"亲,请先联网哦" continueBlock:^{
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
                        [[UIApplication sharedApplication] openURL:url];
                    }
                }];
            }else{
                
                [HUDHelper showBlockMsg:NetWorking_NoReachable continueBlock:nil];
            }
            
        }
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

+ (void)stopMonitoring
{
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    [mgr stopMonitoring];
}


+(NSURLSessionDataTask *)getWithURLString:(NSString*)urlString param:(NSDictionary*)params success:(RequestSuccessBlock)successBlock fail:(RequestFailureBlock)failBlock{
    
    if (![AFNClientHelper getNetWorkStatus]) {
        failBlock(@"没有网络直接返回");
        return nil;
    }
    
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    //设置请求体
    sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    [sessionManager.requestSerializer setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    [sessionManager.requestSerializer setValue:@"en-us,en;q=0.5" forHTTPHeaderField:@"Accept-Language"];
    [sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
   return  [sessionManager GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//        downloadProgress.fractionCompleted  //当前的下载进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(error.description);
    }];
    
}

+(NSURLSessionDataTask*)postWithURLString:(NSString *)urlString param:(NSDictionary *)params success:(RequestSuccessBlock)successBlock fail:(RequestFailureBlock)failBlock{
    
    if (![AFNClientHelper getNetWorkStatus]) {
        failBlock(@"没有网络直接返回");
        return nil;
    }
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    //设置请求体
    sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    [sessionManager.requestSerializer setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    [sessionManager.requestSerializer setValue:@"en-us,en;q=0.5" forHTTPHeaderField:@"Accept-Language"];
    [sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    return  [sessionManager POST:urlString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
//        uploadProgress.fractionCompleted   //当前完成的进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(error.description);
    }];
}

+(NSURLSessionDataTask *)putWithURLString:(NSString *)urlString param:(NSDictionary *)params success:(RequestSuccessBlock)successBlock fail:(RequestFailureBlock)failBlock{
    
    if (![AFNClientHelper getNetWorkStatus]) {
        failBlock(@"没有网络直接返回");
        return nil;
    }
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    //设置请求体
    sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    [sessionManager.requestSerializer setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    [sessionManager.requestSerializer setValue:@"en-us,en;q=0.5" forHTTPHeaderField:@"Accept-Language"];
    [sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    return [sessionManager PUT:urlString parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(error.description);
    }];
    
    
}

+(NSURLSessionDataTask *)deleteWithURLString:(NSString *)urlString param:(NSDictionary *)params success:(RequestSuccessBlock)successBlock fail:(RequestFailureBlock)failBlock{
    if (![AFNClientHelper getNetWorkStatus]) {
        failBlock(@"没有网络直接返回");
        return nil;
    }
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    //设置请求体
    sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    [sessionManager.requestSerializer setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    [sessionManager.requestSerializer setValue:@"en-us,en;q=0.5" forHTTPHeaderField:@"Accept-Language"];
    [sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    return [sessionManager DELETE:urlString parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(error.description);
    }];
}



+(NSURLSessionDownloadTask*)downLoadFileWithURLString:(NSString *)urlString path:(RequestPathBlock)pathBlock{
    
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
    return downloadTask;
}



/**
 *  获取网络状态
 */
+(BOOL)getNetWorkStatus{
    __block BOOL isAble = NO;
    [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable ) {
            isAble = NO;
        }else{
            isAble = YES;
        }
        
    }];
    
    return isAble;
}


//获取Documents目录
+(NSString *)dirDoc{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

@end
