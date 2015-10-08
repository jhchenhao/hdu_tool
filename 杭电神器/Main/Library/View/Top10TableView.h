//
//  Top10TableView.h
//  杭电神器
//
//  Created by 吴玉铁 on 15/9/26.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNetWorkQuery.h"
#import "BookModel.h"
#import "Top10TableViewCell.h"
#import "BooksListViewController.h"
#import "UIView+ViewController.h"

@interface Top10TableView : UITableView<UITableViewDataSource,UITableViewDelegate>{
    NSArray *_bookData;
}

@end
