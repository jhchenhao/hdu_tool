
//
//  BookDetailViewContoller.m
//  杭电神器
//
//  Created by 吴玉铁 on 15/9/28.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import "BookDetailViewContoller.h"

@interface BookDetailViewContoller (){
    BookDetailView *_bookDetailView;
    MBProgressHUD *_HUD;
    UIView *_maskView;
    AFHTTPRequestOperation *_operation;
}

@end

@implementation BookDetailViewContoller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self _createBackButton];
    [self _createMainViews];
    [self _loadDetailBookData];
}

- (void)_createBackButton{
    //返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(7, 24, 40, 40);
    [backButton setImage:[UIImage imageNamed:@"nav_back_arrowhead"] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)_createMainViews{
    _bookDetailView = [[BookDetailView alloc]initWithFrame:CGRectMake(0,64, kScreenWidth, kScreenHeight )];
    [self.view addSubview:_bookDetailView];
    
}

- (void)_loadDetailBookData{
    //取下对应书本数据吧
    //_HUD show
    [self showHUD:@"加载详情中"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    //参数例：id_book=0000485500
    [params setObject:self.bookId forKey:@"id_book"];
    _operation = [MyNetWorkQuery AFrequestData:book_info HTTPMethod:@"POST" params:params completionHandle:^(id result) {
        SearchBookModel *book = [[SearchBookModel alloc]initWithDataDic:result];
        _bookDetailView.bookModel = book;
        [self completeHUD:nil];
    } errorHandle:nil];

    //循环引用到解决
    __weak BookDetailViewContoller *weakSelf = self;
    [_operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        CGFloat progress = totalBytesRead * 1.0 / totalBytesExpectedToRead;
        __strong BookDetailViewContoller *strongSelf = weakSelf;
        strongSelf->_HUD.progress = progress;
    }];
    
    
}

- (void)backButtonAction:(UIButton *)button{
    
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark-第三方hud全套方法
//第三方加载
- (void)showHUD:(NSString *)title{
    if (_HUD == nil) {
        _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _HUD.mode = MBProgressHUDModeAnnularDeterminate;
        _HUD.yOffset = -30;
        _HUD.cornerRadius = 10;
    }
    [_HUD show:YES];
    _HUD.labelColor = [UIColor colorWithRed:0 green:0.6 blue:1 alpha:1];
    _HUD.labelFont = [UIFont fontWithName:@"JLinBo" size:17];
    //_HUD.dimBackground = YES;
    _HUD.labelText = title;
    _HUD.progress = 0.0;
    if (_maskView == nil) {
        _maskView = [[UIView alloc]initWithFrame:self.view.bounds];
        _maskView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_maskView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [_maskView addGestureRecognizer:tap];
        _maskView.hidden = NO;
    }
}
- (void)hideHUD{
    [_HUD hide:YES];
    _maskView.hidden = YES;
}
- (void)completeHUD:(NSString *)title{
    
    //_HUD.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"completed_icon"]];
   // _HUD.mode = MBProgressHUDModeCustomView;
    _HUD.progress = 1.0;
    _HUD.labelText = @"详情加载完毕";
    [_HUD hide:YES afterDelay:1.0];
    _maskView.hidden = YES;
    
}

- (void)tapAction{
    [_operation cancel];
    [self hideHUD];

}



@end
