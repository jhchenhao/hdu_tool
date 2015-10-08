//
//  TGEasyAttributeText.m
//  杭电神器
//
//  Created by 吴玉铁 on 15/10/3.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import "TGEasyAttributeText.h"

@implementation TGEasyAttributeText


//写个方法 混字体颜色：混色
+ (NSMutableAttributedString *)changeTextColorWithString:(NSString *)string
                                                location:(NSUInteger)loc
                                                  length:(NSUInteger)len
                                               textColor:(UIColor *)color{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:string];
    [attributedString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(loc,len)];
    
    return attributedString;
}

+ (void)changgeTextColorWithLable:(UILabel *)label
                         location:(NSUInteger)loc
                           length:(NSUInteger)len
                        textColor:(UIColor *)color{
    NSString *string = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:string];
    [attributedString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(loc,len)];
    
    label.text = nil;
    label.attributedText = attributedString;
    
}


@end
