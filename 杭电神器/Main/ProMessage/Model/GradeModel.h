//
//  GradeModel.h
//  杭电神器
//
//  Created by 吴玉铁 on 15/10/4.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import "BaseModel.h"

@interface GradeModel : BaseModel

@property (nonatomic,copy) NSString *CJ; //成绩
@property (nonatomic,copy) NSString *KCMC; //课程名称
@property (nonatomic,copy) NSString *KCXZ; //课程性质
@property (nonatomic,copy) NSString *XF; //学分
@property (nonatomic,copy) NSString *ZSCJ;//真实成绩


@end
