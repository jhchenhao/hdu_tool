//
//  NoteModel.h
//  项目3
//
//  Created by mac on 15/10/2.
//  Copyright (c) 2015年 chenhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoteModel : NSObject

@property (nonatomic, copy) NSString *title;    //标题
@property (nonatomic, copy) NSString *context;   //内容
@property (nonatomic, copy) NSString *time;     //时间
@property (nonatomic, copy) NSString *timeTitle; //时间标题
@property (nonatomic, copy) NSString *image;  //图片路径


@end
