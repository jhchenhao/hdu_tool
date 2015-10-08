//
//  SectionHeaderView.m
//  杭电神器
//
//  Created by 吴玉铁 on 15/10/2.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import "SectionHeaderView.h"

@implementation SectionHeaderView



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _createContentViews];
    }
    return self;
}

- (void)_createContentViews{
    _icon = [[UIImageView alloc]initWithFrame:CGRectMake(3, 3, self.height - 5, self.height - 5)];
    [self addSubview:_icon];
    _title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, self.height)];
    _title.left = _icon.right + 5;
    _title.font = [UIFont systemFontOfSize:15];
    [self addSubview:_title];
}

- (void)configIcon:(NSString *)imageName Title:(NSString *)title{
    if (_icon == nil || _title ==nil) {
        return;
    }
    _icon.image = [UIImage imageNamed:imageName];
    _title.text = title;
}


@end
