//
//  ZoomImageView.m
//  项目3
//
//  Created by mac on 15/9/29.
//  Copyright (c) 2015年 chenhao. All rights reserved.
//

#import "ZoomImageView.h"
#import "PhotoBroswerVC.h"
#import "UIView+NavigationController.h"

@interface ZoomImageView ()<UIScrollViewDelegate>
{
    UIView *_BGView; 
    UIImageView *_BGscrollView; //滑动视图
    UIImageView *_imageView;   //添加到滑动视图上的imageV
    
    UIScrollView *_textScrollView; //显示文字的scrollView
    UILabel *_textLabel;   //显示文字
    UILabel *_pageLabel;   //显示页码
    
    UITapGestureRecognizer *_oneTap;
}
@end

@implementation ZoomImageView

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
    [self networkImageShow:0];
}

/*
 *  展示网络图片
 */
-(void)networkImageShow:(NSUInteger)index{
    
    
    __weak typeof(self) weakSelf=self;
    
    [PhotoBroswerVC show:self.viewController type:PhotoBroswerVCTypeZoom index:index photoModelBlock:^NSArray *{
        
        NSMutableArray *networkImages = [NSMutableArray array];
        for (NSDictionary *dic in weakSelf.imageAry) {
            NSString *url = dic[@"imageUrl"];
            url = [edu_news_base stringByAppendingString:url];
            [networkImages addObject:url];
        }
        
        NSArray *networkImages1=@[
                                 @"http://www.netbian.com/d/file/20150519/f2897426d8747f2704f3d1e4c2e33fc2.jpg",
                                 @"http://www.netbian.com/d/file/20130502/701d50ab1c8ca5b5a7515b0098b7c3f3.jpg",
                                 @"http://www.netbian.com/d/file/20110418/48d30d13ae088fd80fde8b4f6f4e73f9.jpg",
                                 @"http://www.netbian.com/d/file/20150318/869f76bbd095942d8ca03ad4ad45fc80.jpg",
                                 @"http://www.netbian.com/d/file/20110424/b69ac12af595efc2473a93bc26c276b2.jpg",
                                 
                                 @"http://www.netbian.com/d/file/20140522/3e939daa0343d438195b710902590ea0.jpg",
                                 
                                 @"http://www.netbian.com/d/file/20141018/7ccbfeb9f47a729ffd6ac45115a647a3.jpg",
                                 
                                 @"http://www.netbian.com/d/file/20140724/fefe4f48b5563da35ff3e5b6aa091af4.jpg",
                                 
                                 @"http://www.netbian.com/d/file/20140529/95e170155a843061397b4bbcb1cefc50.jpg"
                                 ];
        
        NSMutableArray *modelsM = [NSMutableArray arrayWithCapacity:networkImages.count];
        for (NSUInteger i = 0; i< networkImages.count; i++) {
            NSDictionary *dic = weakSelf.imageAry[i];
            NSString *content = dic[@"imageContent"];
            PhotoModel *pbModel=[[PhotoModel alloc] init];
            pbModel.mid = i + 1;
            //pbModel.title = [NSString stringWithFormat:@"这是标题%@",@(i+1)];
            if (content && content.length > 0) {
                pbModel.desc = content;
            }
           // pbModel.desc = [NSString stringWithFormat:@"我是一段很长的描述文字我是一段很长的描述文字我是一段很长的描述文字我是一段很长的描述文字我是一段很长的描述文字我是一段很长的描述文字%@",@(i+1)];
            pbModel.image_HD_U = networkImages[i];
            
            //源frame
            UIImageView *imageV =(UIImageView *) weakSelf;
            pbModel.sourceImageView = imageV;
            
            [modelsM addObject:pbModel];
        }
        
        return modelsM;
    }];
}

