//
//  LendTableView.h
//  杭电神器
//
//  Created by 吴玉铁 on 15/10/3.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXLabel.h"
#import "LendTableViewCell.h"

@interface LendTableView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSArray *nowData;
@property (nonatomic,strong) NSArray *historyData;
@property (nonatomic,assign) BOOL isReserved;

@end
