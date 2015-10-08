//
//  ClassModel.h
//  杭电神器
//
//  Created by 吴玉铁 on 15/9/30.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import "BaseModel.h"

@interface ClassModel : BaseModel

@property (nonatomic,copy) NSString *beginat;//开始上课时间
@property (nonatomic,copy) NSString *endat;//结束上课时间
@property (nonatomic,copy) NSString *jsxm;//教师名字
@property (nonatomic,copy) NSString *kcmc;//课程名字
@property (nonatomic,copy) NSString *skdd;//教室
@property (nonatomic,copy) NSString *xqj;//星期几
@property (nonatomic,copy) NSString *qsz;//开始于第几周
@property (nonatomic,copy) NSString *jsz;//结束于第几周

@end
