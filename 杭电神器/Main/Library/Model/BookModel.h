//
//  BookModel.h
//  杭电神器
//
//  Created by 吴玉铁 on 15/9/26.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import "BaseModel.h"

@interface BookModel : BaseModel

@property (nonatomic,strong) NSNumber *amount_lent;//借阅次数
@property (nonatomic,copy) NSString *id_book;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,strong) NSNumber *num; //排名


@end
