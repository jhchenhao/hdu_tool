//
//  BaseViewController.m
//  XSWeibo
//
//  Created by apple on 15/9/7.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "BaseViewController.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setNavItems];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)_setNavItems{
    //rightItem
    UIButton *leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
    leftItem.backgroundColor = [UIColor clearColor];
    [leftItem setImage:[UIImage imageNamed:@"nav_left_icon"] forState:UIControlStateNormal];
    leftItem.frame = CGRectMake(0,0,35,35);
    [leftItem addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftItem];
    
}

- (void)leftAction{
    MMDrawerController *mmdrawerVC = self.mm_drawerController;
    [mmdrawerVC openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}


@end
