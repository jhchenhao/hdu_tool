//
//  BooksListViewController.m
//  杭电神器
//
//  Created by 吴玉铁 on 15/9/26.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import "BooksListViewController.h"

@interface BooksListViewController (){
    MJRefreshAutoNormalFooter *_footer;
}

@end

@implementation BooksListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationItem.leftBarButtonItem = nil;
    [self _createViews];
    [self _loadSearchBookData];
    _pageIndex = 1;
}

- (void)_loadSearchBookData{
    //取下搜索数据吧，设置下参数
    [self showHUD:@"努力加载列表中"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:self.searchText  forKey:@"keyword"];
    [params setObject:@"1" forKey:@"page"];
    [MyNetWorkQuery AFrequestData:book_search HTTPMethod:@"POST" params:params completionHandle:^(id result) {
        if(result){
            _searchTableView.hidden = NO;
            [self completeHUD:@"列表加载完毕"];
            NSMutableArray *bookModels = [NSMutableArray array];
            for (NSDictionary *bookDic in result) {
                SearchBookModel *book = [[SearchBookModel alloc]initWithDataDic:bookDic];
                [bookModels addObject:book];
            }
            _searchTableView.searchData = bookModels;
            [_searchTableView reloadData];
            //一次最多20本 到来就加1 允许加载更多
            if (bookModels.count == 20) {
                _pageIndex ++;
                _searchTableView.footer = _footer;
            }
        }
    } errorHandle:^(NSError *error){
        [self completeHUD:@"暂无搜索结果"];
        _searchTableView.hidden = YES;
        UIView *resultBG = [[UIView alloc]initWithFrame:CGRectMake(0,80, kScreenWidth,80)];
        [self.view addSubview:resultBG];
        UIImageView *faceView = [[UIImageView alloc]initWithFrame:CGRectMake(100,30, 30,30)];
        faceView.image = [UIImage imageNamed:@"sorry_face"];
        [resultBG addSubview:faceView];
        UILabel *sorryLabe = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth - 200) / 2, 5, 200, 100)];
        faceView.right = sorryLabe.left;
        sorryLabe.numberOfLines = 0;
        sorryLabe.text = @"sorry啊，杭电图书馆没有这本书!";
        sorryLabe.font = [UIFont fontWithName:@"JLinBo" size:25];
        sorryLabe.textColor = [UIColor colorWithRed:0 green:0.5 blue:1 alpha:1];
        [resultBG addSubview:sorryLabe];
    }];
}
//加载更多
- (void)_loadSearchBookMoreData{
    if (_pageIndex == 1) {
        _searchTableView.footer.state = MJRefreshStateNoMoreData;
        return;
    }else if(_pageIndex >= 2){//页数超过2 开始加载更多，接下来加载不断调自己page往上加
        _searchTableView.footer.state = MJRefreshStateRefreshing;
        NSString *indexString = [NSString stringWithFormat:@"%ld",(long)_pageIndex];
        [self showHUD:@"努力加载列表中"];
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        [params setObject:self.searchText  forKey:@"keyword"];
        [params setObject:indexString  forKey:@"page"];
        [MyNetWorkQuery AFrequestData:book_search HTTPMethod:@"POST" params:params completionHandle:^(id result) {
            if(result){
                _searchTableView.hidden = NO;
                [self completeHUD:@"列表加载完毕"];
                NSMutableArray *bookModels = [NSMutableArray array];
                for (NSDictionary *bookDic in result) {
                    SearchBookModel *book = [[SearchBookModel alloc]initWithDataDic:bookDic];
                    [bookModels addObject:book];
                }
                NSMutableArray *tempArray = [NSMutableArray array];
                [tempArray addObjectsFromArray:_searchTableView.searchData];
                [tempArray addObjectsFromArray:bookModels];
                _searchTableView.searchData = tempArray;
                
                [_searchTableView reloadData];
                [_searchTableView.footer endRefreshing];
                if (bookModels.count >= 20) {
                    _pageIndex ++;
                }else if(bookModels.count < 20){
                    _searchTableView.footer.state = MJRefreshStateNoMoreData;
                }
            }
        } errorHandle:^(NSError *error){
            //刚好20本做最后的判断
            _searchTableView.footer.state = MJRefreshStateNoMoreData;
        }];
    }
}

