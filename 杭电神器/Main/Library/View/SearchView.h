//
//  SearchView.h
//  杭电神器
//
//  Created by 吴玉铁 on 15/9/26.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+ViewController.h"
#import "BooksListViewController.h"

@interface SearchView : UIView<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>{
    UITextField *_textFiled;
    UITableView *_recordsTableView;
    NSMutableArray *_recordsData;
}

@end
