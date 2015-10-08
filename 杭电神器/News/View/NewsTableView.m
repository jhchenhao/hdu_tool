//
//  NewsTableView.m
//  项目3
//
//  Created by mac on 15/9/28.
//  Copyright (c) 2015年 chenhao. All rights reserved.
//

#import "NewsTableView.h"
#import "NewsPlistTableViewCell.h"
#import "AnalysisHtml.h"
#import "PlistModel.h"
#import "UIView+NavigationController.h"
#import "NewsDetailViewController.h"

@interface NewsTableView()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    UIScrollView *_scrollView; //头视图上的 滑动视图
    UIButton *_lastButton; //上一次点击的按钮
    NSInteger _currentNum;
    
    NSTimer *_timer;  //定时器
    
    NSInteger _currentPageNum;  //当前页数
    
    UILabel *_pageLabel;   //显示第几页label
    UIButton *_leftButton;  //底部视图左边按钮
    UIButton *_rightButton;  //底部视图右边按钮
}

@end

@implementation NewsTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _pageDic = [NSMutableDictionary dictionary];
        self.delegate = self;
        self.dataSource = self;
        _currentPageNum = 1;
       // self.backgroundColor = [UIColor cyanColor];
//        [self _creatHeaderView:self];
        //[self _creatFooterView:self];
//        self.tableHeaderView.hidden = YES;
//        self.tableFooterView.hidden = YES;
        
        //设置block内容
        __weak NewsTableView *weekSelf = self;
        self.block = ^{
            __strong NewsTableView *strongSelf = weekSelf;
//            strongSelf.tableFooterView.hidden = NO;
//            strongSelf.tableHeaderView.hidden = NO;
            [strongSelf _creatHeaderView:strongSelf];
            [strongSelf _creatFooterView:strongSelf];
        };
        // 注测单元格
        [self registerNib:[UINib nibWithNibName:@"NewsPlistTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        
        //创建定时器
        [self creatNStimer];
    }
    return self;
}
//创建定时器
- (void)creatNStimer
{
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(nstimerAction) userInfo:nil repeats:YES];
    });
    
}
//定时器执行方法
- (void)nstimerAction
{
    _currentNum ++;
    if (_currentNum >3) {
        _currentNum = 0;
    }
    [self lightButton:_currentNum + 100];
    _scrollView.contentOffset = CGPointMake((_currentNum) * kScreenWidth, 0);
    
}



#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsPlistTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    PlistModel *model = self.dataAry[indexPath.row];
    cell.model = model;
    NSInteger num = indexPath.row % 4;
    if (self.mytag == 1) {
        cell.icon.image = [UIImage imageNamed:model.imageAry[num]];
    }else
    {
        cell.icon.image = [UIImage imageNamed:model.imageAry2[num]];
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

#pragma mark - 创建头视图 和底部视图

//创建尾部视图
- (void)_creatFooterView:(UITableView *)tableview
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
   // view.backgroundColor = [UIColor grayColor];
    
    //添加按钮
    //左边按钮
    _leftButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 7, 80, 26)];
   // _leftButton.backgroundColor = [UIColor orangeColor];
    [view addSubview:_leftButton];
    [_leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_leftButton setBackgroundImage:[UIImage imageNamed:@"上一页"] forState:UIControlStateNormal];
    [_leftButton setBackgroundImage:[UIImage imageNamed:@"上一页3"] forState:UIControlStateHighlighted];
    _leftButton.enabled = NO;
    
    //右边按钮
    _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 110, 7, 80, 26)];
    [_rightButton setBackgroundImage:[UIImage imageNamed:@"下一页"] forState:UIControlStateNormal];
    [_rightButton setBackgroundImage:[UIImage imageNamed:@"下一页3"] forState:UIControlStateHighlighted];
   // _rightButton.backgroundColor = [UIColor orangeColor];
    [view addSubview:_rightButton];
    [_rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //添加label
    _pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
    _pageLabel.textAlignment = NSTextAlignmentCenter;
    NSInteger count = [_allCount integerValue] / 20;
    _pageLabel.text = [NSString stringWithFormat:@"第%li页/共%li页",_currentPageNum,count];
    _pageLabel.center = CGPointMake(kScreenWidth / 2, _pageLabel.center.y);
    [view addSubview:_pageLabel];
    
    tableview.tableFooterView = view;
}

//footer左边按钮执行事件
- (void)leftButtonAction:(UIButton *)sender
{
    _currentPageNum -- ;
    [self loadTabelViewWith:_currentPageNum];
}

//footer右边按钮执行事件
- (void)rightButtonAction:(UIButton *)sender
{
    _currentPageNum ++;
    [self loadTabelViewWith:_currentPageNum];
}

