//
//  ImageViewController.m
//  项目3
//
//  Created by mac on 15/10/5.
//  Copyright (c) 2015年 chenhao. All rights reserved.
//

#import "ImageViewController.h"
#import "VIPhotoView.h"

@interface ImageViewController ()
{
    UIView *_topView;
}

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建返回按钮
    [self addImage];
    [self creatReturnButton];
    
    //添加手势
    //[self addTap];
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return 1;
}
- (void)creatReturnButton
{
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    _topView.backgroundColor = [UIColor colorWithWhite:0 alpha:.4];
    [self.view addSubview:_topView];
    
    //按钮
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(5, 25, 30, 30)];
    [button setBackgroundImage:[UIImage imageNamed:@"contenttoolbar_hd_back"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(returnButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:button];
    
}

- (void)returnButtonAction:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addImage
{
    VIPhotoView *photo = [[VIPhotoView alloc] initWithFrame:self.view.bounds andImage:self.image];
    [self.view addSubview:photo];
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