/*
- (void)tapAction
{
    //创建视图
    [self _creatView];
    self.hidden = YES;
    _imageView.frame = [self convertRect:self.bounds toView:self.window];
    
    [UIView animateWithDuration:.3 animations:^{
        _imageView.frame = self.window.bounds;
    } completion:^(BOOL finished) {
        _BGView.backgroundColor = [UIColor blackColor];
        
        //设置底部的text和剩下的imageView
        NSDictionary *textDic = _imageAry[0];
        NSString *text = textDic[@"imageContent"];
        if (text && text.length > 0) {
            _textScrollView.hidden = NO;
            //计算高度
            CGRect rect = [text boundingRectWithSize:CGSizeMake(kScreenWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil];
            _textLabel.width = kScreenWidth;
            _textLabel.height = rect.size.height;
            _textLabel.text = text;
            _textScrollView.contentSize = CGSizeMake(0, rect.size.height);
        }
        //设置页数
        _pageLabel.bottom = kScreenHeight ;
        _pageLabel.text = [NSString stringWithFormat:@"1/%li",_imageAry.count];
        
        //创建剩下的imageView
        [self creatImageView];
        
    }];
}


//创建剩下的imageView
- (void)creatImageView
{
    //创建剩下的imageView
    if (_imageAry.count > 2) {
        for (int index = 1; index < _imageAry.count; index ++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth * index, 0, kScreenWidth, kScreenHeight)];
            [_BGscrollView addSubview:imageView];
        }
    }
}




- (void)_creatView
{
    if (_BGView == nil) {
        //创建最底层视图
        _BGView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self.window addSubview:_BGView];
        //底层滑动视图
        _BGscrollView = [[VIPhotoView alloc] initWithFrame:self.window.bounds andImage:self.image];
        _BGscrollView.showsHorizontalScrollIndicator = NO;
        _BGscrollView.bounces = NO;
        _BGscrollView.backgroundColor = [UIColor clearColor];
        //_BGscrollView.delegate = self;
        _BGscrollView.minimumZoomScale = 1;
        _BGscrollView.maximumZoomScale = 3;
        [_BGView addSubview:_BGscrollView];
        
        //创建第一张imageView
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.image = self.image;
        _imageView.userInteractionEnabled = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        //[_BGscrollView addSubview:_imageView];
        
        //给_BGscrollView添加一个手势 退出界面
        _oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(returnMainScrean)];
       // [_BGscrollView addGestureRecognizer:_oneTap];
        
        //创建底部的滑动视图
        _textScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 150, kScreenWidth, 150)];
        _textScrollView.hidden = YES;
        _textScrollView.backgroundColor = [UIColor clearColor];
        [_BGView addSubview:_textScrollView];
        
        //创建显示内容label
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.font = [UIFont systemFontOfSize:15];
        [_textScrollView addSubview:_textLabel];
        
        //创建显示页码的label
        _pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        _pageLabel.textColor = [UIColor whiteColor];
        [_BGView addSubview:_pageLabel];
        
        [self addDoubleTapGesture:_imageView];

    }
}

//返回主界面
- (void)returnMainScrean
{
    [UIView animateWithDuration:.3 animations:^{
        _BGView.backgroundColor = [UIColor clearColor];
        _imageView.frame = [self convertRect:self.bounds toView:self.window];
    } completion:^(BOOL finished) {
        [_BGView removeFromSuperview];
        self.hidden = NO;
        _BGView = nil;
    }];
}


- (void)addDoubleTapGesture:(UIImageView *)imageV
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
    tapGesture.numberOfTapsRequired = 2;
    tapGesture.numberOfTouchesRequired = 1;
    [imageV addGestureRecognizer:tapGesture];
    [_oneTap requireGestureRecognizerToFail:tapGesture];
    
}
- (void)doubleTapAction:(UITapGestureRecognizer *)tap
{
    CGPoint location = [tap locationInView:self.window];
    if (_BGscrollView.zoomScale <= _BGscrollView.minimumZoomScale) {
        [UIView animateWithDuration:.3 animations:^{
            CGRect zoomToRect = CGRectMake(0, 0, 50, 50);
            zoomToRect.origin = CGPointMake(location.x - CGRectGetWidth(zoomToRect)/2, location.y - CGRectGetHeight(zoomToRect)/2);
            [_BGscrollView zoomToRect:zoomToRect animated:NO];
           // _imageView.size = CGSizeMake(_imageView.size.width * 2, _imageView.size.height * 2);
            
        }];
    }
    else
    {
        [UIView animateWithDuration:.3 animations:^{
            _imageView.frame = self.window.bounds;
        }];
    }
    _BGscrollView.contentSize = _imageView.size;
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}




- (CGRect)getFrameSizeForImage:(UIImage *)image inImageView:(UIImageView *)imageView {
    
    float hfactor = image.size.width / imageView.frame.size.width;
    float vfactor = image.size.height / imageView.frame.size.height;
    
    float factor = fmax(hfactor, vfactor);
    
    // Divide the size by the greater of the vertical or horizontal shrinkage factor
    float newWidth = image.size.width / factor;
    float newHeight = image.size.height / factor;
    
    // Then figure out if you need to offset it to center vertically or horizontally
    float leftOffset = (imageView.frame.size.width - newWidth) / 2;
    float topOffset = (imageView.frame.size.height - newHeight) / 2;
    
    return CGRectMake(leftOffset, topOffset, newWidth, newHeight);
}
*/
@end
