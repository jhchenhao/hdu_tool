//
//  EntityCell.m
//  杭电神器
//
//  Created by 吴玉铁 on 15/9/28.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import "EntityCell.h"

@implementation EntityCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setEntityModel:(EntityModel *)entityModel{
    if (_entityModel != entityModel) {
        _entityModel = entityModel;
        [self setNeedsLayout];
    }
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    _campusLabel.text = self.entityModel.campus;
    _locationLabel.numberOfLines = 0;
    _locationLabel.text = self.entityModel.location;
    NSString *lendOrNotStr = self.entityModel.lend_or_not;
    BOOL lendOrNot = [lendOrNotStr boolValue];
    if (lendOrNot) {
        _lendStateLabel.text = @"可借";
        _lendImageView.image = [UIImage imageNamed:@"lend_yes"];
    }else{
        _lendStateLabel.text = @"不可借";
        _lendImageView.image = [UIImage imageNamed:@"lend_no"];
    }

}


@end
