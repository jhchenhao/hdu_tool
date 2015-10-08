//
//  WeekSchedule.m
//  杭电神器
//
//  Created by 吴玉铁 on 15/10/1.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import "WeekSchedule.h"

@implementation WeekSchedule


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _createBorderViews];
        [self setNeedsLayout];
    }
    return self;
}

- (void)setWeekClasses:(NSArray *)weekClasses{
    if (_weekClasses != weekClasses) {
        _weekClasses = weekClasses;
        [self setNeedsLayout];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    //遍历数组，创建课程
    //相同课程做判断，颜色一样
    //做法：根据课程名字，与之前的课程名对比，相同的话通过tag拿到之前的视图
    NSInteger index = 0;
    NSMutableArray *courseNames = [NSMutableArray array];
    if (self.weekClasses.count > 0) {
        for (NSInteger i = 0;i < self.weekClasses.count;i ++) {
            NSArray *array = self.weekClasses[i];
            for (NSInteger j = 0;j < array.count;j ++) {
                ClassModel *class = array[j];
                UIView *view = [self createClassesViewWithClassModel:class beginAt:class.beginat endAt:class.endat weekDat:class.xqj];
                view.tag = 100 + index;
                index ++;
                //遍历课程数组，名字相同则改变view的背景色与前tempView相同
                for (NSInteger k = 0;k < courseNames.count;k ++) {
                    NSString *name = courseNames[k];
                    if ([class.kcmc isEqualToString:name]) {
                        UIView *tempView = (UIView *)[_weekView viewWithTag:100 + k];
                        view.backgroundColor = tempView.backgroundColor;
                    }
                }
                [courseNames addObject:class.kcmc];
            }
        }
        
    }
}

//创建横竖边缘视图
- (void)_createBorderViews{
    
    //背景图片视图
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
    imageView.image = [UIImage imageNamed:@"detail_book_bg"];
    [self addSubview:imageView];
    //数组
    NSArray *weekDays = @[@"一",@"二",@"三",@"四",@"五",@"六",@"日"];
    //头部标签
    CGFloat headerLabelWidth = (kScreenWidth - 30) / 7;
    for (NSInteger i = 0; i < 7; i ++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(30 + headerLabelWidth * i, 0, headerLabelWidth, 30)];
        label.layer.borderWidth = 0.3f;
        label.layer.borderColor = [UIColor colorWithRed:0 green:0.6 blue:1 alpha:1].CGColor;
        label.text = [NSString stringWithFormat:@"周%@",weekDays[i]];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:10];
        [self addSubview:label];
    }
    if (_weekView == nil) {
        _weekView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,30, kScreenWidth, kScreenHeight - 64 - 49 - 30)];
        _weekView.backgroundColor = [UIColor clearColor];
        _weekView.contentSize = CGSizeMake(kScreenWidth, 50 * 12);
        _weekView.bounces = NO;
        [self addSubview:_weekView];
    }
    //高度设死50一个
    for (NSInteger i = 0; i < 12; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0.3,50 * i, 30, 50)];
        label.layer.borderWidth = 0.25f;
        label.layer.borderColor = [UIColor colorWithRed:0 green:0.6 blue:1 alpha:1].CGColor;
        label.text = [NSString stringWithFormat:@"%ld",i + 1];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        [_weekView addSubview:label];
    }
}

#pragma mark-写个方法创建每节课的课程信息
- (UIView *)createClassesViewWithClassModel:(ClassModel*)classModel
                                beginAt:(NSString *)beginAt
                                  endAt:(NSString *)endAt
                                weekDat:(NSString *)weekDay{
    NSInteger begin = [beginAt integerValue];
    NSInteger count = ([endAt integerValue] - begin + 1);
    NSInteger day = [weekDay integerValue];
    //背景视图
    UIView *BgView = [[UIView alloc]init];
    BgView.backgroundColor = [UIColor colorWithRed:arc4random()%255 / 255.0 green:arc4random()%255 / 255.0 blue:rand()%255 / 255.0 alpha:0.5];
    BgView.layer.cornerRadius = 10;
    //高度50*节数
    CGFloat courseHeight = 50 * count;
    //宽度设死（kscreen－ 30）／ 7
    CGFloat courseWidth = (kScreenWidth - 30) / 7 - 1;
    //根据周一到周五 设置x
    CGFloat x = 30 + (kScreenWidth - 30) / 7 * (day - 1);
    //根据1-12节设置y
    CGFloat y = courseHeight * (begin - 1);
    BgView.frame = CGRectMake(x, y, courseWidth, courseHeight);
    //课名 教室拼一起
    UILabel *nameAndRoom = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, BgView.width, BgView.height)];
    nameAndRoom.font = [UIFont systemFontOfSize:12];
    nameAndRoom.textAlignment = NSTextAlignmentCenter;
    nameAndRoom.numberOfLines = 0;
    [BgView addSubview:nameAndRoom];
    //富文本
    NSString *string = [NSString stringWithFormat:@"%@@%@",classModel.kcmc,classModel.skdd];
    nameAndRoom.attributedText = [self changeTextColorWithString:string location:classModel.kcmc.length length:1];
    [_weekView addSubview:BgView];
    return BgView;
}

//写个方法 混字体颜色：黑灰混色
- (NSMutableAttributedString *)changeTextColorWithString:(NSString *)string
                                                location:(NSUInteger)loc
                                                  length:(NSUInteger)len{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:string];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(loc,len)];
    return attributedString;
}




@end
