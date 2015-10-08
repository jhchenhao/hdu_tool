//
//  CollectionViewController.m
//  项目3
//
//  Created by mac on 15/9/30.
//  Copyright (c) 2015年 chenhao. All rights reserved.
//

#import "CollectionViewController.h"
#import "NewsPlistTableViewCell.h"
#import "PlistModel.h"
#import "NewsDetailViewController.h"

@interface CollectionViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_table;
    
    NSMutableArray *_dataAry;
}

@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _creatItem];
    [self _creatTableView];
    self.navigationController.navigationBar.translucent = NO;
}

//修改item
- (void)_creatItem
{
    //创建返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(leftItemAction)];
}
- (void)leftItemAction
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


//创建表视图
- (void)_creatTableView
{
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
    _table.delegate = self;
    _table.dataSource = self;
    [self.view addSubview:_table];
    [_table registerNib:[UINib nibWithNibName:@"NewsPlistTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    //获取数据
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"collect"];
    NSArray *keyAry = [dic allKeys];
    _dataAry = [NSMutableArray array];
    for (NSString *key in keyAry) {
        NSDictionary *subDic = dic[key];
        PlistModel *model = [[PlistModel alloc] initWithDic:subDic];
        [_dataAry addObject:model];
    }
}


#pragma mark - tableDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsPlistTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = _dataAry[indexPath.row];
    cell.icon.image = [UIImage imageNamed:@"952910f980d02ac857435a42948af8ee.jpg"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //弹出新闻详细界面的模态视图
    NewsDetailViewController *detailVC = [[NewsDetailViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:detailVC];
    navi.navigationBar.translucent = NO;
    detailVC.titleModel = _dataAry[indexPath.row];
    
    [self.navigationController presentViewController:navi animated:YES completion:nil];
    
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
