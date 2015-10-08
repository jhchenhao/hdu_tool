//
//  NewsViewController.m
//  项目3
//
//  Created by mac on 15/9/27.
//  Copyright (c) 2015年 chenhao. All rights reserved.
//

#import "NewsViewController.h"
#import "MySwitch.h"
#import "NewsTableView.h"
#import "AnalysisHtml.h"
#import "PlistModel.h"
#import "MBProgressHUD.h"
#import "CollectionViewController.h"

@interface NewsViewController ()<MySwitchDelegate>
{
    //校园动态
    NewsTableView *_newsTableView;
    NSMutableArray *_plistAry;
    
    //杭电要闻
    NewsTableView *_hduNewsTabelView;
    NSMutableArray *_hduPlistAry;
    
    MBProgressHUD *_hudView;
}

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新闻";
    self.view.backgroundColor = [UIColor yellowColor];
    [self loadData];
    //创建标题视图
    [self setNaviTitleView];
    //创建表视
    [self _creatTableView];
    //读取数据
    [self getData];
    
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
}
- (void)loadData
{
    //创建一本字典接受数据 储存在本地
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [defaults objectForKey:@"collect"];
    if (dic == nil) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [defaults setObject:dic forKey:@"collect"];
    }
}

#pragma mark - tipView
- (void)showTipView:(NSString *)title
{
    if (_hudView == nil) {
        //创建提示视图
        _hudView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    //设置文字
    _hudView.labelText = title;
    //设置黑色背景
    _hudView.dimBackground = YES;
}

- (void)completionWithTitle:(NSString *)title
{
    _hudView.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
    _hudView.mode = MBProgressHUDModeCustomView;
    _hudView.labelText = title;
    [_hudView show:YES];
    [_hudView hide:YES afterDelay:1.5];
}


//创建导航控制器标题视图
- (void)setNaviTitleView
{
    //创建标题
    MySwitch *mySwitch = [[MySwitch alloc] initWithFrame:CGRectZero];
    mySwitch.leftName = @"校园动态";
    mySwitch.rightName = @"杭电要闻";
    mySwitch.delegate = self;
    mySwitch.color = [UIColor colorWithRed:175.0 / 255 green:248.0 / 255 blue:70.0 / 255 alpha:1];
    self.navigationItem.titleView = mySwitch;
    
    //创建右边按钮
    UIButton *collectButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 17, 17)];
    [collectButton addTarget:self action:@selector(collectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [collectButton setImage:[UIImage imageNamed: @"mission_flag_point_empty@2x"]forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:collectButton];
}

- (void)collectButtonAction:(UIButton *)sender
{
    //弹出收藏的模态视图
    CollectionViewController *collection = [[CollectionViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:collection];
    [self.navigationController presentViewController:navi animated:YES completion:nil];
}

#pragma mark - mySwitchDelegate
- (void)selectLeft
{
    [UIView animateWithDuration:.3 animations:^{
        _newsTableView.left = 0;
        _hduNewsTabelView.left = kScreenWidth;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)selectRight
{
    [UIView animateWithDuration:.3 animations:^{
        _newsTableView.right = 0;
        _hduNewsTabelView.left = 0;
    } completion:^(BOOL finished) {
        
    }];
}


//创建表视图
- (void)_creatTableView
{
    //创建校园动态
    _newsTableView  = [[NewsTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 49)];
    _newsTableView.mytag = 1;
    [self.view addSubview:_newsTableView];
    //创建杭电要闻
    _hduNewsTabelView = [[NewsTableView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight - 64 - 49)];
    _hduNewsTabelView.mytag = 2;
    [self.view addSubview:_hduNewsTabelView];
    
    
    
    [self showTipView:@"正在加载"];
}

//获取数据
- (void)getData
{
    _plistAry = [NSMutableArray array];
    _hduPlistAry = [NSMutableArray array];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        //读取校园动态
        NSDictionary *dic =[AnalysisHtml analysisALLNewsHtmlWithURLStr:@"/Col/Col2/Index.aspx" node:news_plist_node];
        NSArray *ary = dic[@"plist"];
        for (NSDictionary *dic in ary) {
            PlistModel *model = [[PlistModel alloc] initWithDic:dic];
            [_plistAry addObject:model];
        }
        _newsTableView.dataAry = _plistAry;
        _newsTableView.allCount = dic[@"count"];
        
        //读取杭电要闻
        dic =[AnalysisHtml analysisALLNewsHtmlWithURLStr:@"/Col/Col1/Index.aspx" node:news_plist_node];
        ary = dic[@"plist"];
        for (NSDictionary *dic in ary) {
            PlistModel *model = [[PlistModel alloc] initWithDic:dic];
            [_hduPlistAry addObject:model];
        }
        _hduNewsTabelView.dataAry = _hduPlistAry;
        _hduNewsTabelView.allCount = dic[@"count"];
        
        
        //刷新界面
        dispatch_sync(dispatch_get_main_queue(), ^{
            [_newsTableView reloadData];
            [_hduNewsTabelView reloadData];
            _newsTableView.block();
            _hduNewsTabelView.block();
            [self completionWithTitle:@"加载完毕"];
        });
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
