//
//  NSString+URLCode.h
//  AllMyTestDemoZJ
//
//  Created by zjhaha on 16/1/6.
//  Copyright © 2016年 zhangjiang. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  url字符串中具有特殊功能的特殊字符的字符串，或者中文字符,作为参数用GET方式传递时，需要用urlencode处理一下，或者处理转义后的字符串等数据时
 */

@interface NSString (URLCode)
/**
 *  url中含有中文或者特殊符号时的转义处理--编码
 */
- (NSString *)URLEncodeString;
/**
 *  url中含有中文或者特殊符号时的转义处理--解码
 */
- (NSString *)URLDecodeString;
@end
