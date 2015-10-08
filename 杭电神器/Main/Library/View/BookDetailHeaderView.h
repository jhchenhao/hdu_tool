//
//  BookDetailHeaderView.h
//  杭电神器
//
//  Created by 吴玉铁 on 15/9/28.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchBookModel.h"

@interface BookDetailHeaderView : UIView{
    UIView *_headerView;
}

@property (nonatomic,strong) SearchBookModel *searchBookModel;

@property (weak, nonatomic) IBOutlet UIImageView *bookCoverView;
@property (weak, nonatomic) IBOutlet UILabel *bookNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *publisherLabel;
@property (weak, nonatomic) IBOutlet UILabel *indexLabel;
@property (weak, nonatomic) IBOutlet UILabel *readCountLabel;


@end
