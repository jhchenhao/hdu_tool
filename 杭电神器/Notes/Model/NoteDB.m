//
//  NoteDB.m
//  项目3
//
//  Created by mac on 15/10/2.
//  Copyright (c) 2015年 chenhao. All rights reserved.
//

#import "NoteDB.h"
#import "EGODatabase.h"



@implementation NoteDB

///Users/mac/Library/Developer/CoreSimulator/Devices/91D25406-9DD7-4D07-9E28-445B4C3DA06F/data/Containers/Data/Application/C70BA39B-74E5-44AD-8871-2220BC497C9C/Documents
///Users/mac/Library/Developer/CoreSimulator/Devices/91D25406-9DD7-4D07-9E28-445B4C3DA06F/data/Containers/Data/Application/C70BA39B-74E5-44AD-8871-2220BC497C9C/Documents/images/609D31D2-44AB-4876-9EC4-86FA3BB0F1C4.jpg
+ (void)createData
{
    
    NSLog(@"%@",DataBaseFilePath);
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:DataBaseFilePath]) {
        [manager removeItemAtPath:DataBaseFilePath error:NULL];
    }
    //创建存储图片的文件夹
    NSString *imageFile = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/images"];
    [manager createDirectoryAtPath:imageFile withIntermediateDirectories:YES attributes:nil error:nil];
    //使用数据库文件构造对象
    EGODatabase *dataBase = [[EGODatabase alloc] initWithPath:DataBaseFilePath];
    //打开数据库
    [dataBase open];
    //构造数据库内容
    NSString *sql = @"create table t_notes(noteTime text,noteTitle text,noteTimeTitle text,noteContext text,noteImage text)";
    [dataBase executeUpdate:sql];
    //关闭数据库
    [dataBase close];
}

//增
+ (void)addNote:(NoteModel *)note
{
    //如果note中没有数据 则自己设置数据
    if (note.title.length == 0) {
        note.title = @"默认";
    }
    if (note.image.length == 0) {
        note.image = @"nil";
    }
    if (note.context.length == 0) {
        note.context = @"nil";
    }
    NSLog(@"%@",DataBaseFilePath);
    //使用数据库文件构造数据库操作对象
    EGODatabase *dataBase = [[EGODatabase alloc] initWithPath:DataBaseFilePath];
    //打开数据库
    [dataBase open];
    //数据库操作
    NSString *sql = @"INSERT INTO t_notes(noteTime, noteTitle, noteTimeTitle,noteContext,noteImage) values(?,?,?,?,?)";
    
//    NSString *sql = @"delete from t_notes where noteImage = '1' and noteTime = '2'";
    NSArray *params = @[note.time,note.title,note.timeTitle,note.context,note.image];
    //同步添加数据到t_student中
    BOOL boo =[dataBase executeUpdate:sql parameters:params];
    NSLog(@"创建文件%i",boo);
    //关闭数据库
    [dataBase close];
    
}

//删
+ (void)removeNote:(NoteModel *)note
{
    EGODatabase *dataBase = [[EGODatabase alloc] initWithPath:DataBaseFilePath];
    [dataBase open];
    NSString *sql = [NSString stringWithFormat:@"delete from t_notes where noteTimeTitle = '%@' and noteTime = '%@'",note.timeTitle,note.time];
    [dataBase executeUpdate:sql];
    [dataBase close];
    
}


//查找数据
+ (void)searchNote:(void(^)(NSMutableArray *ary))completionBlcok
{
    NSLog(@"%@",DataBaseFilePath);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableArray *dataAry = [NSMutableArray array];
        
        //数据库句柄 代表了数据库的全部信息
        sqlite3 *sqlite = NULL;
        int result = sqlite3_open([DataBaseFilePath UTF8String], &sqlite);
        if (result != SQLITE_OK) {
            NSLog(@"数据库打开失败");
        }
        
        
        //2 预编译SQL DQL也需要进行预编译操作
        NSString *sql = @"SELECT * FROM t_notes";
        sqlite3_stmt *stmt = NULL;
        result = sqlite3_prepare(sqlite, [sql UTF8String], -1, &stmt, NULL);
        if (result != SQLITE_OK) {
            NSLog(@"预编译失败");
            sqlite3_close(sqlite);

        }
        
        //向占位符上绑定数据
        
        
        //执行SQL语句 DQL和DML不同
        int hasData = sqlite3_step(stmt);
        
        //代表当前有一行数据
        while (hasData == SQLITE_ROW) {
            //读出当前数据的每一个字段内容
            const unsigned char *noteTime = sqlite3_column_text(stmt, 0);//读出档期那数据饿第一列内容
            const unsigned char *noteTimeTitle = sqlite3_column_text(stmt, 2);
            const unsigned char *noteTitle = sqlite3_column_text(stmt, 1);
            const unsigned char *noteContext = sqlite3_column_text(stmt, 3);
            const unsigned char *noteImage = sqlite3_column_text(stmt, 4);
            //            int age = sqlite3_column_int(stmt, 2);
            
            //填充UserModel
            NoteModel *note = [[NoteModel alloc] init];
            note.time = [NSString stringWithCString:(const char*)noteTime encoding:NSUTF8StringEncoding];
            note.timeTitle = [NSString stringWithCString:(const char*)noteTimeTitle encoding:NSUTF8StringEncoding];
            note.title = [NSString stringWithCString:(const char*)noteTitle encoding:NSUTF8StringEncoding];
            note.context = [NSString stringWithCString:(const char*)noteContext encoding:NSUTF8StringEncoding];
            note.image = [NSString stringWithCString:(const char*)noteImage encoding:NSUTF8StringEncoding];
            
            if ([note.context isEqualToString:@"nil"]) {
                note.context = nil;
            }
            if ([note.image isEqualToString:@"nil"]) {
                note.image = nil;
            }
            
            
            [dataAry insertObject:note atIndex:0];
            
            hasData = sqlite3_step(stmt);
        }
        
        sqlite3_finalize(stmt);
        sqlite3_close(sqlite);
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlcok(dataAry);
        });
    });
    
    
    /*
    //数据库构造对象
    EGODatabase *databsae = [[EGODatabase alloc] initWithPath:DataBaseFilePath];
    NSLog(@"%@",DataBaseFilePath);
    //打开数据库
    [databsae open];
    //数据库语句
    NSString *sql = @"SELECT * FROM t_notes";
    EGODatabaseRequest *request = [databsae requestWithQuery:sql];
    [request setCompletion:^(EGODatabaseRequest *request, EGODatabaseResult *result, NSError *error) {
        NSLog(@"%@",error);
        if (!error) {
            NSMutableArray *dataAry = [NSMutableArray array];
            for (int index = 0; index < result.count; index ++) {
                EGODatabaseRow *row = result.rows[index];
                NoteModel *noteModel = [[NoteModel alloc] init];
                noteModel.time = [row stringForColumn:@"noteTime"];
                noteModel.timeTitle = [row stringForColumn:@"noteTimeTitle"];
                noteModel.title = [row stringForColumn:@"noteTitle"];
                noteModel.context = [row stringForColumn:@"noteContext"];
                noteModel.image = [row stringForColumn:@"noteImage"];
                
                if ([noteModel.context isEqualToString:@"nil"]) {
                    noteModel.context = nil;
                }
                if ([noteModel.image isEqualToString:@"nil"]) {
                    noteModel.image = nil;
                }
                [dataAry insertObject:noteModel atIndex:0];
            }
            
            completionBlcok(dataAry);
        }
    }];
    
    //创建对列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:request];
    
    //关闭数据库
    [databsae close];
     */
}

@end
