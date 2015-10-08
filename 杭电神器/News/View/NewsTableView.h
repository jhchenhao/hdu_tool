//
//  NewsTableView.h
//  项目3
//
//  Created by mac on 15/9/28.
//  Copyright (c) 2015年 chenhao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^showBlock)(void);

@interface NewsTableView : UITableView

@property (nonatomic, strong) NSMutableDictionary *pageDic;
@property (nonatomic, strong) NSArray *dataAry;
@property (nonatomic, copy) showBlock block;
@property (nonatomic, copy) NSString *allCount;

@property (nonatomic, assign) NSInteger mytag;

@end
