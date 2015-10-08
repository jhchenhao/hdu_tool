


//
//  GradeDetailView.m
//  杭电神器
//
//  Created by 吴玉铁 on 15/10/4.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import "GradeDetailView.h"

@implementation GradeDetailView

- (void)setGradeModel:(GradeModel *)gradeModel{
    if (_gradeModel != gradeModel) {
        _gradeModel = gradeModel;
        _courseNameLabel.text = [NSString stringWithFormat:@"课程名称:%@",self.gradeModel.KCMC];
        _courseNameLabel.numberOfLines = 0;
        
        [TGEasyAttributeText changgeTextColorWithLable:_courseNameLabel location:5 length:self.gradeModel.KCMC.length textColor:[UIColor colorWithRed:0 green:0.6 blue:1 alpha:1]];
        
        _gradeLabel.text = [NSString stringWithFormat:@"课程成绩:%@",self.gradeModel.CJ];
        [TGEasyAttributeText changgeTextColorWithLable:_gradeLabel location:5 length:self.gradeModel.CJ.length textColor:[UIColor redColor]];
        
        _isRequiredLabel.text = [NSString stringWithFormat:@"课程性质:%@",self.gradeModel.KCXZ];
        [TGEasyAttributeText changgeTextColorWithLable:_isRequiredLabel location:5 length:self.gradeModel.KCXZ.length textColor:[UIColor darkGrayColor]];
        
        _creditLabel.text = [NSString stringWithFormat:@"课程学分:%@",self.gradeModel.XF];
        [TGEasyAttributeText changgeTextColorWithLable:_creditLabel location:5 length:self.gradeModel.XF.length textColor:[UIColor orangeColor]];

        _realGrade.text = [NSString stringWithFormat:@"真实成绩:%@",self.gradeModel.ZSCJ];
        [TGEasyAttributeText changgeTextColorWithLable:_realGrade location:5 length:self.gradeModel.ZSCJ.length textColor:[UIColor redColor]];
    }
}



@end
