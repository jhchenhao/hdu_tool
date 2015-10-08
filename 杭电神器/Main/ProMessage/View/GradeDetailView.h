//
//  GradeDetailView.h
//  杭电神器
//
//  Created by 吴玉铁 on 15/10/4.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GradeModel.h"
#import "TGEasyAttributeText.h"

@interface GradeDetailView : UIView
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *isRequiredLabel;
@property (weak, nonatomic) IBOutlet UILabel *creditLabel;
@property (weak, nonatomic) IBOutlet UILabel *realGrade;

@property (nonatomic,strong) GradeModel *gradeModel;



@end
