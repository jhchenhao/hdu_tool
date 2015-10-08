//
//  LendBookModel.h
//  杭电神器
//
//  Created by 吴玉铁 on 15/10/3.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import "BaseModel.h"

@interface LendBookModel : BaseModel

@property (nonatomic,copy) NSString *author;
@property (nonatomic,copy) NSString *date_deadline;
@property (nonatomic,copy) NSString *date_lend;//借阅时间
@property (nonatomic,copy) NSString *id_book;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *date_surplus;//超期时间


@end
