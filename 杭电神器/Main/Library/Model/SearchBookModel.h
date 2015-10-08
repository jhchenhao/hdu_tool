//
//  SearchBookModel.h
//  杭电神器
//
//  Created by 吴玉铁 on 15/9/27.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import "BaseModel.h"

@interface SearchBookModel : BaseModel

@property (nonatomic,copy) NSString *author;//作者
@property (nonatomic,copy) NSString *id_book;
@property (nonatomic,copy) NSString *name;
//@property (nonatomic,strong) NSNumber *num; //排名
@property (nonatomic,copy) NSString *position;//位置
@property (nonatomic,copy) NSString *publisher;
@property (nonatomic,strong) NSNumber *count_lent;//一共被借过的次数
@property (nonatomic,strong) NSArray *entity;


@end
