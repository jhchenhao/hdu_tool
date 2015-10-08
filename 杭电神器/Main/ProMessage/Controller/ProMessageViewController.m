//
//  ProMessageViewController.m
//  杭电神器
//
//  Created by 吴玉铁 on 15/9/25.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import "ProMessageViewController.h"
static NSString *nomalIdentity = @"normalCell";

@interface ProMessageViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_mainTableView;
    NSMutableArray *_headerTitles;
    NSMutableArray *_headerIcons;
    NSMutableArray *_faceViews;
    NSMutableArray *_cellTitles;
    NSString *_balance;
    NSDictionary *_balanceDic;
    MBProgressHUD *_HUD;
    
}

@end

@implementation ProMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _createViews];
    [self _initData];
    [self _loadCardData];
    
}

- (void)_initData{
    _headerTitles = [NSMutableArray arrayWithObjects:@"一卡通余额",@"自习教室",@"我与杭电图书馆",@"我的成绩", nil];
    _headerIcons = [NSMutableArray arrayWithObjects:@"pro_card_icon",@"pro_emptyroom_icon",@"pro_mylibrary_icon",@"pro_grade_icon", nil];
    _faceViews = [NSMutableArray arrayWithObjects:@"enptyroom_face",@"library_face",@"grade_face",nil];
    _cellTitles = [NSMutableArray arrayWithObjects:@"看看学霸们都待哪,6教？11教？...",@"看看我都借了啥？《红楼梦》,《三国演义》,《水浒传》貌似都没借,《西游记》倒是看了,点击查看详情",@"语文 － 100，数学 － 100...", nil];
}

- (void)_createViews{
    //分组表视图的创建
    _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 49) style:UITableViewStyleGrouped];
    [self.view addSubview:_mainTableView];
    _mainTableView.dataSource = self;
    _mainTableView.delegate = self;
    _mainTableView.backgroundColor = [UIColor colorWithRed:224 / 255.0 green:244 / 255.0 blue:255 / 255.0 alpha:1];
    _mainTableView.sectionHeaderHeight = 30;
    _mainTableView.sectionFooterHeight = 10;
    _mainTableView.rowHeight = 50;
    _mainTableView.bounces = NO;
    UINib *nib = [UINib nibWithNibName:@"NomalTableViewCell" bundle:nil];
    [_mainTableView registerNib:nib forCellReuseIdentifier:nomalIdentity];
}

#pragma mark-获取一卡通数据
- (void)_loadCardData{
    [self showHUD:nil];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:kPassword forKey:@"password"];
    [MyNetWorkQuery AFrequestData:info_card HTTPMethod:@"POST" params:params completionHandle:^(id result) {
        _balance = result[@"balance"];
        _balanceDic = result;
        [_mainTableView reloadData];
        [self hideHUD];
    } errorHandle:nil];
}


#pragma mark-主表视图的数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
#pragma mark-自定义各种cell，各种放
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 || indexPath.section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.backgroundColor = [UIColor colorWithRed:229 / 255.0 green:237 / 255.0 blue:239 / 255.0 alpha:1];
        if (indexPath.section == 1) {
            
            if ([_balance isEqual: [NSNull null]]) {
                cell.textLabel.text = @"当前余额: 998元-服务器错误,少侠重新来过！";
                return cell;
            }else if (_balance.length == 0) {
                cell.textLabel.text = @"当前余额: 998元-服务器错误,少侠重新来过！";
            }else{
                cell.textLabel.text = [NSString stringWithFormat:@"当前余额: %@元",_balance];
            }
            
            cell.textLabel.textColor = [UIColor colorWithRed:0 green:0.5 blue:1 alpha:1];
            cell.textLabel.font = [UIFont systemFontOfSize:20];
        }else if(indexPath.section == 0){
            cell.textLabel.text = @"闲着无聊,来后花园逛逛吧>>>>>>";
            cell.textLabel.textColor = [UIColor colorWithRed:0 green:0.8 blue:1 alpha:1];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        NomalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nomalIdentity forIndexPath:indexPath];
        cell.backgroundColor = [UIColor colorWithRed:229 / 255.0 green:237 / 255.0 blue:239 / 255.0 alpha:1];
        cell.faceImageView.image = [UIImage imageNamed:_faceViews[indexPath.section - 2]];
        cell.titleLabel.text = _cellTitles[indexPath.section - 2];
        cell.titleLabel.numberOfLines = 0;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
//组头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    SectionHeaderView *headerView = [[SectionHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    [headerView configIcon:_headerIcons[section - 1] Title:_headerTitles[section - 1]];
    headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main_table_cell@2x"]];
    return headerView;
}
//组尾视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth , 50)];
        UIButton *footerButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        [footerButton setBackgroundImage:[UIImage imageNamed:@"contrary_main_table_cell@2x"] forState:UIControlStateNormal];
        //箭头视图
        UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth / 2 + 50, 10, 25, 20)];
        arrow.image = [UIImage imageNamed:@"push_detail"];
        [footerButton addSubview:arrow];
        [footerButton setTitle:@"查看消费详情" forState:UIControlStateNormal];
        [footerButton setTitleColor:[UIColor colorWithRed:0 green:0.7 blue:1 alpha:1] forState:UIControlStateNormal];
        footerButton.contentEdgeInsets = UIEdgeInsetsMake(0,0, 0,30);
        [bgView addSubview:footerButton];
        [footerButton addTarget:self action:@selector(lookDetailAction:) forControlEvents:UIControlEventTouchUpInside];
        
        return bgView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        return 100;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 50;
    }
    return 10;
}
#pragma mark-单元格点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        GardenViewController *gardenVc = [[GardenViewController alloc]init];
        [self.navigationController pushViewController:gardenVc animated:YES];
    }else if (indexPath.section == 2) {
        EmptyroomDetailViewController *detailVc = [[EmptyroomDetailViewController alloc]init];
        detailVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVc animated:YES];
    }else if(indexPath.section == 3){
        MyLibraryViewController *liraryVc = [[MyLibraryViewController alloc]init];
        liraryVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:liraryVc animated:YES];
    }else if(indexPath.section == 4){
        GradeViewController *gradeVc = [[GradeViewController alloc]init];
        [self.navigationController pushViewController:gradeVc animated:YES];
    }
    
}

#pragma mark-查看余额详情动作
- (void)lookDetailAction:(UIButton *)button{

    BalanceViewController *balanceVc = [[BalanceViewController alloc]init];
    balanceVc.balanceDic = _balanceDic;
    balanceVc.balanceNow = _balance;
    [self.navigationController pushViewController:balanceVc animated:YES];
    
}
#pragma mark-第三方加载
//第三方加载
- (void)showHUD:(NSString *)title{
    
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _HUD.mode = MBProgressHUDModeIndeterminate;
    _HUD.yOffset = -30;
    _HUD.cornerRadius = 10;
    [_HUD show:YES];
    
    
}
- (void)hideHUD{
    [_HUD hide:YES];
}



@end
