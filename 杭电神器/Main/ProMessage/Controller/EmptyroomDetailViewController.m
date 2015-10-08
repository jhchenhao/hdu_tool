//
//  EmptyroomDetailViewController.m
//  杭电神器
//
//  Created by 吴玉铁 on 15/10/2.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import "EmptyroomDetailViewController.h"

@interface EmptyroomDetailViewController (){
    UIScrollView *_scrollView;
    MBProgressHUD *_HUD;
}

@end

@implementation EmptyroomDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self _createViews];
    [self _loadClassRoomData];
    
}

- (void)_createViews{
    //创建部门视图
    NSArray *items = @[@"3教",@"6教",@"7教",@"11教",@"12教"];
    
    UISegmentedControl *segControl = [[UISegmentedControl alloc]initWithItems:items];
    [self.view addSubview:segControl];
    segControl.width = kScreenWidth;
    [segControl addTarget:self action:@selector(segAction:) forControlEvents:UIControlEventValueChanged];
    segControl.selectedSegmentIndex = 1;
    //创建滑动
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, segControl.bottom, kScreenWidth, kScreenHeight - segControl.height)];
    _scrollView.contentSize = CGSizeMake(kScreenWidth * 5, kScreenHeight - 64);
    _scrollView.scrollEnabled = NO;
    [self.view addSubview:_scrollView];
    [_scrollView setContentOffset:CGPointMake(segControl.selectedSegmentIndex * kScreenWidth, 0) animated:YES];
    //循环创建表视图
    for (NSInteger i = 0; i < 5; i++) {
        EmptyroomTableView *roomTable = [[EmptyroomTableView alloc]initWithFrame:CGRectMake(kScreenWidth * i,0, kScreenWidth, kScreenHeight - segControl.height - 64) style:UITableViewStylePlain];
        roomTable.top = _scrollView.top - 30;
        [_scrollView addSubview:roomTable];
        roomTable.tag = 100 + i;
    }
}

- (void)segAction:(UISegmentedControl *)seg{
    NSInteger index = seg.selectedSegmentIndex;
    NSLog(@"%ld",(long)index);
    [_scrollView setContentOffset:CGPointMake(index * kScreenWidth, 0) animated:YES];
}

- (void)_loadClassRoomData{
    [self showHUD:@"教室加载中"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [MyNetWorkQuery AFrequestData:class_room HTTPMethod:@"POST" params:params completionHandle:^(id result) {
        //11 12 3 6 7排序 成 3 6 7 11 12
        NSDictionary *dic = result;
        if (dic.count == 1) {
            NSLog(@"请求错误，服务器问题");
            [self completeHUD:@"错误提示"];
            return ;
        }
        NSArray *array3 = result[@"3"];
        NSArray *array6 = result[@"6"];
        NSArray *array7 = result[@"7"];
        NSArray *array11 = result[@"11"];
        NSArray *array12 = result[@"12"];
        NSArray *buildingIndexs = @[@"3",@"6",@"7",@"11",@"12"];
        NSArray *greenValues = @[@0.4,@0.5,@0.6,@0.7,@0.8];
        NSMutableArray *newResult = [NSMutableArray arrayWithObjects:array3,array6,array7,array11,array12, nil];
        //刷新各个表视图
        for (NSInteger i = 0; i < 5; i++) {
            EmptyroomTableView *roomTable = (EmptyroomTableView *)[_scrollView viewWithTag:100+i];
            //roomTable.emptyRooms = [self sortBuildingIndexs:newResult[i]];
            roomTable.emptyRooms = newResult[i];
            roomTable.bulidingIndex = buildingIndexs[i];
            roomTable.textColor = [UIColor colorWithRed:0 green:[greenValues[i] floatValue] blue:1 alpha:1];
            [roomTable reloadData];
        }
        [self completeHUD:@"自习室列表加载完毕"];
    } errorHandle:nil];
}
#pragma mark-整理下拿到的教室 冒泡排序从小到大排起来
- (NSArray *)sortBuildingIndexs:(NSArray *)indexs{
    NSMutableArray *data = [NSMutableArray array];
    for (NSString *index in indexs) {
        NSString *newIndex;
        if (index.length == 4) {
            newIndex = [index substringFromIndex:1];
        }else if(index.length == 3){
            newIndex = index;
        }
        NSInteger interIndex = [newIndex integerValue];
        NSNumber *numberIndex = [[NSNumber alloc]initWithInteger:interIndex];
        [data addObject:numberIndex];
    }
    
    for (int i=0; i<[data count]-1; i++) {
        for (int j =0; j<[data count]-1-i; j++) {
            if ([data objectAtIndex:j] > [data objectAtIndex:j+1]) {
                [data exchangeObjectAtIndex:j withObjectAtIndex:j+1];
            }
        }
    }
    return  data;
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
    if (_HUD.labelText.length == 4) {
        _HUD.detailsLabelText = @"服务器垃圾，少侠请重新来过!";
        _HUD.detailsLabelFont = [UIFont systemFontOfSize:15];
    }
    [_HUD hide:YES afterDelay:1.5];
}



@end
