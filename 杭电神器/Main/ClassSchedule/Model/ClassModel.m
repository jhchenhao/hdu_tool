//
//  ClassModel.m
//  杭电神器
//
//  Created by 吴玉铁 on 15/9/30.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import "ClassModel.h"

@implementation ClassModel
//@property (nonatomic,copy) NSString *beginat;//开始上课时间
//@property (nonatomic,copy) NSString *endat;//结束上课时间
//@property (nonatomic,copy) NSString *jsxm;//教师名字
//@property (nonatomic,copy) NSString *kcmc;//课程名字
//@property (nonatomic,copy) NSString *skdd;//教室
//@property (nonatomic,copy) NSString *xqj;//星期几
//@property (nonatomic,copy) NSString *qsz;//开始于第几周
//@property (nonatomic,copy) NSString *jsz;//结束于第几周


- (id)initWithCoder:(NSCoder *)aDecoder{
    
    if (self == [super init]) {
        self.beginat = [aDecoder decodeObjectForKey:@"JsonBeginat"];
        self.endat = [aDecoder decodeObjectForKey:@"JsonEndat"];
        self.jsxm = [aDecoder decodeObjectForKey:@"JsonJsxm"];
        self.kcmc = [aDecoder decodeObjectForKey:@"JsonKcmc"];
        self.skdd = [aDecoder decodeObjectForKey:@"JsonSkdd"];
        self.xqj = [aDecoder decodeObjectForKey:@"JsonXqj"];
        self.qsz = [aDecoder decodeObjectForKey:@"JsonQsz"];
        self.jsz = [aDecoder decodeObjectForKey:@"JsonJsz"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.beginat forKey:@"JsonBeginat"];
    [aCoder encodeObject:self.endat forKey:@"JsonEndat"];
    [aCoder encodeObject:self.jsxm forKey:@"JsonJsxm"];
    [aCoder encodeObject:self.kcmc forKey:@"JsonKcmc"];
    [aCoder encodeObject:self.skdd forKey:@"JsonSkdd"];
    [aCoder encodeObject:self.xqj forKey:@"JsonXqj"];
    [aCoder encodeObject:self.qsz forKey:@"JsonQsz"];
    [aCoder encodeObject:self.jsz forKey:@"JsonJsz"];
    
    
}

@end