//点击上一页或下一页
- (void)loadTabelViewWith:(NSInteger)num
{
    _leftButton.enabled = YES;
    _rightButton.enabled = YES;
    
    //判断按钮是否能被点击
    if (_currentPageNum == 1) {
        _leftButton.enabled = NO;
    }else if (_currentPageNum == 200)
    {
        _rightButton.enabled = NO;
    }
    
    NSString *numStr = [NSString stringWithFormat:@"%li",num];
    NSArray *ary = _pageDic[numStr];
    //判断字典里有没有数组 如果有 则在字典中取 如果没有则申请网络
    if (ary != nil) {
        self.dataAry = ary;
    }
    else
    {
        //发送请求
        //拼接url
        NSString *plistUrl = [NSString stringWithFormat:@"/Col/Col2/Index_%li.aspx",_currentPageNum];
        NSDictionary *dic = [AnalysisHtml analysisALLNewsHtmlWithURLStr:plistUrl node:news_plist_node];
        NSArray *ary = dic[@"plist"];
        NSMutableArray *plistAry = [NSMutableArray array];
        if (ary == nil) {
            return;
        }
        for (NSDictionary *dic in ary) {
            PlistModel *model = [[PlistModel alloc] initWithDic:dic];
            [plistAry addObject:model];
        }
        [_pageDic setObject:plistAry forKey:numStr];
        self.dataAry = plistAry;
    }
    
    if (_currentPageNum != 1) {
        [self.tableHeaderView removeFromSuperview];
        self.tableHeaderView = nil;
        [_timer invalidate];
        _timer = nil;
    }else if (_currentPageNum == 1)
    {
        [self _creatHeaderView:self];
    }
    
    NSInteger allCount = [self.allCount integerValue] / 20;
    _pageLabel.text = [NSString stringWithFormat:@"第%li页/共%li页",_currentPageNum,allCount];
    [self setContentOffset:CGPointZero animated:YES];
    [self reloadData];

//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
//    self.scrollsToTop = YES;
}




//创建tableHeaderView
- (void)_creatHeaderView:(UITableView *)tableView
{
    //创建滑动视图
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    tableView.tableHeaderView = [[UIView alloc] initWithFrame:_scrollView.bounds];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor orangeColor];
    [tableView.tableHeaderView addSubview: _scrollView];
    
    //放入imageView
    for (int index = 0; index < 4; index ++) {
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(index * kScreenWidth, 0, kScreenWidth, 200)];
        imageV.tag = 200 + index;
        if (self.mytag == 1) {
            imageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"edu_%i.jpg",index]];
        }
        else
        {
            imageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"hdu_%i.jpg",index]];
        }
        [_scrollView addSubview:imageV];
    }
    _scrollView.contentSize = CGSizeMake(4 * kScreenWidth, 0);
    
    //添加按钮
    for (int index = 0; index < 4; index ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 25 * (4-index), 175, 16, 16)];
//        button.backgroundColor = [UIColor orangeColor];
        [button setTitle:[NSString stringWithFormat:@"%i",index + 1] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        button.tag = index + 100;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.borderWidth = 1;
        [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        button.layer.borderColor = [UIColor orangeColor].CGColor;
        button.layer.cornerRadius = 8;
        if (index == 0) {
            button.backgroundColor = [UIColor orangeColor];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _lastButton = button;
            _currentNum = index;
        }
        [tableView.tableHeaderView addSubview:button];
    }
    
}
//按钮点击事件
- (void)buttonAction:(UIButton *)sender
{
    [_timer invalidate];
    _timer = nil;
    [self creatNStimer];
    //如果按钮不是次一次的按钮
    if (_lastButton != sender) {
        [self lightButton:sender.tag];
        _scrollView.contentOffset = CGPointMake((sender.tag - 100) * kScreenWidth, 0);
//        _currentNum = sender.tag - 100;
    }
}
//点亮按钮
- (void)lightButton:(NSInteger)num
{
    UIButton *button = (UIButton *)[self.tableHeaderView viewWithTag:num];
    //把上一次的按钮回复原状
    [_lastButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    _lastButton.backgroundColor = [UIColor clearColor];
    //设置这次点击的按钮
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor orangeColor];
    _currentNum = num - 100;
    _lastButton = button;
}



#pragma mark - scrollDelegate

//滑动结束创建定时器
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _scrollView) {
        if (_timer == nil) {
            [self creatNStimer];
        }
    }
}
//滑动视图 按钮点亮按钮
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //如果滑动视图是_scrollerView
    if (scrollView == _scrollView) {
        if (_timer != nil) {
            //滑动开始停止定时器
            [_timer invalidate];
            _timer = nil;
        }
        NSInteger num = (kScreenWidth/2 + scrollView.contentOffset.x) / kScreenWidth;
        if (num < 0 && num > 4) {
            return;
        }
//        NSLog(@"%li",num);
        if (_currentNum != num) {
            [self lightButton:num + 100];
            //        _currentNum = num;
        }
        if (_timer == nil) {
            [self creatNStimer];
        }
    }
    
    //如果滑动视图是tableView
    if (scrollView == self) {
        if (scrollView.contentOffset.y < 0) {
            //停止定时器
            [_timer invalidate];
            _timer = nil;
            //修改当前imageView
            UIImageView *imageV = (UIImageView *)[_scrollView viewWithTag:200 + _currentNum];
            _scrollView.backgroundColor = [UIColor yellowColor];
            _scrollView.top = scrollView.contentOffset.y;
            _scrollView.height = 200 - scrollView.contentOffset.y;

            imageV.bounds = _scrollView.bounds;
            imageV.bottom = _scrollView.bottom;
            imageV.top -= scrollView.contentOffset.y;
        }
        else if (scrollView.contentOffset.y == 0)
        {
            if (_timer == nil) {
                if (self.tableHeaderView) {
                    [self creatNStimer];
                }
            }
        }
    }
    
    
}

#pragma mark - 点击单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //弹出新闻详细界面的模态视图
    NewsDetailViewController *detailVC = [[NewsDetailViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:detailVC];
    navi.navigationBar.translucent = NO;
    detailVC.titleModel = _dataAry[indexPath.row];
    
    [self.NavigationController presentViewController:navi animated:YES completion:nil];
    
}



@end
