//
//  GradeViewController.h
//  杭电神器
//
//  Created by 吴玉铁 on 15/10/3.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "GradeDetailView.h"
#import "MyNetWorkQuery.h"

@interface GradeViewController : UIViewController<iCarouselDataSource,iCarouselDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@end

