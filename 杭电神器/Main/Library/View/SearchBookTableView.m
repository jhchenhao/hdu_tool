//
//  SearchBookTableView.m
//  杭电神器
//
//  Created by 吴玉铁 on 15/9/27.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import "SearchBookTableView.h"
static NSString *identity = @"searchCell";
@implementation SearchBookTableView


- (void)setSearchData:(NSArray *)searchData{
    if (_searchData != searchData) {
        _searchData = searchData;
    }
    
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        //注册单元格
        UINib *nib = [UINib nibWithNibName:@"SearchBookCell" bundle:nil];
        [self registerNib:nib forCellReuseIdentifier:identity];
        //高度来下
        self.rowHeight = 105;
    }
    return self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchBookCell *cell = [tableView dequeueReusableCellWithIdentifier:identity forIndexPath:indexPath];
    cell.searchBookModel = self.searchData[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchBookModel *model = self.searchData[indexPath.row];
    CGFloat rowHeght = [WXLabel getTextHeight:22 width:kScreenWidth - 20 text:model.name linespace:1];
    return rowHeght + 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //点击单元格，传递bookId给下一个控制器
    SearchBookModel *searchModel = self.searchData[indexPath.row];
    BookDetailViewContoller *bookDetailVC = [[BookDetailViewContoller alloc]init];
    bookDetailVC.hidesBottomBarWhenPushed = YES;
    bookDetailVC.bookId = searchModel.id_book;
    [self.viewController.navigationController pushViewController:bookDetailVC animated:YES];
    
}

@end
