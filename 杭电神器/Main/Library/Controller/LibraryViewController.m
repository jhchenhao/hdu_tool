//
//  LibraryViewController.m
//  杭电神器
//
//  Created by 吴玉铁 on 15/9/25.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import "LibraryViewController.h"

@interface LibraryViewController (){
    SearchView  *_searchView;
    Top10TableView *_topTableView;
}

@end

@implementation LibraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _createViews];
}

- (void)_createViews{
    //设置背景搜索背景视图
    UIView *headerBgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kScreenWidth, 50)];
    headerBgView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:headerBgView];
    //白色视图
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(7.5,7.5, kScreenWidth - 15, 35)];
    whiteView.layer.cornerRadius = 5;
    whiteView.backgroundColor = [UIColor whiteColor];
    [headerBgView addSubview:whiteView];
    //放大镜视图
    UIImageView *magnifyView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth - 35) / 2 - 50,4, 25, 25)];
    magnifyView.image = [UIImage imageNamed:@"library_search"];
    [whiteView addSubview:magnifyView];
    //搜索书名
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth - 35) / 2,8,100, 35)];
    title.font = [UIFont systemFontOfSize:18];
    title.left = magnifyView.right + 8;
    title.text = @"搜索书名";
    title.textColor = [UIColor lightGrayColor];
    [headerBgView addSubview:title];
    //Top10表视图
    _topTableView = [[Top10TableView alloc]initWithFrame:CGRectMake(0,headerBgView.bottom, kScreenWidth, kScreenHeight - headerBgView.bottom - 113) style:UITableViewStylePlain];
    [self.view addSubview:_topTableView];
    //搜索栏
    headerBgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [headerBgView addGestureRecognizer:tap];
    _searchView = [[SearchView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _searchView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_searchView];
    _searchView.hidden = YES;
    
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    self.navigationController.navigationBarHidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        _searchView.hidden = NO;
        [[NSNotificationCenter defaultCenter]postNotificationName:kSearchTextFiledBecomeFirstResponder object:nil];
    }];
}





@end
