//
//  ZJAreaDataManager.h
//  AllMyTestDemoZJ
//
//  Created by zhangjiang on 15/11/14.
//  Copyright © 2015年 zhangjiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "ZJAreaModel.h"
@interface ZJAreaDataManager : NSObject
/**
 *	@brief	数据库对象单例方法
 *
 *	@return	返回FMDateBase数据库操作对象
 */
+ (FMDatabase *)shareDataBase;

/**
 *  创建表格
 */
+(BOOL)createTableList;

/**
 *  判断是否已经存在
 */
+(BOOL)haveExistAreaInfo:(ZJAreaModel*)model;

/**
 *  插入数据信息
 */
+(BOOL)insertAreaInfo:(ZJAreaModel*)model;

/**
 *  更新插入的数据
 */
+(BOOL)updateAreaInfo:(ZJAreaModel*)model;

/**
 *  删除数据
 */
+(BOOL)deleteAreaInfo:(ZJAreaModel*)model;

/**
 *  获取到所有的数据
 */
+(NSArray*)getAllAreaList;
@end
