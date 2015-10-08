//
//  BookDetailView.h
//  杭电神器
//
//  Created by 吴玉铁 on 15/9/28.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookDetailHeaderView.h"
#import "EntityModel.h"
#import "EntityCell.h"
#import "WXLabel.h"

@interface BookDetailView : UIView<UITableViewDataSource,UITableViewDelegate>{
    BookDetailHeaderView *_headerView;
    UITableView *_tableView;
    NSArray *_bookListData;
}

@property (nonatomic,strong) SearchBookModel *bookModel;

@end
