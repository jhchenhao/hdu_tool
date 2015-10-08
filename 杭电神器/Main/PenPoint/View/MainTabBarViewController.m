//
//  MainTabBarViewController.m
//  杭电神器
//
//  Created by 吴玉铁 on 15/9/25.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import "MainTabBarViewController.h"
#import "BaseNavController.h"
#import "ProMessageViewController.h"
#import "ClassScheduleViewController.h"
#import "LibraryViewController.h"
#import "IsTalkingViewController.h"
#import "PenPointViewController.h"

@interface MainTabBarViewController (){
    UIImageView *_selectedImageView;
    
}

@end

@implementation MainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _createSubControllers];
    [self _createTabBar];
    
}

- (void)_createSubControllers{
    NSArray *names = @[@"ProMessage",
                       @"ClassSchedule",
                       @"Library",
                       @"IsTalking",
                       @"PenPoint"];
    NSMutableArray *navs = [[NSMutableArray alloc]initWithCapacity:names.count];
    for (int i = 0; i < 5; i++) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:names[i] bundle:nil];
        BaseNavController *navVC = [storyBoard instantiateInitialViewController];
        [navs addObject:navVC];
    }
    self.viewControllers = navs;
}

- (void)_createTabBar{
    //移除tabBar子项
    for (UIView *view in self.tabBar.subviews) {
        Class class = NSClassFromString(@"UITabBarButton");
        if ([view isKindOfClass:class]) {
            [view removeFromSuperview];
        }
    }
    //创建新项
    NSArray *titles = @[@"我在",@"课程表",@"图书馆",@"校头条",@"笔记"];
    NSArray *imageNames = @[
                            @"main_tab_icon_1.png",
                            @"main_tab_icon_2.png",
                            @"main_tab_icon_3.png",
                            @"main_tab_icon_4.png",
                            @"main_tab_icon_5.png",
                            ];
    CGFloat itemWidth = kScreenWidth / imageNames.count;
    for (int i = 0; i < imageNames.count; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(i * itemWidth,0, itemWidth,49)];
        [button setImage:[UIImage imageNamed:imageNames[i]] forState:UIControlStateNormal];
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 10, 0);
        [self.tabBar addSubview:button];
        [button addTarget:self action:@selector(selectedAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 100 + i;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0,35, itemWidth, 12)];
        label.font = [UIFont systemFontOfSize:10];
        label.text = titles[i];
        label.textAlignment = NSTextAlignmentCenter;
        [button addSubview:label];
    }
    //选中视图
    _selectedImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,itemWidth, 49)];
    [_selectedImageView setImage:[UIImage imageNamed:@"main_tab_item_selected"]];
    [self.tabBar addSubview:_selectedImageView];
}


- (void)selectedAction:(UIButton *)button{
    [UIView animateWithDuration:0.3 animations:^{
        _selectedImageView.center = button.center;
    }];
    self.selectedIndex = (button.tag - 100);
    
}



@end
