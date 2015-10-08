//
//  NoteDB.h
//  项目3
//
//  Created by mac on 15/10/2.
//  Copyright (c) 2015年 chenhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoteModel.h"

@interface NoteDB : NSObject
//DDL
//创建数据库
+ (void)createData;

//DML
//增加一条数据
+ (void)addNote:(NoteModel *)note;

//删除数据
+ (void)removeNote:(NoteModel *)note;


//DQL
//查找数据库
+ (void)searchNote:(void(^)(NSMutableArray *ary))completionBlcok;


@end
