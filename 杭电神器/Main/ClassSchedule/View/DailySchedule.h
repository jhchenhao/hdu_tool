//
//  DailySchedule.h
//  杭电神器
//
//  Created by 吴玉铁 on 15/9/30.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassModel.h"
#import "TGEasyTime.h"
#import "UIView+ViewController.h"
#import "ClassScheduleViewController.h"

@interface DailySchedule : UIView{
    UIView *_bgView;
    UILabel *_timeLabel;
}

@property (nonatomic,strong) NSArray *dailyClass;
@property (nonatomic,assign) NSInteger weekDay;

@end
