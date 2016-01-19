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
 *  get请求方法
 */
+(void)getWithURLString:(NSString*)urlString param:(NSDictionary*)params success:(RequestSuccessBlock)successBlock fail:(RequestFailureBlock)failBlock;

/**
 *  post请求方法
 */
+(void)postWithURLString:(NSString*)urlString param:(NSDictionary*)params success:(RequestSuccessBlock)successBlock fail:(RequestFailureBlock)failBlock;

/**
 *  下载方法，返回文件的路径
 */
+(void)downLoadFileWithURLString:(NSString*)urlString path:(RequestPathBlock)pathStr;

/**
 *  上传方法
 */


@end
