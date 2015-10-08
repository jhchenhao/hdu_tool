//
//  LeftViewController.m
//  杭电神器
//
//  Created by 吴玉铁 on 15/9/25.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import "LeftViewController.h"

@interface LeftViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
    NSArray *_titles;
}

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:229 / 255.0 green:237 / 255.0 blue:239 / 255.0 alpha:1];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,(kScreenHeight - 240) / 2, kScreenWidth,240) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.rowHeight = 60;
    _tableView.sectionHeaderHeight = 65;
    _titles = @[@"我的资料",@"注销账号",@"关于我们",@"分享"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = _titles[indexPath.row];
    cell.backgroundColor =  [UIColor colorWithRed:224 / 255.0 green:244 / 255.0 blue:255 / 255.0 alpha:1];
    return cell;
}
@end
