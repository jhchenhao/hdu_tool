//
//  NotesTableView.h
//  项目3
//
//  Created by mac on 15/10/2.
//  Copyright (c) 2015年 chenhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotesTableView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *datasAry;


@end
