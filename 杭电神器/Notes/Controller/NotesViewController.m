//
//  NotesViewController.m
//  项目3 笔记
//
//  Created by mac on 15/10/2.
//  Copyright (c) 2015年 chenhao. All rights reserved.
//

#import "NotesViewController.h"
#import "NoteDB.h"
#import "CreateViewController.h"
#import "NotesTableView.h"

@interface NotesViewController ()
{
    NotesTableView *_noteTableView; //表视图
    NSMutableArray *_dataAry;
}

@end

@implementation NotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"烂笔头";
    self.navigationController.tabBarController.tabBar.translucent = NO;
    [self _createData];
    [self _creatRightItem];
    
    [self _creatTableView];
    [self _loadData];
    
}

#pragma mark - 数据库
//创建数据库
- (void)_createData
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:DataBaseFilePath]) {
        [NoteDB createData];

        
        [self creatFirstDefaultNote];
        [self creatSecondDefaultNote];
       // [self performSelector:@selector(creatSecondDefaultNote) withObject:nil afterDelay:1.0];
        
    }
}

- (void)creatFirstDefaultNote
{
    //创建默认的两条数据
    //创建noteModel
    NoteModel *note = [[NoteModel alloc] init];
    //设置时间
    NSDate *date = [NSDate new];
    NSDateFormatter *fomter = [[NSDateFormatter alloc] init];
    [fomter setDateFormat:@"yyyy-MM-dd"];
    NSString *year =[fomter stringFromDate:date];
    [fomter setDateFormat:@"HH:mm:ss"];
    NSString *time = [fomter stringFromDate:date];
    
    note.time = time;
    note.timeTitle = year;
    note.title = @"功能介绍";
    note.context = @"好记性不如烂笔头！\r\n用最简单的方式记下老师上课的作业、笔记，或者你的日常事务。\n1.实用最快捷的方式：以最快捷的方式启动应用快速记录。\r\n [赶快记下你最近的作业、笔记和事务吧。]";
    [NoteDB addNote:note];
}


- (void)creatSecondDefaultNote
{
    //创建默认的两条数据
    //创建noteModel
    NoteModel *note = [[NoteModel alloc] init];
    //设置时间
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:1];
    NSDateFormatter *fomter = [[NSDateFormatter alloc] init];
    [fomter setDateFormat:@"yyyy-MM-dd"];
    NSString *year =[fomter stringFromDate:date];
    [fomter setDateFormat:@"HH:mm:ss"];
    NSString *time = [fomter stringFromDate:date];
    
    note.time = time;
    note.timeTitle = year;
    note.title = @"删除教程";
    note.context = @"[笔记列表]向左滑动可删除记录哦！";
    [NoteDB addNote:note];
}
//读取数据库
- (void)_loadData
{
    if (_dataAry != nil) {
        [_dataAry removeAllObjects];
        _dataAry = nil;
    }
    _dataAry = [NSMutableArray array];
    [NoteDB searchNote:^(NSMutableArray *ary) {
        _dataAry = ary;
        _noteTableView.datasAry = _dataAry;
        [_noteTableView reloadData];
    }];
}

#pragma mark - 子视图
//创建表视图
- (void)_creatTableView
{
    _noteTableView = [[NotesTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 49)];
    [self.view addSubview:_noteTableView];
}

//创建右边item
- (void)_creatRightItem
{
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [addButton addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [addButton setImage:[UIImage imageNamed:@"home_channel_bar_add"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
}
//右边按钮点击事件
- (void)addButtonAction:(UIButton *)sender
{
    CreateViewController *createVC = [[CreateViewController alloc] init];
    createVC.hidesBottomBarWhenPushed = YES;
    
    //进入创建界面
    [self.navigationController pushViewController:createVC animated:YES];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [self _loadData];
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