- (void)_createViews{
    //设置背景搜索背景视图
    UIView *headerBgView = [[UIView alloc]initWithFrame:CGRectMake(55,20, kScreenWidth - 55, 50)];
    headerBgView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:headerBgView];
    //白色视图
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(7.5,7.5, kScreenWidth - 15 - 55, 35)];
    whiteView.layer.cornerRadius = 5;
    whiteView.backgroundColor = [UIColor whiteColor];
    [headerBgView addSubview:whiteView];
    //放大镜视图
    UIImageView *magnifyView = [[UIImageView alloc]initWithFrame:CGRectMake(0,4, 25, 25)];
    magnifyView.image = [UIImage imageNamed:@"library_search"];
    [whiteView addSubview:magnifyView];
    //搜索书名
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth - 35) / 2,8,kScreenWidth - 100, 35)];
    title.font = [UIFont systemFontOfSize:20];
    title.left = magnifyView.right + 8;
    title.text = self.searchText;
    title.textColor = [UIColor lightGrayColor];
    [headerBgView addSubview:title];
    //返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(7, 25, 40, 40);
    [backButton setImage:[UIImage imageNamed:@"nav_back_icon"] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    headerBgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [headerBgView addGestureRecognizer:tap];
    //搜索结果列表创建
    _searchTableView = [[SearchBookTableView alloc]initWithFrame:CGRectMake(0, headerBgView.bottom, kScreenWidth,kScreenHeight - headerBgView.bottom - 5) style:UITableViewStylePlain];
    [self.view addSubview:_searchTableView];
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    _footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(_loadSearchBookMoreData)];
    // 设置文字
    [_footer setTitle:@"上拉加载下一页" forState:MJRefreshStateIdle];
    [_footer setTitle:@"正在加载下一页..." forState:MJRefreshStateRefreshing];
    [_footer setTitle:@"没有下一页了" forState:MJRefreshStateNoMoreData];
    // 设置字体
    _footer.stateLabel.font = [UIFont fontWithName:@"JLinBo" size:18];
    // 设置颜色
    _footer.stateLabel.textColor = [UIColor colorWithRed:0 green:0.5 blue:1 alpha:1];
    // 设置footer
   // _searchTableView.footer = _footer;
    
}

- (void)backButtonAction:(UIButton *)button{
    
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBarHidden = NO;
    [[NSNotificationCenter defaultCenter]postNotificationName:kSearchViewHidden object:nil];
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    
    NSString *searchText = self.searchText;
    NSDictionary *dic = @{@"searchText":searchText};
    
    NSNotification *notification =[NSNotification notificationWithName:kSearchViewAppear object:nil userInfo:dic];
    [[NSNotificationCenter defaultCenter]postNotification:notification];
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark-第三方加载
//第三方加载
- (void)showHUD:(NSString *)title{
    if (_HUD == nil) {
        _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _HUD.mode = MBProgressHUDModeIndeterminate;
        _HUD.yOffset = -30;
        _HUD.cornerRadius = 10;
    }
    [_HUD show:YES];
    _HUD.labelColor = [UIColor colorWithRed:0 green:0.6 blue:1 alpha:1];
    _HUD.labelFont = [UIFont fontWithName:@"JLinBo" size:17];
   // _HUD.dimBackground = YES;
    _HUD.labelText = title;
  
}
- (void)hideHUD{
    [_HUD hide:YES];
}
- (void)completeHUD:(NSString *)title{
    
    _HUD.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"completed_icon"]];
    _HUD.mode = MBProgressHUDModeCustomView;
    _HUD.labelText = title;
    [_HUD hide:YES afterDelay:1.0];
}



@end
