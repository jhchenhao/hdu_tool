//
//  LendTableViewCell.m
//  杭电神器
//
//  Created by 吴玉铁 on 15/10/3.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import "LendTableViewCell.h"

@implementation LendTableViewCell



- (void)setModel:(LendBookModel *)model{
    if (_model != model) {
        _model = model;
        [self setNeedsLayout];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _bookNameLabel.text = self.model.name;
    _bookNameLabel.numberOfLines = 0;
    if (self.model.author) {
        _authorLabel.text = self.model.author;
    }
    if (self.model.date_deadline) {
        //当前借阅 把欠书天书记下，判断第一组做处理
        if (self.model.date_lend.length == 0) {
            NSString *overTime = [NSString stringWithFormat:@"%@",self.model.date_surplus];
            NSString *newOverTime = [overTime substringFromIndex:1];
            NSLog(@"%@",newOverTime);
            NSString *text = [NSString stringWithFormat:@"%@ ~~ ? 欠了 %@天",self.model.date_deadline,newOverTime];
            _timeLabel.attributedText = [TGEasyAttributeText changeTextColorWithString:text location:(self.model.date_deadline.length + 9) length:newOverTime.length  textColor:[UIColor redColor]];
        }else{
            _timeLabel.text = [NSString stringWithFormat:@"%@ ~~ %@",self.model.date_lend,self.model.date_deadline];
        }
    }

}



@end
