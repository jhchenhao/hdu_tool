//
//  Top10TableViewCell.m
//  杭电神器
//
//  Created by 吴玉铁 on 15/9/26.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import "Top10TableViewCell.h"

@implementation Top10TableViewCell



- (void)setBookModel:(BookModel *)bookModel{
    if (_bookModel != bookModel) {
        _bookModel = bookModel;
        [self setNeedsLayout];
    }
}

- (void)layoutSubviews{
    //名次和书名
    [super layoutSubviews];
    NSString *bookName = [NSString stringWithFormat:@"%@. %@",self.bookModel.num,self.bookModel.name];
    NSMutableAttributedString *attributedbookName = [[NSMutableAttributedString alloc]initWithString:bookName];
    NSInteger bookNum = [self.bookModel.num integerValue];
    if (bookNum >0 && bookNum< 4) {
        
        [attributedbookName addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:21] range:NSMakeRange(0, 2)];
        [attributedbookName addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0, 2)];
    }
    _bookNameLabel.attributedText = attributedbookName;
    //借阅次数
    NSString *readCountNumStr = [NSString stringWithFormat:@"%@",self.bookModel.amount_lent];
    NSString *readCountStr = [NSString stringWithFormat:@"本周借阅次数 %@",self.bookModel.amount_lent];
    NSMutableAttributedString *readCountAttributedString = [[NSMutableAttributedString alloc]initWithString:readCountStr];
    NSInteger readCount = [self.bookModel.amount_lent integerValue];
    [readCountAttributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:21] range:NSMakeRange(7, readCountNumStr.length)];
    if (readCount > 10 && readCount < 20) {
        [readCountAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(7, readCountNumStr.length)];
        self.thumb3ImageView.hidden = YES;
        self.thumb2ImageView.hidden = NO;
        self.thumb1ImageView.hidden = NO;
    }else if(readCount > 20){
        [readCountAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(7,readCountNumStr.length)];
        self.thumb3ImageView.hidden = NO;
        self.thumb2ImageView.hidden = NO;
        self.thumb1ImageView.hidden = NO;
    }else if(readCount < 10){
        [readCountAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0 green:0.5 blue:1 alpha:1] range:NSMakeRange(7,readCountNumStr.length)];
        self.thumb3ImageView.hidden = YES;
        self.thumb2ImageView.hidden = YES;
        self.thumb1ImageView.hidden = NO;
    }
    self.readCountLabel.attributedText =readCountAttributedString;
}


@end
