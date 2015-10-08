//
//  NewsDetailViewController.m
//  项目3
//
//  Created by mac on 15/9/29.
//  Copyright (c) 2015年 chenhao. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "WXLabel.h"
#import "AnalysisHtml.h"
#import "UIImageView+WebCache.h"
#import "ZoomImageView.h"
#import "MBProgressHUD.h"

@interface NewsDetailViewController ()
{
    UIScrollView *_BGSscrollView;
    UILabel *_titleLabel; //标题
//    WXLabel *_timeLabel;  //时间
    ZoomImageView *_imageView; //图片
    UILabel *_sourceLabel;  //来源
    UILabel *_contentLabel;  //内容
    
    NSMutableDictionary *_contentDic;//内容字典
    
    NSString *_contentText;  //内容文字
    NSString *_sourceText;    //来源文字
    NSArray *_imageAry;  //图片字典
    
    NSUserDefaults *_userDefault;
    UIButton *_collectButton; //收藏按钮
}



@end

@implementation NewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatItem];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

- (void)creatItem
{
    //创建返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(leftItemAction)];
    
    //创建收藏按钮
    _collectButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 17)];
    _collectButton.tag = 100;
    [_collectButton addTarget:self action:@selector(collectionAction:) forControlEvents:UIControlEventTouchUpInside];
    [_collectButton setBackgroundImage:[UIImage imageNamed:@"action_love@2x"] forState:UIControlStateNormal];
    [_collectButton setBackgroundImage:[UIImage imageNamed:@"action_love_selected@2x"] forState:UIControlStateSelected];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_collectButton];
    
    
    
}
- (void)leftItemAction
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

//点击收藏按钮
- (void)collectionAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        //收藏
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[_userDefault objectForKey:@"collect"]];
        NSMutableDictionary *subDic = [NSMutableDictionary dictionary];
        [subDic setObject:@"YES" forKey:@"isCollect"];
        [subDic setObject:self.titleModel.title forKey:@"title"];
        [subDic setObject:self.titleModel.time forKey:@"time"];
        [subDic setObject:self.titleModel.href forKey:@"href"];

        [dic setObject:subDic forKey:self.titleModel.href];
        [_userDefault setObject:dic forKey:@"collect"];
        //同步数据
        [_userDefault synchronize];
    }
    else
    {
        //取消收藏
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[_userDefault objectForKey:@"collect"]];
        [dic removeObjectForKey:self.titleModel.href];
        [_userDefault setObject:dic forKey:@"collect"];
        [_userDefault synchronize];
    }
}


#pragma mark - 创建控制器上的view
//创建此控制器时创建控制器视图上的view
- (instancetype)init
{
    self = [super init];
    if (self) {
        _userDefault = [NSUserDefaults standardUserDefaults];
        [self _creatSubView];
    }
    return self;
}

- (void)_creatSubView
{
    //创建滑动视图
    _BGSscrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _BGSscrollView.height -= 64;
    [self.view addSubview:_BGSscrollView];
    
    //创建标题label
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.font = [UIFont boldSystemFontOfSize:22];
    _titleLabel.textColor = [UIColor blackColor];
    [_BGSscrollView addSubview:_titleLabel];
    
    //创建来源label
    _sourceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _sourceLabel.font = [UIFont systemFontOfSize:10];
    [_BGSscrollView addSubview:_sourceLabel];
    
    //创建内容label
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _contentLabel.numberOfLines = 0;
    _contentLabel.font = [UIFont systemFontOfSize:15];
//    _contentLabel.font = [UIFont fontWithName:@"Courier-Oblique" size:15];
    [_BGSscrollView addSubview:_contentLabel];
    
    //创建imageView
    _imageView = [[ZoomImageView alloc] initWithFrame:CGRectZero];
    [_BGSscrollView addSubview:_imageView];
    
}


- (void)setTitleModel:(PlistModel *)titleModel
{
    if (_titleModel != titleModel) {
        _titleModel = titleModel;
        
        MBProgressHUD *hud = [MBProgressHUD  showHUDAddedTo:self.view animated:YES];
        hud.dimBackground = YES;
        //判断是否收藏
        NSMutableDictionary *dic = [_userDefault objectForKey:@"collect"];
        NSDictionary *subDic = dic[self.titleModel.href];
        if (subDic) {
            _collectButton.selected = YES;
        }
        
        
        _contentDic = [NSMutableDictionary dictionary];
        
        // 设置标题frame
        _titleLabel.numberOfLines = 0;
        _titleLabel.text = titleModel.title;
        CGRect rect = [titleModel.title boundingRectWithSize:CGSizeMake(kScreenWidth - 20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:22]} context:nil];
        CGFloat titleHeight = rect.size.height;
        _titleLabel.frame = CGRectMake(10, 5, kScreenWidth - 20, titleHeight);
        
        //获取到内容
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            _contentDic = [AnalysisHtml analysisONENewsHtmlWithURLStr:titleModel.href node:news_content_node];
            //读取出数据
            _imageAry = _contentDic[@"image"];
            _contentText = _contentDic[@"content"];
            _sourceText = _contentDic[@"source"];
            
            //刷新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                [self refreshUI];
                [hud hide:YES];
            });
        });
        
    }
}
//刷新ui
- (void)refreshUI
{
    //来源
    _sourceLabel.numberOfLines = 0;
    _sourceLabel.text = _sourceText;
    CGRect scurceRect = [_sourceText boundingRectWithSize:CGSizeMake(kScreenWidth - 20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:10]} context:nil];
    CGFloat sourceHeight = scurceRect.size.height;
    
    _sourceLabel.frame = CGRectMake(10, _titleLabel.bottom + 5, kScreenWidth - 20, sourceHeight);

    //显示内容
    
//    _contentLabel.lineBreakMode = UILineBreakModeCharacterWrap;
    CGRect rect = [_contentText boundingRectWithSize:CGSizeMake(kScreenWidth - 20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil];
    CGFloat contentHeight = rect.size.height;
//    CGFloat contentHeight = [WXLabel getTextHeight:15 width:kScreenWidth - 20 text:_contentText linespace:_contentText.length * 1.1];
    
    
    _contentLabel.frame = CGRectMake(10, _sourceLabel.bottom + 5, kScreenWidth - 20, contentHeight);
    _contentLabel.text = _contentText;
    //图片
    if (_imageAry && _imageAry.count > 0) {
        _imageView.frame = CGRectMake(10, _sourceLabel.bottom + 5, kScreenWidth - 20, 200);
        _imageView.imageAry = _imageAry;
        
        //创建图片底部视图
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, _imageView.height , _imageView.width, 20)];
        [_imageView addSubview:view];
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        imageV.image = [UIImage imageNamed:@"image63"];
        
        [view addSubview:imageV];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 20, 20)];
        label.text = [NSString stringWithFormat:@"%li",_imageAry.count];
        label.font = [UIFont systemFontOfSize:10];
        label.textAlignment = NSTextAlignmentLeft;
        [view addSubview:label];
        
        //设置内容frme
        _contentLabel.frame = CGRectMake(10, _imageView.bottom + 30, kScreenWidth - 20, contentHeight);
        
        //显示第一张图片
        NSDictionary *dic = _imageAry[0];
        NSString *imageUrl = [edu_news_base stringByAppendingString:dic[@"imageUrl"]];
        [_imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    }
    
    //设置内容文字
    
    _BGSscrollView.contentSize = CGSizeMake(0, _contentLabel.bottom + 5);
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
