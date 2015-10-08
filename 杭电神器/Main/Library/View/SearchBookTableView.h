//
//  SearchBookTableView.h
//  杭电神器
//
//  Created by 吴玉铁 on 15/9/27.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchBookCell.h"
#import "WXLabel.h"
#import "BookDetailViewContoller.h"
#import "UIView+ViewController.h"

@interface SearchBookTableView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSArray *searchData;

@end
