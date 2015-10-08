//
//  LendTableView.m
//  杭电神器
//
//  Created by 吴玉铁 on 15/10/3.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import "LendTableView.h"
static  NSString *identity = @"lendBookCell";
@implementation LendTableView


- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        self.sectionHeaderHeight = 30;
        UINib *nib = [UINib nibWithNibName:@"LendTableViewCell" bundle:nil];
        [self registerNib:nib forCellReuseIdentifier:identity];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.nowData.count;
    }
    return self.historyData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.model = self.nowData[indexPath.row];
    }else if(indexPath.section == 1){
        cell.model = self.historyData[indexPath.row];
    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        LendBookModel *model = self.nowData[indexPath.row];
        CGFloat rowHeight = [WXLabel getTextHeight:19 width:(kScreenWidth - 16) text:model.name linespace:1];
        return rowHeight + 70;
    }
    LendBookModel *model = self.historyData[indexPath.row];
    CGFloat rowHeght = [WXLabel getTextHeight:19 width:(kScreenWidth - 16) text:model.name linespace:1];
    return rowHeght + 70;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *topBar = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    topBar.backgroundColor = [UIColor whiteColor];
    topBar.layer.borderWidth = 0.5f;
    topBar.layer.borderColor = [UIColor darkGrayColor].CGColor;
    topBar.textColor = [UIColor darkGrayColor];
    if (self.isReserved == NO) {
        if (section == 0) {
            topBar.text = @" 当前借阅";
        }else{
            topBar.text = @" 历史借阅";
        }
    }else{
        if (section == 0) {
            topBar.text = @" 当前预定";
        }else{
            topBar.text = @" 历史预定";
        }
    }
    
    
    return topBar;
}


@end
