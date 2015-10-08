//
//  NewsPlistTableViewCell.m
//  项目3
//
//  Created by mac on 15/9/28.
//  Copyright (c) 2015年 chenhao. All rights reserved.
//

#import "NewsPlistTableViewCell.h"

@implementation NewsPlistTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(PlistModel *)model
{
    if (_model != model) {
        _model = model;
        //self.context
        self.content.font = [UIFont boldSystemFontOfSize:16];
        CGFloat height = [WXLabel getTextHeight:25 width:kScreenWidth text:model.title linespace:1.0];
        self.content.height = height;
        self.content.text = model.title;
        //设置时间
        self.time.text = model.time;
        self.time.font = [UIFont systemFontOfSize:13];
        
        self.icon.contentMode = UIViewContentModeScaleToFill;
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
