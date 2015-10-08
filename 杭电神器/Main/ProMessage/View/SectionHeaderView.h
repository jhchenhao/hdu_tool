//
//  SectionHeaderView.h
//  杭电神器
//
//  Created by 吴玉铁 on 15/10/2.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionHeaderView : UIView{
    UIImageView *_icon;
    UILabel *_title;
}


- (void)configIcon:(NSString *)imageName Title:(NSString *)title;

@end
