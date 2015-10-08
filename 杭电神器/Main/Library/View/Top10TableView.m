//
//  Top10TableView.m
//  杭电神器
//
//  Created by 吴玉铁 on 15/9/26.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import "Top10TableView.h"
static NSString *identity = @"top10Cell";
@implementation Top10TableView


- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        self.dataSource = self;
        self.delegate = self;
        [self _createHeaderView];
        [self _loadBookRankData];
    }
    return self;
}

- (void)_loadBookRankData{
    //取下排行版数据吧
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [MyNetWorkQuery AFrequestData:book_rank HTTPMethod:@"POST" params:params completionHandle:^(id result) {
        NSMutableArray *bookModels = [NSMutableArray array];
        for (NSDictionary *bookDic in result) {
            BookModel *book = [[BookModel alloc]initWithDataDic:bookDic];
            [bookModels addObject:book];
        }
        _bookData = bookModels;
        [self reloadData];
        
    } errorHandle:nil];
    
}

- (void)_createHeaderView{
    UILabel *headerView = [[UILabel alloc]init];
    headerView.height = 55;
    headerView.text = @"Top_10";
    headerView.textAlignment = NSTextAlignmentCenter;
    headerView.font = [UIFont fontWithName:@"BradleyHandITCTT-Bold" size:30];
    self.tableHeaderView = headerView;
    self.rowHeight = 63;
    //注册下单元格
    UINib *nib = [UINib nibWithNibName:@"Top10TableViewCell" bundle:nil];
    [self registerNib:nib forCellReuseIdentifier:identity];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _bookData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Top10TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity forIndexPath:indexPath];
    cell.bookModel = _bookData[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BookModel *model = _bookData[indexPath.row];
    NSString *bookName = model.name;
    //点击push加载对应书名列表
    BooksListViewController *bookListVC = [[BooksListViewController alloc]init];
    bookListVC.searchText = bookName;
    self.viewController.navigationController.navigationBarHidden = YES;
    [self.viewController.navigationController pushViewController:bookListVC animated:YES];
}



@end
