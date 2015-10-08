//
//  DailySchedule.m
//  杭电神器
//
//  Created by 吴玉铁 on 15/9/30.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import "DailySchedule.h"

@implementation DailySchedule

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self _createViews];
    }
    return self;
}

- (void)setDailyClass:(NSArray *)dailyClass{
    if (_dailyClass != dailyClass) {
        _dailyClass = dailyClass;
        [self setNeedsLayout];
    }
}

- (void)setWeekDay:(NSInteger)weekDay{
    if (_weekDay != weekDay) {
        _weekDay = weekDay;
        
        NSArray *weekDayArray = @[@"星期一",
                                  @"星期二",
                                  @"星期三",
                                  @"星期四",
                                  @"星期五",
                                  @"星期六",
                                  @"星期日"];
        _timeLabel.text = [NSString stringWithFormat:@"%@  %@",weekDayArray[self.weekDay],[TGEasyTime tgEasyGetCurrentDate]];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    //遍历一遍该天课程 分成2节和3节,调用方法创建
    for (ClassModel *class in self.dailyClass) {
        NSInteger classCount = [class.endat integerValue] - [class.beginat integerValue] + 1;
        [self createClassesViewWithClassModel:class beginAt:class.beginat ClassCount:classCount];
    }
   
}

#pragma mark-创建主视图
- (void)_createViews{

    CGFloat viewWidth = self.bounds.size.width;
    CGFloat classHeight = (self.bounds.size.height - 40) / 12;
    NSArray *amArray = @[@"第1节 08:05~08:50",
                         @"第2节 08:55~09:40",
                         @"第3节 10:00~10:45",
                         @"第4节 10:50~11:35",
                         @"第5节 11:40~12:25"];
    NSArray *pmArray = @[@"第6节 13:35~14:20",
                         @"第7节 14:25~15:10",
                         @"第8节 15:15~16:00",
                         @"第9节 16:05~16:50"];
    NSArray *nightArray = @[@"第10节 18:30~19:15",
                            @"第11节 19:20~20:05",
                            @"第12节 20:10~20:55"];
    //背景视图
    _bgView = [[UIView alloc]initWithFrame:self.bounds];
    _bgView.backgroundColor = [UIColor colorWithRed:214/255.0 green:227/255.0 blue:181/255.0 alpha:1];
    [self addSubview:_bgView];
    //提示按钮
    UIButton *tipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [tipButton setImage:[UIImage imageNamed:@"schedule_tip"] forState:UIControlStateNormal];
    tipButton.frame = CGRectMake(0, 0, 40, 45);
    [_bgView addSubview:tipButton];
    [tipButton addTarget:self action:@selector(tipAction) forControlEvents:UIControlEventTouchUpInside];
    //刷新按钮
    UIButton *reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    reloadButton.frame = CGRectMake(0, 0, 40, 40);
    reloadButton.right = _bgView.right;
    [reloadButton setImage:[UIImage imageNamed:@"schedule_sync"] forState:UIControlStateNormal];
    [_bgView addSubview:reloadButton];
    [reloadButton addTarget:self action:@selector(reloadAction) forControlEvents:UIControlEventTouchUpInside];
    //星期几 年月日
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 160, 40)];
    _timeLabel.left = tipButton.right + 35;
    _timeLabel.font = [UIFont systemFontOfSize:18];
    _timeLabel.text = [NSString stringWithFormat:@"星期一  %@",[TGEasyTime tgEasyGetCurrentDate]];
    [_bgView addSubview:_timeLabel];
    
    //上午 5节课
    UIImageView *morningView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 40, viewWidth,classHeight * 5 - 10)];
    morningView.image = [UIImage imageNamed:@"bg_morning@2x"];
    [_bgView addSubview:morningView];
    [morningView addSubview:[self createDailyTimeViewWithTitle:@"上午"]];
    [morningView addSubview:[self createClassTimeViewWithClassTime:amArray]];
    //下午 4节课
    UIImageView *afternoonView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, viewWidth,classHeight * 4)];
    afternoonView.top = morningView.bottom;
    afternoonView.image = [UIImage imageNamed:@"bg_afternoon@2x"];
    [_bgView addSubview:afternoonView];
    [afternoonView addSubview:[self createDailyTimeViewWithTitle:@"下午"]];
    [afternoonView addSubview:[self createClassTimeViewWithClassTime:pmArray]];
    //晚上 3节课
    UIImageView *nightView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, viewWidth,classHeight * 3 + 10)];
    nightView.top = afternoonView.bottom;
    nightView.image = [UIImage imageNamed:@"bg_night@2x"];
    [_bgView addSubview:nightView];
    [nightView addSubview:[self createDailyTimeViewWithTitle:@"晚上"]];
    [nightView addSubview:[self createClassTimeViewWithClassTime:nightArray]];
    
}

