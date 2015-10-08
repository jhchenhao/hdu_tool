//
//  SearchBookCell.h
//  杭电神器
//
//  Created by 吴玉铁 on 15/9/27.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchBookModel.h"

@interface SearchBookCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *bookNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *indexLabel;
@property (nonatomic,strong) SearchBookModel *searchBookModel;

@end
