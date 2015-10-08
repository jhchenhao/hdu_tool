//
//  GardenViewController.m
//  杭电神器
//
//  Created by 吴玉铁 on 15/10/4.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import "GardenViewController.h"
static NSString *identity = @"FollowerCell";

@interface GardenViewController (){
    UITableView *_tableView;
    NSArray *_followersData;
    MBProgressHUD *_HUD;
   
}

@end

@implementation GardenViewController

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    self.title = @"杭电后花园";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(_loadGardenData) name:kGardenLoadData object:nil];
    [self _createViews];
    [self _loadGardenData];


}

- (void)_createViews{
    //花园表
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.rowHeight = 60;
    _tableView.sectionHeaderHeight = 65;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UINib *nib = [UINib nibWithNibName:@"FollowerCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:identity];
   
    //增加花儿按钮
    UIButton *addButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 60, kScreenHeight - 49 - 64 - 70, 50, 50)];
    [addButton setBackgroundImage:[UIImage imageNamed:@"add_follower"] forState:UIControlStateNormal];
    [self.view addSubview:addButton];
    [addButton addTarget:self action:@selector(addFollowerAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)_loadGardenData{
    [self showHUD:nil];
    //创建BmobQuery实例，指定对应要操作的数据表名称
    BmobQuery *query = [BmobQuery queryWithClassName:@"HduGarden"];
    //按updatedAt进行降序排列
    [query orderByDescending:@"updatedAt"];
    //返回最多20个结果
    query.limit = 20;
    //执行查询
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        NSMutableArray *temp = [NSMutableArray array];
        for (BmobObject *bmobObj in array) {
            NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
            [dataDic setObject:[bmobObj objectForKey:@"followerName"] forKey:@"followerName"];
            [dataDic setObject:[bmobObj objectForKey:@"followerContent"] forKey:@"followerContent"];
            [dataDic setObject:[bmobObj objectForKey:@"followerThumbnail"] forKey:@"followerThumbnail"];
            [dataDic setObject:[bmobObj objectForKey:@"followerSupport"] forKey:@"followerSupport"];
            [dataDic setObject:bmobObj.objectId forKey:@"objectid"];
            FollowerModel *model = [[FollowerModel alloc]initWithDataDic:dataDic];
            [temp addObject:model];
           
        }
        _followersData = temp;
        [_tableView reloadData];
        [self hideHUD];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _followersData.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FollowerCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    FollowerModel *model = _followersData[indexPath.row];
    cell.follower = model;
    //设置背景
    UIImage *image = [UIImage imageNamed:@"edit_bg"];
    image = [image stretchableImageWithLeftCapWidth:15 topCapHeight:0];
    UIImageView *view = [[UIImageView alloc]initWithImage:image];
    view.frame = cell.bounds;
    cell.backgroundView = view;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FollowerModel *model = _followersData[indexPath.row];
    CGFloat height = [WXLabel getTextHeight:18 width:(kScreenWidth - 42) text:model.followerContent linespace:1];
    NSLog(@"%f",height);
    return height + 70;
}

#pragma mark-增加花园花儿动作
- (void)addFollowerAction:(UIButton *)button{
    SendViewController *senderVc = [[SendViewController alloc] init];
    senderVc.title = @"种些花儿";
    BaseNavController *baseVC = [[BaseNavController alloc]initWithRootViewController:senderVc];
    [self.navigationController presentViewController:baseVC animated:YES completion:nil];
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

@end
