//
//  BalanceViewController.m
//  杭电神器
//
//  Created by 吴玉铁 on 15/10/4.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import "BalanceViewController.h"
static NSString *idetity = @"BalanceCell";

@interface BalanceViewController (){
    UITableView *_tableView;
    NSArray *_timeRecords;
    NSArray *_valueRecords;
}

@end

@implementation BalanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    [self _pareseData];
    [self _createViews];
}

- (void)_pareseData{
    NSDictionary *dic = self.balanceDic[@"record"];
    _timeRecords = [dic allKeys];
    _valueRecords = [dic allValues];
    [_tableView reloadData];
}

- (void)_createViews{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.rowHeight = 60;
    _tableView.sectionHeaderHeight = 65;
    UINib *nib = [UINib nibWithNibName:@"BalanceCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:idetity];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _timeRecords.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    BalanceCell *cell = [tableView dequeueReusableCellWithIdentifier:idetity];
    if (cell == nil) {
        cell = [[BalanceCell alloc]initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:idetity];
    }
    cell.TimeLabel.text = _timeRecords[_timeRecords.count -  indexPath.row - 1];
    NSString *value = [_valueRecords[_timeRecords.count - indexPath.row - 1] substringWithRange:NSMakeRange(0, 1)];
    NSString *sub = [_valueRecords[_timeRecords.count - indexPath.row - 1] substringFromIndex:1];
    if ([value isEqualToString:@"-"]) {
        cell.valueLabel.text = [NSString stringWithFormat:@"支出 %@",sub];
        [TGEasyAttributeText changgeTextColorWithLable:cell.valueLabel location:0 length:3 textColor:[UIColor redColor]];
    }else{
        cell.valueLabel.text = [NSString stringWithFormat:@"收入 %@", _valueRecords[_timeRecords.count - indexPath.row - 1]];
        [TGEasyAttributeText changgeTextColorWithLable:cell.valueLabel location:0 length:3 textColor:[UIColor colorWithRed:0 green:0.6 blue:1 alpha:1]];
    }
    
    return cell;
   
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //contrary_main_table_cell@2x
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,65)];
    button.enabled = NO;
    [button setBackgroundImage:[UIImage imageNamed:@"contrary_main_table_cell@2x"] forState:UIControlStateNormal];
    [button setTitle:[NSString stringWithFormat:@"当前余额: %@元",self.balanceNow] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:0 green:0.8 blue:1 alpha:1] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:22];
    return button;
}


@end
