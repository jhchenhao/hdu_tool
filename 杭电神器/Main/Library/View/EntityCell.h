//
//  EntityCell.h
//  杭电神器
//
//  Created by 吴玉铁 on 15/9/28.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EntityModel.h"

@interface EntityCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *campusLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *lendStateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *lendImageView;

@property (nonatomic,strong) EntityModel *entityModel;


@end
