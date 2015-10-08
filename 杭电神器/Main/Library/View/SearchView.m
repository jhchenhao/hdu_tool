//
//  SearchView.m
//  杭电神器
//
//  Created by 吴玉铁 on 15/9/26.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import "SearchView.h"
static  NSString *identity = @"recordsCell";
@implementation SearchView

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self _createViews];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledBecomeFirstResponder) name:kSearchTextFiledBecomeFirstResponder object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(searchViewHidden) name:kSearchViewHidden object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(searchViewAppear:) name:kSearchViewAppear object:nil];
    }
    return self;
}

- (void)_createViews{
    //设置背景搜索背景视图
    UIView *headerBgView = [[UIView alloc]initWithFrame:CGRectMake(0,20, kScreenWidth, 50)];
    headerBgView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:headerBgView];
    //搜索视图
    _textFiled = [[UITextField alloc]initWithFrame:CGRectMake(7.5,7.5,kScreenWidth - 15 - 50, 35)];
    _textFiled.delegate = self;
    _textFiled.borderStyle = UITextBorderStyleRoundedRect;
    _textFiled.placeholder = @"搜索书名";
    _textFiled.textAlignment = NSTextAlignmentLeft;
    _textFiled.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *leftImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"library_search"]];
    leftImage.frame = CGRectMake(0, 0, 28, 28);
    _textFiled.leftView = leftImage;
    [headerBgView addSubview:_textFiled];
    _textFiled.clearButtonMode = UITextFieldViewModeAlways;
    _textFiled.returnKeyType = UIReturnKeySearch;
    //取消按钮
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0, 10, 50, 30);
    cancelButton.left = _textFiled.right + 5;
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:20];
    cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [headerBgView addSubview:cancelButton];
    [cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    //记录表视图判断创建及加载
    NSArray *array = [[NSUserDefaults standardUserDefaults]objectForKey:kSearchRecord];
    if (array.count != 0) {
        [self _createRecordTableView];
        _recordsData = [array mutableCopy];
        [_recordsTableView reloadData];
    }
}

- (void)cancelAction:(UIButton *)button{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.hidden = YES;
        self.viewController.navigationController.navigationBarHidden = NO;
        [_textFiled resignFirstResponder];
    }];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //掩藏键盘
    if (_textFiled.text.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"输点那啥吧亲" delegate:nil cancelButtonTitle:@"那好吧" otherButtonTitles:nil, nil];
        [alertView show];
        return NO;
    }
    [_textFiled resignFirstResponder];
    //做一个modal，同时传text过去
    BooksListViewController *booksListVC = [[BooksListViewController alloc]init];
    booksListVC.searchText = _textFiled.text;
    [self.viewController.navigationController pushViewController:booksListVC animated:YES];
    _textFiled.text = nil;
    //第一次创建一个表视图加搜索记录
    if (_recordsTableView == nil) {
        [self _createRecordTableView];
    }
    NSString *record = booksListVC.searchText;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableArray *tempData = [userDefault objectForKey:kSearchRecord];
    //做个判断 如何字符与之前不同加入到数组中
    for (NSString *string in tempData) {
        if ([record isEqualToString:string]) {
            //记录写到本地
            return NO;
        }
    }
    [_recordsData addObject:record];
    [userDefault setObject:_recordsData forKey:kSearchRecord];
    [userDefault synchronize];
    _recordsTableView.tableFooterView.hidden = NO;
    [_recordsTableView reloadData];
    return YES;
}
#pragma mark-通知方法
- (void)textFiledBecomeFirstResponder{
    [_textFiled becomeFirstResponder];
    _textFiled.text = nil;
}

- (void)searchViewHidden{
    self.hidden = YES;
    
}

- (void)searchViewAppear:(NSNotification *)notification{
    self.hidden = NO;
    _textFiled.text = notification.userInfo[@"searchText"];
    [_textFiled becomeFirstResponder];
}
#pragma mark-记录表视图代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _recordsData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
    }
    cell.textLabel.text = _recordsData[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
//左滑删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
     if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 1. 删除单元格所对应的数据
        [_recordsData removeObjectAtIndex:indexPath.row];
        // 2. 播放删除数据的动画
        [_recordsTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
        [[NSUserDefaults standardUserDefaults]setObject:_recordsData forKey:kSearchRecord];
        [[NSUserDefaults standardUserDefaults]synchronize];
         [UIView animateWithDuration:0.3 animations:^{
             if (_recordsData.count == 0) {
                 _recordsTableView.tableFooterView.hidden = YES;
             }
         }];
         
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //做一个modal，同时传text过去
    BooksListViewController *booksListVC = [[BooksListViewController alloc]init];
    booksListVC.searchText = _recordsData[indexPath.row];
    [self.viewController.navigationController pushViewController:booksListVC animated:YES];
    [_textFiled resignFirstResponder];
    _textFiled.text = nil;
}

- (void)_createRecordTableView{
    _recordsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _textFiled.bottom + 5 + 20, kScreenWidth, kScreenHeight - _textFiled.bottom - 5 - 20)];
    [self addSubview:_recordsTableView];
    _recordsTableView.dataSource = self;
    _recordsTableView.delegate = self;

    _recordsData = [NSMutableArray array];
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    UIButton *clearButton = [[UIButton alloc]initWithFrame:CGRectMake((kScreenWidth - 100) / 2,5, 100, 40)];
    [clearButton setBackgroundImage:[UIImage imageNamed:@"clear_record_icon"] forState:UIControlStateNormal];
    [clearButton setTitleColor:[UIColor colorWithRed:0 green:0.5 blue:1 alpha:1] forState:UIControlStateNormal];
    [clearButton setTitle:@"清除" forState:UIControlStateNormal];
    [bottomView addSubview:clearButton];
    clearButton.contentEdgeInsets = UIEdgeInsetsMake(0,0,0,15);
    _recordsTableView.tableFooterView = bottomView;
    [clearButton addTarget:self action:@selector(clearAllAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clearAllAction{
    [_recordsData removeAllObjects];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:kSearchRecord];
    
    [UIView animateWithDuration:0.3 animations:^{
        [_recordsTableView reloadData];
        _recordsTableView.tableFooterView.hidden = YES;
    }];
    
}

@end
