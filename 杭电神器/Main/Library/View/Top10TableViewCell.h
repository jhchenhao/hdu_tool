//
//  Top10TableViewCell.h
//  杭电神器
//
//  Created by 吴玉铁 on 15/9/26.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookModel.h"
@interface Top10TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *bookNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *readCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thumb1ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thumb2ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thumb3ImageView;

@property (nonatomic,strong) BookModel *bookModel;

@end
