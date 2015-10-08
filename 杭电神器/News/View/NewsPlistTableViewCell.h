//
//  NewsPlistTableViewCell.h
//  项目3
//
//  Created by mac on 15/9/28.
//  Copyright (c) 2015年 chenhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlistModel.h"
#import "WXLabel.h"

@interface NewsPlistTableViewCell : UITableViewCell

@property (nonatomic, strong) PlistModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet WXLabel *content;

@end