#pragma mark-写个方法创建上午下午晚上标签视图
- (UIView *)createDailyTimeViewWithTitle:(NSString *)title{
    //背景
    UIView *BgView = [[UIView alloc]initWithFrame:CGRectMake(5, 0, 100, 35)];
    BgView.backgroundColor = [UIColor clearColor];
    //图标
    UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 35)];
    icon.image = [UIImage imageNamed:@"countdown@2x"];
    [BgView addSubview:icon];
    //时间标签
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, -1, 70, 40)];
    label.left = icon.right;
    label.text = title;
    label.font = [UIFont boldSystemFontOfSize:20];
    [BgView addSubview:label];
    
    return BgView;
}

#pragma mark-写个方法创建每节课的时间标签视图
- (UIView *)createClassTimeViewWithClassTime:(NSArray *)timeArray{
    CGFloat classHeight = (self.bounds.size.height - 20 - 3 * 40) / 12;
    NSInteger classCount = timeArray.count;
    //背景
    UIView *BgView = [[UIView alloc]initWithFrame:CGRectMake(0, 30, 140, classCount * classHeight)];
    BgView.backgroundColor = [UIColor clearColor];
    for (int i = 0; i < classCount; i++) {
        //时间标签
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10,i * classHeight, 140, classHeight)];
        label.text = timeArray[i];
        label.font = [UIFont systemFontOfSize:14];
        [BgView addSubview:label];
    }
    return BgView;
}

#pragma mark-头上两个按钮动作
- (void)tipAction{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"上学提示" message:@"1.点击右上角按钮可以查看整周课表! 2.点击右边按钮可以刷新最新课程表!" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)reloadAction{
    
    ClassScheduleViewController *classVc = (ClassScheduleViewController *)self.viewController;
    [classVc _loadScheduleData];
}



#pragma mark-写个方法创建2或者3节课的课程信息
- (void)createClassesViewWithClassModel:(ClassModel*)classModel
                                beginAt:(NSString *)beginAt
                             ClassCount:(NSInteger)classCount{
    NSInteger begin = [beginAt integerValue];
    CGFloat classHeight = (self.bounds.size.height - 20 - 3 * 40) / 12;
    //背景视图
    UIView *BgView = [[UIView alloc]init];
    BgView.layer.cornerRadius = 10;
    BgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    //做判断 分成，上午。下午。晚上
    if (begin > 0 && begin < 6) {
        BgView.frame = CGRectMake(150, 72 + classHeight * (begin - 1), self.width - 150, classHeight * classCount);
    }else if(begin > 5 && begin < 10){
        BgView.frame = CGRectMake(150, 72 + 32.5 + classHeight * (begin - 1), self.width - 150, classHeight * classCount);
    }else if(begin >9 && begin < 13){
        BgView.frame = CGRectMake(150, 72 + 32.5 * 2 + classHeight * (begin - 1), self.width - 150, classHeight * classCount);
    }
    //课名
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, BgView.width, BgView.height / 4)];
    name.text = classModel.kcmc;
    name.font = [UIFont systemFontOfSize:13];
    [BgView addSubview:name];
    name.textAlignment = NSTextAlignmentCenter;
    //上课周数
    UILabel *weekCount = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, BgView.width, BgView.height / 4)];
    weekCount.top = name.bottom;
    weekCount.text = [NSString stringWithFormat:@"%@-%@",classModel.qsz,classModel.jsz];
    weekCount.font = [UIFont systemFontOfSize:13];
    weekCount.textAlignment = NSTextAlignmentCenter;
    [BgView addSubview:weekCount];
    //老师
    UILabel *teacherName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, BgView.width, BgView.height / 4)];
    teacherName.top = weekCount.bottom;
    teacherName.text = classModel.jsxm;
    teacherName.font = [UIFont systemFontOfSize:13];
    teacherName.textAlignment = NSTextAlignmentCenter;
    [BgView addSubview:teacherName];
    //教室
    UILabel *classRoom = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, BgView.width, BgView.height / 4)];
    classRoom.top = teacherName.bottom;
    classRoom.text = classModel.skdd;
    classRoom.font = [UIFont systemFontOfSize:13];
    classRoom.textAlignment = NSTextAlignmentCenter;
    [BgView addSubview:classRoom];
    
    [_bgView addSubview:BgView];
}





@end
