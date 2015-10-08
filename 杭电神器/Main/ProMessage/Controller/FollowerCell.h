//
//  FollowerCell.h
//  杭电神器
//
//  Created by 吴玉铁 on 15/10/4.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BmobSDK/Bmob.h>
#import "FollowerModel.h"
#import "UIImageView+WebCache.h"


@interface FollowerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *supportLabel;
@property (weak, nonatomic) IBOutlet UIButton *supportButton;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (nonatomic,strong) NSString *objId;
@property (nonatomic,strong) FollowerModel *follower;


@end
