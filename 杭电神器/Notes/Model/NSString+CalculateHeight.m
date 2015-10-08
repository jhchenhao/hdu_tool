//
//  NSString+CalculateHeight.m
//  项目3
//
//  Created by mac on 15/10/4.
//  Copyright (c) 2015年 chenhao. All rights reserved.
//

#import "NSString+CalculateHeight.h"

@implementation NSString (CalculateHeight)

//计算label高度
- (CGFloat)getHeightofFont:(UIFont *)font width:(CGFloat)width
{
    CGRect rect = [self boundingRectWithSize:CGSizeMake(width, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : font} context:nil];
    
    return rect.size.height;
}



@end
