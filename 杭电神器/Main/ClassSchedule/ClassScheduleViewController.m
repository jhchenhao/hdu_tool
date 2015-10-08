//
//  ClassScheduleViewController.m
//  杭电神器
//
//  Created by 吴玉铁 on 15/9/25.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import "ClassScheduleViewController.h"

@interface ClassScheduleViewController (){
    iCarousel *_carousel;
    NSMutableArray *_classData;
    MBProgressHUD *_HUD;
    WeekSchedule *_weekSchedule;
}

@end

@implementation ClassScheduleViewController

- (void)dealloc
{
    _carousel.delegate = nil;
    _carousel.dataSource = nil;
   // [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setRightItem];
    [self _createViews];
    //接受通知
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(_loadScheduleData) name:kLoadScheduleData object:nil];
    //刚进去推到今天星期几的位置
    NSInteger today = [TGEasyTime tgEasyGetCurrentWeekDay];
    [_carousel scrollToItemAtIndex:(today - 1) animated:NO];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //做判断，第一次进去给个用法提示
    NSString *isFirstTip = [userDefaults objectForKey:kClassScheduleTip];
    if (isFirstTip.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"上学提示" message:@"1.点击右上角按钮可以查看整周课表! 2.点击右边按钮可以刷新最新课程表!" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
        isFirstTip = @"1";
        [userDefaults setObject:isFirstTip forKey:kClassScheduleTip];
    }
     //载入做判断,载过一次直接读取本地
    NSArray *datas = [userDefaults objectForKey:kClassScheduleData];
    if (datas.count == 0) {
        [self _loadScheduleData];
    }else{
        NSMutableArray *userData = [NSMutableArray arrayWithCapacity:7];
        for (NSArray *arr in datas) {
            NSMutableArray *tempArray = [NSMutableArray array];
            for (NSData *modelData in arr) {
                ClassModel *class = [NSKeyedUnarchiver unarchiveObjectWithData:modelData];
                [tempArray addObject:class];
            }
            [userData addObject:tempArray];
            tempArray = nil;
        }
        _classData = userData;
        [_carousel reloadData];
    }
}

- (void)_loadScheduleData{
    [self showHUD:@"更新课表中"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [MyNetWorkQuery AFrequestData:class_schedule HTTPMethod:@"POST" params:params completionHandle:^(id result) {
        [self _parseData:result];
        [self completeHUD:@"更课表新完毕"];
        
    } errorHandle:nil];
    
    
}

#pragma mark-将拿到到数据根据星期几分成7天
- (void)_parseData:(NSArray *)data{
    //大循环7次,分成7个array加到data里,同时转码为data，便于存入UserDeafult
    _classData = [NSMutableArray arrayWithCapacity:7];
    NSMutableArray *userData = [NSMutableArray arrayWithCapacity:7];
    for (NSInteger i = 1; i < 8; i++) {
            NSMutableArray *tempArray = [NSMutableArray array];
            NSMutableArray *tempDataArray = [NSMutableArray array];
        for (NSDictionary *dataDic in data) {
            NSString *xqjString = dataDic[@"xqj"];
            NSString *indexStr = [NSString stringWithFormat:@"%ld",(long)i];
            if ([xqjString isEqualToString:indexStr]) {
                ClassModel *classModel = [[ClassModel alloc]initWithDataDic:dataDic];
                [tempArray addObject:classModel];
                NSData *modelData = [NSKeyedArchiver archivedDataWithRootObject:classModel];
                [tempDataArray addObject:modelData];
            }
        }
        [_classData addObject:tempArray];
        [userData addObject:tempDataArray];
        tempArray = nil;
        tempDataArray = nil;
    }
    //两个视图都重新加载数据
    _weekSchedule.weekClasses = _classData;
    [_carousel reloadData];
    //转码完数据存入用户中心
    [[NSUserDefaults standardUserDefaults]setObject:userData forKey:kClassScheduleData];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

#pragma mark-右边翻转按钮RightItemButton
- (void)_setRightItem{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 40, 40);
    [rightButton setBackgroundImage:[UIImage imageNamed:@"schedule_day"] forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"schedule_week"] forState:UIControlStateSelected];
    [rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
}

#pragma mark-控制器视图的创建
- (void)_createViews{
    _carousel = [[iCarousel alloc]initWithFrame:CGRectMake(0,0,kScreenWidth, kScreenHeight - 64 - 49)];
    _carousel.delegate = self;
    _carousel.dataSource = self;
    _carousel.type = iCarouselTypeRotary;
    _carousel.pagingEnabled = YES;
    [self.view addSubview:_carousel];
}

#pragma mark-导航栏右按钮动作
- (void)rightButtonAction:(UIButton *)button{
    button.selected = !button.selected;
    BOOL isSelected = button.selected;
    UIViewAnimationOptions option = isSelected ? UIViewAnimationOptionTransitionFlipFromLeft:UIViewAnimationOptionTransitionFlipFromRight;
    //周课表
    if (_weekSchedule == nil) {
        _weekSchedule = [[WeekSchedule alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 49)];
        _weekSchedule.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_weekSchedule];
        _weekSchedule.hidden = YES;
        _weekSchedule.weekClasses = _classData;
    }
    
    [UIView transitionWithView:button duration:0.5 options:option animations:^{
        _weekSchedule.hidden = !_weekSchedule.hidden;
    } completion:nil];
    
    [UIView transitionWithView:self.view duration:0.5 options:option animations:^{
        
    } completion:nil];
    
}

#pragma mark-旋转木马数据源和代理
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return 7;
}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(nullable UIView *)view{
    DailySchedule *daySche = nil;
    //复用你懂得
    if (view == nil){
        view = [[UIView alloc] initWithFrame:CGRectMake(30, 20, kScreenWidth - 60, kScreenHeight - 64 - 49 - 40)];
        daySche = [[DailySchedule alloc] initWithFrame:view.bounds];
        daySche.tag = 1;
        [view addSubview:daySche];
    }else{
        daySche = (DailySchedule *)[view viewWithTag:1];
    }
    daySche.dailyClass = _classData[index];
    daySche.weekDay = index;
    NSInteger today = [TGEasyTime tgEasyGetCurrentWeekDay] - 1;
    if (index == today) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(35, 2, 36, 36)];
        button.enabled = NO;
        [button setBackgroundImage:[UIImage imageNamed:@"today_icon"] forState:UIControlStateNormal];
        [button setTitle:@"今" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"JMiMi" size:20];
        [button setTitleColor:[UIColor colorWithRed:0 green:0.5 blue:1 alpha:1] forState:UIControlStateNormal];
        [daySche addSubview:button];
    }
    return view;
}
#pragma mark-第三方加载
//第三方加载
- (void)showHUD:(NSString *)title{
   
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _HUD.mode = MBProgressHUDModeIndeterminate;
    _HUD.yOffset = -30;
    _HUD.cornerRadius = 10;
  
    [_HUD show:YES];
    
    _HUD.labelColor = [UIColor colorWithRed:0 green:0.6 blue:1 alpha:1];
    _HUD.labelFont = [UIFont fontWithName:@"JLinBo" size:17];
    _HUD.labelText = title;
    
}
- (void)hideHUD{
    [_HUD hide:YES];
}
- (void)completeHUD:(NSString *)title{
    _HUD.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"completed_icon"]];
    _HUD.mode = MBProgressHUDModeCustomView;
    _HUD.labelText = title;
    [_HUD hide:YES afterDelay:1.0];
}


@end
