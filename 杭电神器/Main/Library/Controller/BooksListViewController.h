//
//  BooksListViewController.h
//  杭电神器
//
//  Created by 吴玉铁 on 15/9/26.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LibraryViewController.h"
#import "Top10TableView.h"
#import "SearchBookModel.h"
#import "SearchBookTableView.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"


@interface BooksListViewController : UIViewController{
    SearchBookTableView *_searchTableView;
    MBProgressHUD *_HUD;
    NSInteger _pageIndex;
}

@property (nonatomic,copy) NSString *searchText;


@end
