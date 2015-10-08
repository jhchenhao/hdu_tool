//
//  LendTableViewCell.h
//  杭电神器
//
//  Created by 吴玉铁 on 15/10/3.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LendBookModel.h"
#import "TGEasyAttributeText.h"


@interface LendTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *bookNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic,strong) LendBookModel *model;

@end
