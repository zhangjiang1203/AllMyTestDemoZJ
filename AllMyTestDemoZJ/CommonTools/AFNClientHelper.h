//
//  AFNClientHelper.h
//  AllMyTestDemoZJ
//
//  Created by zjhaha on 16/1/19.
//  Copyright © 2016年 zhangjiang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RequestSuccessBlock)(NSDictionary *dictData);
typedef void (^RequestFailureBlock)(NSString *errorStr);
typedef void (^RequestPathBlock)(NSString *pathString);

@interface AFNClientHelper : NSObject

/**
*  开启网络监测
*/
+ (void)startMonitoring;

/**
 * 关闭网络监测
 */
+ (void)stopMonitoring;

/**
 *  get请求方法
 *  NSURLSessionDataTask  获取到这个值，可以取消网络请求
 */
+(NSURLSessionDataTask*)getWithURLString:(NSString*)urlString param:(NSDictionary*)params success:(RequestSuccessBlock)successBlock fail:(RequestFailureBlock)failBlock;

/**
 *  post请求方法
 */
+(NSURLSessionDataTask*)postWithURLString:(NSString*)urlString param:(NSDictionary*)params success:(RequestSuccessBlock)successBlock fail:(RequestFailureBlock)failBlock;

/**
 *  put请求方法
 */
+(NSURLSessionDataTask*)putWithURLString:(NSString*)urlString param:(NSDictionary*)params success:(RequestSuccessBlock)successBlock fail:(RequestFailureBlock)failBlock;

/**
 *  delete请求方法
 */
+(NSURLSessionDataTask*)deleteWithURLString:(NSString*)urlString param:(NSDictionary*)params success:(RequestSuccessBlock)successBlock fail:(RequestFailureBlock)failBlock;

/**
 *  下载方法，返回文件的路径
 */
+(NSURLSessionDownloadTask*)downLoadFileWithURLString:(NSString*)urlString path:(RequestPathBlock)pathStr;

/**
 *  上传方法
 */


@end
