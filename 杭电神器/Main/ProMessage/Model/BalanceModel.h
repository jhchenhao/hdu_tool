//
//  BalanceModel.h
//  杭电神器
//
//  Created by 吴玉铁 on 15/10/2.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import "BaseModel.h"

@interface BalanceModel : BaseModel

@property (nonatomic,copy) NSString *balance;
@property (nonatomic,strong) NSDictionary *record;

@end

