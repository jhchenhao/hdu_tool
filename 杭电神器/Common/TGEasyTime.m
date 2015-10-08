//
//  TGEasyTime.m
//  杭电神器
//
//  Created by 吴玉铁 on 15/10/1.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import "TGEasyTime.h"

@implementation TGEasyTime



+ (NSInteger)tgEasyGetCurrentWeekDay{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitWeekday;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    return [dateComponent weekday] - 1;
}


+ (NSString *)tgEasyGetCurrentDate{
    NSDate *now = [NSDate date];
    NSTimeZone *zone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setTimeZone:zone];
    [formatter setDateFormat:@"yyyy MM dd"];
    //年 月 日
    return [formatter stringFromDate:now];
}



@end
