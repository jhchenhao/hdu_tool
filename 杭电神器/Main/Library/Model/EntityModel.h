//
//  EntityModel.h
//  杭电神器
//
//  Created by 吴玉铁 on 15/9/28.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import "BaseModel.h"

@interface EntityModel : BaseModel

@property (nonatomic,copy) NSString *campus;
@property (nonatomic,copy) NSString *location;
@property (nonatomic,copy) NSString *lend_or_not;


@end
