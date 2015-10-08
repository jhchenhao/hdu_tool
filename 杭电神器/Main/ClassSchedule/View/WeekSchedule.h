//
//  WeekSchedule.h
//  杭电神器
//
//  Created by 吴玉铁 on 15/10/1.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassModel.h"

@interface WeekSchedule : UIView{
    UIScrollView *_weekView;
}

@property (nonatomic,strong) NSArray * weekClasses;

@end
