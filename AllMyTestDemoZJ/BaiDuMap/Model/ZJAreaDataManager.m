//
//  ZJAreaDataManager.m
//  AllMyTestDemoZJ
//
//  Created by zhangjiang on 15/11/14.
//  Copyright © 2015年 zhangjiang. All rights reserved.
//

#import "ZJAreaDataManager.h"

static FMDatabase *shareDataBase = nil;
@implementation ZJAreaDataManager

+(FMDatabase *)shareDataBase{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        NSString *docsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *dbPath = [docsPath stringByAppendingPathComponent:@"areaLists.db"];
        
        shareDataBase = [FMDatabase databaseWithPath:dbPath];
    });
    return shareDataBase;
}

/**
 *  创建表格
 */
+(BOOL)createTableList{
    if (1) {
        shareDataBase = [ZJAreaDataManager shareDataBase];
        if ([shareDataBase open]) {
            [self createAreaListTableInDB:shareDataBase];
        }
    }
    return YES;
}

/**
 *  判断表是否存在
 */
+(BOOL)isTableListExist:(NSString*)tableName;
{
    FMResultSet *rs = [shareDataBase executeQuery:@"select count(*) as 'count' from sqlite_master where type = 'table' and name = ?",tableName];
    while ([rs next]) {
        NSInteger count = [rs intForColumn:@"count"];
        if (count == 0) {
            return NO;
        }else{
            return YES;
        }
    }
    return NO;
}

/**
 *  创建表格
 */
+(BOOL)createAreaListTableInDB:(FMDatabase*)db{
    NSString *sqlStr = @"CREATE TABLE 'AreaListTable' ('areaID' INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL  UNIQUE , 'areaName' VARCHAR NOT NULL , 'areaData' VARCHAR NOT NULL ,'areaTime' VARCHAR NOT NULL)";
    BOOL success = [db executeUpdate:sqlStr];
    return success;
}

+(BOOL)haveExistAreaInfo:(ZJAreaModel *)model{
    
    shareDataBase = [ZJAreaDataManager shareDataBase];
    if ([shareDataBase open]) {
        FMResultSet *rs = [shareDataBase executeQuery:@"select count(*) from AreaListTable where areaId=? ",model.areaId];
        while ([rs next]) {
            int count = [rs intForColumnIndex:0];
            if (count) {
                [shareDataBase close];
                return YES;
            }else{
                [shareDataBase close];
                return NO;
            }
        }

    }
    return YES;
}


/**
 *  插入数据信息
 */
+(BOOL)insertAreaInfo:(ZJAreaModel*)model{
    BOOL success = NO;
    shareDataBase = [ZJAreaDataManager shareDataBase];
    if ([shareDataBase open]) {
        success = [shareDataBase executeUpdate:@"INSERT INTO 'AreaListTable' ('areaName','areaData','areaTime') VALUES (?,?,?)",model.areaName,model.areaData,model.areaTime];
        NSLog(@"插入数据成功");
    }
    [shareDataBase close];
    return success;
}


/**
 *  更新插入的数据
 */
+(BOOL)updateAreaInfo:(ZJAreaModel*)model{
    shareDataBase = [ZJAreaDataManager shareDataBase];
    BOOL success = NO;
    if ([shareDataBase open]) {
        success = [shareDataBase executeUpdate:@"update  AreaListTable set areaName = ?,areaData = ? ,areaTime = ? where  areaID = ?",model.areaName,model.areaData,model.areaTime,model.areaId];
    }
    return success;
}

/**
 *  删除数据
 */
+(BOOL)deleteAreaInfo:(ZJAreaModel*)model{
    shareDataBase = [ZJAreaDataManager shareDataBase];
    BOOL success = NO;
    if ([shareDataBase open]) {
        NSString * query = [NSString stringWithFormat:@"DELETE FROM AreaListTable WHERE areaId = '%@'",model.areaId];
        
        success = [shareDataBase executeUpdate:query];
    }
    return success;
}

/**
 *  获取所有的区域数据
 */
+(NSArray *)getAllAreaList{
    
    shareDataBase = [ZJAreaDataManager shareDataBase];
    NSMutableArray *areaArr = [NSMutableArray array];
    if ([shareDataBase open]) {
        FMResultSet *result = [shareDataBase executeQuery:@"select * from AreaListTable"];
        while ([result next]) {
            ZJAreaModel *model = [[ZJAreaModel alloc]init];
            model.areaId   = [result stringForColumn:@"areaId"];
            model.areaName = [result stringForColumn:@"areaName"];
            model.areaData = [result stringForColumn:@"areaData"];
            model.areaTime = [result stringForColumn:@"areaTime"];
            [areaArr addObject:model];
        }
        [shareDataBase close];
    }
    return areaArr;
}

@end
