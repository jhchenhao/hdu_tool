//
//  BookDetailView.m
//  杭电神器
//
//  Created by 吴玉铁 on 15/9/28.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import "BookDetailView.h"
static NSString *identifier = @"EntityCell";
@implementation BookDetailView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self _createViews];
    }
    return self;
}

- (void)setBookModel:(SearchBookModel *)bookModel{
    if (_bookModel != bookModel) {
        _bookModel = bookModel;
        _headerView.searchBookModel = self.bookModel;
        
        NSArray *entities = self.bookModel.entity;
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dicData in entities) {
            EntityModel *entity = [[EntityModel alloc]initWithDataDic:dicData];
            [array addObject:entity];
        }
        _bookListData = array;
        [_tableView reloadData];
    }
}

- (void)_createViews{
    //头部简介视图
    _headerView = [[[NSBundle mainBundle]loadNibNamed:@"BookDetailHeaderView" owner:self options:nil]lastObject];
    _headerView.height = 160;
    _headerView.width = kScreenWidth;
    [self addSubview:_headerView];
    //收藏列表
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 190, kScreenWidth,kScreenHeight - 190 - 49 - 10) style:UITableViewStylePlain];
    [self addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate =self;
    UINib *nib = [UINib nibWithNibName:@"EntityCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:identifier];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _bookListData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EntityCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    EntityModel *entity = _bookListData[indexPath.row];
    cell.entityModel = entity;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    EntityModel *model = _bookListData[indexPath.row];
    CGFloat rowHeght = [WXLabel getTextHeight:17 width:120 text:model.location linespace:1];
    return rowHeght + 30;
}


@end
