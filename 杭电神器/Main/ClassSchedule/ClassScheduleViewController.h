//
//  ClassScheduleViewController.h
//  杭电神器
//
//  Created by 吴玉铁 on 15/9/25.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import "BaseViewController.h"
#import "iCarousel.h"
#import "DailySchedule.h"
#import "MyNetWorkQuery.h"
#import "MBProgressHUD.h"
#import "WeekSchedule.h"

@interface ClassScheduleViewController : BaseViewController<iCarouselDataSource,iCarouselDelegate>


- (void)_loadScheduleData;

@end
