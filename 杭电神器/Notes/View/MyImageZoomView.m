//
//  MyImageZoomView.m
//  项目3
//
//  Created by mac on 15/10/5.
//  Copyright (c) 2015年 chenhao. All rights reserved.
//

#import "MyImageZoomView.h"
#import "ImageViewController.h"
#import "UIView+NavigationController.h"


@implementation MyImageZoomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self addTapGesture];
    }
    return self;
}

//添加手势
- (void)addTapGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
}

- (void)tapAction
{
    if (self.checkBlock) {
        self.checkBlock();
    }
    if (self.event == NoneImageView) {
        return;
    }
    else if (self.event == WatchImageView)
    {
        //只是看图片
        if (self.watchBlock) {
            self.watchBlock();
        }
//        [self watchImageView];
    }
    else if (self.event == EditImageView)
    {
        //编辑图片
        UIAlertView *view = [[UIAlertView alloc] initWithTitle:nil message:@"选择" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除图片",@"查看图片",nil];
        view.alertViewStyle = UIAlertViewStyleDefault;
        [view show];
    }
    
}

//警告视图代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //取消
        NSLog(@"0");
    }
    else if (buttonIndex == 1)
    {
        //删除
        NSLog(@"1");
        if (self.block) {
            self.block();
        }
        
    }
    else if (buttonIndex == 2)
    {
        //查看
        NSLog(@"2");
        if (self.watchBlock) {
            self.watchBlock();
        }
//        [self watchImageView];
    }
}


- (void)watchImageView
{
    ImageViewController *imageVC = [[ImageViewController alloc] init];
    imageVC.image = self.image;
    imageVC.view.backgroundColor = [UIColor blackColor];
    //进入模态视图
    [self.viewController presentViewController:imageVC animated:YES completion:nil];
}

@end
