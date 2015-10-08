//
//  EnptyroomTableView.h
//  杭电神器
//
//  Created by 吴玉铁 on 15/10/2.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmptyroomTableView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSArray *emptyRooms;
@property (nonatomic,copy) NSString *bulidingIndex;
@property (nonatomic,strong) UIColor *textColor;

@end
