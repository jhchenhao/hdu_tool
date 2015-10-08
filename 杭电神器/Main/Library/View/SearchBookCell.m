//
//  SearchBookCell.m
//  杭电神器
//
//  Created by 吴玉铁 on 15/9/27.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import "SearchBookCell.h"

@implementation SearchBookCell

- (void)setSearchBookModel:(SearchBookModel *)searchBookModel{
    if (_searchBookModel != searchBookModel) {
        _searchBookModel = searchBookModel;
        [self setNeedsLayout];
    }
}


- (void)layoutSubviews{
    [super layoutSubviews];
    //书名
    self.bookNameLabel.text = self.searchBookModel.name;
    self.bookNameLabel.numberOfLines = 0;
    //作者字体变色，和简单判断
    NSString *authorString;
    if (self.searchBookModel.author.length == 0) {
        self.searchBookModel.author = @"不明";
    }
    authorString = [NSString stringWithFormat:@"作者:%@",self.searchBookModel.author];
    NSMutableAttributedString *authorAttributedString = [[NSMutableAttributedString alloc]initWithString:authorString];
    [authorAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(3,self.searchBookModel.author.length)];
    [authorAttributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:NSMakeRange(3,self.searchBookModel.author.length)];
    self.authorLabel.attributedText = authorAttributedString;
    //索引书号
    NSString *indexString;
    if (self.searchBookModel.position.length == 0) {
        indexString = [NSString stringWithFormat:@"索引书号:找不到咯,missing!"];
    }else{
        indexString = [NSString stringWithFormat:@"索引书号:%@",self.searchBookModel.position];
    }
    NSMutableAttributedString *indexAttributedString = [[NSMutableAttributedString alloc]initWithString:indexString];
    [indexAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(5,indexString.length - 5)];
    [indexAttributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:NSMakeRange(5,indexString.length - 5)];
    self.indexLabel.attributedText = indexAttributedString;
    
}


@end
