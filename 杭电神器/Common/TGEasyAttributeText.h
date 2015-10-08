//
//  TGEasyAttributeText.h
//  杭电神器
//
//  Created by 吴玉铁 on 15/10/3.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TGEasyAttributeText : NSObject


+ (NSMutableAttributedString *)changeTextColorWithString:(NSString *)string
                                                location:(NSUInteger)loc
                                                  length:(NSUInteger)len
                                               textColor:(UIColor *)color;

+ (void)changgeTextColorWithLable:(UILabel *)label
                         location:(NSUInteger)loc
                           length:(NSUInteger)len
                        textColor:(UIColor *)color;
@end
