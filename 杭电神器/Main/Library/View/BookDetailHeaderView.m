
//
//  BookDetailHeaderView.m
//  杭电神器
//
//  Created by 吴玉铁 on 15/9/28.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import "BookDetailHeaderView.h"

@implementation BookDetailHeaderView


- (void)setSearchBookModel:(SearchBookModel *)searchBookModel{
    if (_searchBookModel != searchBookModel) {
        _searchBookModel = searchBookModel;
        //书名
        _bookNameLabel.numberOfLines = 0;
        NSString *nameString = [NSString stringWithFormat:@"书名: %@",self.searchBookModel.name];
        _bookNameLabel.attributedText = [self changeTextColorWithString:nameString location:0 length:4];
        //作者
        NSString *authorString = [NSString stringWithFormat:@"作者: %@",self.searchBookModel.author];
        _authorLabel.attributedText = [self changeTextColorWithString:authorString location:0 length:4];
        //出版社
        NSString *publishString = [NSString stringWithFormat:@"出版社: %@",self.searchBookModel.publisher];
        _publisherLabel.attributedText = [self changeTextColorWithString:publishString location:0 length:4];
        //索引书号
        NSString *indexString = [NSString stringWithFormat:@"索引号: %@",self.searchBookModel.position];
        _indexLabel.attributedText = [self changeTextColorWithString:indexString location:0 length:4];
        //阅读数
         NSString *readCountString = [NSString stringWithFormat:@"已经被人读过 %@次",self.searchBookModel.count_lent];
        _readCountLabel.attributedText = [self changeTextColorWithString:readCountString location:7 length:readCountString.length - 8];
    }
}
//写个方法 混字体颜色：黑灰混色
- (NSMutableAttributedString *)changeTextColorWithString:(NSString *)string
                         location:(NSUInteger)loc
                           length:(NSUInteger)len{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:string];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(loc,len)];
    return attributedString;
}



@end
