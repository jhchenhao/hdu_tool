//
//  MyLibraryViewController.m
//  杭电神器
//
//  Created by 吴玉铁 on 15/10/3.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import "MyLibraryViewController.h"


@interface MyLibraryViewController (){
    UIScrollView *_scrollView;
    UIView *_selectedView;
    MBProgressHUD *_HUD;
}

@end

@implementation MyLibraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self _createViews];
    [self _loadMyBookData];
}

- (void)_createViews{
    //底部条子
    UIView *topBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 35)];
    topBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main_table_cell@2x"]];
    [self.view addSubview:topBar];
    topBar.layer.borderWidth = 0.3f;
    topBar.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //选中图片
    if (_selectedView == nil) {
        _selectedView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
        _selectedView.backgroundColor = [UIColor colorWithRed:0 green:0.6 blue:1 alpha:0.8];
        _selectedView.layer.cornerRadius = 15;
        [topBar addSubview:_selectedView];
    }
    //条上按钮
    NSArray *titles = @[@"借阅",@"预约"];
    for (NSInteger i = 0; i < 2; i ++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake((kScreenWidth - 160) / 2 + 80 * i, 3, 80, 30)];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor colorWithRed:0 green:0.6 blue:1 alpha:0.8] forState:UIControlStateNormal];
        if (i == 0) {
            button.selected = YES;
            _selectedView.center = button.center;
        }
        [topBar addSubview:button];
        button.tag = 100 + i;
        [button addTarget:self action:@selector(buttonAction:AcitonTime:) forControlEvents:UIControlEventTouchUpInside];
    }
    //滑动视图
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, topBar.bottom, kScreenWidth, kScreenHeight - topBar.bottom)];
    }
    _scrollView.contentSize = CGSizeMake(kScreenWidth * 2, kScreenHeight - topBar.bottom);
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    //创建表视图
    for (NSInteger i = 0; i < 2; i ++) {
        LendTableView *lendTable = [[LendTableView alloc]initWithFrame:CGRectMake(kScreenWidth * i, 0, kScreenWidth, _scrollView.height - 60) style:UITableViewStylePlain];
        lendTable.tag = 200 + i;
        [_scrollView addSubview:lendTable];
        if (i == 0) {
            lendTable.backgroundColor = [UIColor colorWithRed:224 / 255.0 green:244 / 255.0 blue:255 / 255.0 alpha:1];
        }else if(i == 1){
            lendTable.backgroundColor = [UIColor whiteColor];
        }
        
    }
    
}

#pragma mark-加载借阅数据
- (void)_loadMyBookData{
    [self showHUD:@"加载ing..."];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [MyNetWorkQuery AFrequestData:center_person HTTPMethod:@"POST" params:params completionHandle:^(id result) {
        [self completeHUD:@"少侠慢看"];
        //传数据,处理数据
        LendTableView *lenTable = (LendTableView *)[_scrollView viewWithTag:200];
        lenTable.historyData = [self parseArrayToModelArray:result[@"lend_mine"][@"history"]];
        lenTable.nowData = [self parseArrayToModelArray:result[@"lend_mine"][@"now"]];
        lenTable.backgroundColor = [UIColor colorWithRed:224 / 255.0 green:244 / 255.0 blue:255 / 255.0 alpha:1];
        lenTable.isReserved = NO;
        [lenTable reloadData];
        
        LendTableView *reservationTable = (LendTableView *)[_scrollView viewWithTag:201];
        reservationTable.historyData = [self parseArrayToModelArray:result[@"reservation_mine"][@"history"]];
        reservationTable.nowData = [self parseArrayToModelArray:result[@"reservation_mine"][@"now"]];
        reservationTable.isReserved = YES;
        [reservationTable reloadData];
    } errorHandle:nil];
     
}

#pragma 条子按钮动作
- (void)buttonAction:(UIButton *)button AcitonTime:(CGFloat)time{
    if (time == 0) {
        time = 0.3;
    }
    UIButton *previousButton;
    if (button.tag == 100) {
        previousButton = (UIButton *)[self.view viewWithTag:101];
    }else if(button.tag == 101){
        previousButton = (UIButton *)[self.view viewWithTag:100];
    }
    
    if (button.selected == YES) {
        return;
    }
    LendTableView *lenTable = (LendTableView *)[_scrollView viewWithTag:200];
    LendTableView *revTable = (LendTableView *)[_scrollView viewWithTag:201];
    [UIView transitionWithView:_selectedView duration:time options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        _selectedView.center = button.center;
        UIColor *tempColor = lenTable.backgroundColor;
        lenTable.backgroundColor = revTable.backgroundColor;
        revTable.backgroundColor = tempColor;
    } completion:^(BOOL finished) {
        previousButton.selected = !previousButton.selected;
        button.selected = !button.selected;
        
    }];
    
    [_scrollView setContentOffset:CGPointMake((button.tag - 100) * kScreenWidth, 0) animated:YES];
   
}

#pragma mark-滑动视图代理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger index = scrollView.contentOffset.x / kScreenWidth;
    UIButton *button = (UIButton *)[self.view viewWithTag:index + 100];
    [self buttonAction:button AcitonTime:0.05];
    
}

#pragma mark-封装方法，把数组里的倒成model 的数组
- (NSArray *)parseArrayToModelArray:(NSArray *)array{
    NSMutableArray *tempArray = [NSMutableArray array];
    //如果没书。自己加个model进去
    if (array.count == 0) {
        NSDictionary *dataDic = @{@"name":@"没书,没书,真的没书!"};
        LendBookModel *model = [[LendBookModel alloc]initWithDataDic:dataDic];
        [tempArray addObject:model];
    }else{
        for (NSDictionary *dataDic in array) {
            LendBookModel *model = [[LendBookModel alloc]initWithDataDic:dataDic];
            [tempArray addObject:model];
        }
    }
    return tempArray;
}

#pragma mark-第三方加载
//第三方加载
- (void)showHUD:(NSString *)title{
    
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _HUD.mode = MBProgressHUDModeIndeterminate;
    _HUD.yOffset = -30;
    _HUD.cornerRadius = 10;
    
    [_HUD show:YES];
    
    _HUD.labelColor = [UIColor colorWithRed:0 green:0.6 blue:1 alpha:1];
    _HUD.labelFont = [UIFont fontWithName:@"JLinBo" size:17];
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
