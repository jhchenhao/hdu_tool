//
//  DetailViewController.m
//  项目3
//
//  Created by mac on 15/10/4.
//  Copyright (c) 2015年 chenhao. All rights reserved.
//

#import "DetailViewController.h"
#import "CreateViewController.h"
#import "NSString+CalculateHeight.h"
#import "MyImageZoomView.h"
#import "PhotoBroswerVC.h"

@interface DetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    UILabel *_titleLabel; //标题
    UILabel *_timeLabel;  //创建时间
    UILabel *_contextLabel; //内容
    UIScrollView *_scrollView;
    MyImageZoomView *_imageView; //图片
    UICollectionView *_collectionView;
    NSMutableArray *_imagesAry; //存储图片
}



@end

@implementation DetailViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _imagesAry = [NSMutableArray array];
        [self _creatSubViews];
    }
    return self;
}

- (void)_creatSubViews
{
    //标题
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.font = [UIFont boldSystemFontOfSize:22];
    _titleLabel.textColor = [UIColor greenColor];
    _titleLabel.numberOfLines = 0;
    [self.view addSubview:_titleLabel];
    
    //图片
//    _imageView = [[MyImageZoomView alloc] initWithFrame:CGRectZero];
//    _imageView.event = WatchImageView;
//    [self.view addSubview:_imageView];
    
    [self creatCollectionView];
    
    //内容
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_scrollView];
    _contextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _contextLabel.numberOfLines = 0;
    _contextLabel.font = [UIFont systemFontOfSize:15];
    [_scrollView addSubview:_contextLabel];
    
    //创建时间
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _timeLabel.font = [UIFont boldSystemFontOfSize:10];
    _timeLabel.textColor = [UIColor blueColor];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    [_scrollView addSubview:_timeLabel];
}


//重新布局
- (void)viewWillAppear:(BOOL)animated
{
    //标题
    CGFloat titleHeight = [self.note.title getHeightofFont:[UIFont boldSystemFontOfSize:22] width:kScreenWidth - 10];
    _titleLabel.frame = CGRectMake(5, 5, kScreenWidth - 10, titleHeight);
    _titleLabel.text = self.note.title;
    
    //内容
    _scrollView.frame = CGRectMake(0, _titleLabel.bottom + 10, kScreenWidth, kScreenHeight - 64 - _titleLabel.bottom - 10);
    CGFloat contextHeight = [self.note.context getHeightofFont:[UIFont systemFontOfSize:15] width:kScreenWidth - 10];
    _contextLabel.frame = CGRectMake(5, 0, kScreenWidth - 10, contextHeight);
    _contextLabel.text = self.note.context;
    
    //图片
    if (self.note.image) {
        _imagesAry = (NSMutableArray *)[self.note.image componentsSeparatedByString:@","];
        [_collectionView reloadData];
        _collectionView.frame = CGRectMake(0, _titleLabel.bottom + 5, kScreenWidth, 100);
        _scrollView.frame = CGRectMake(0, _collectionView.bottom + 10, kScreenWidth, kScreenHeight - 64 - _imageView.bottom - 10);
    }
    if (contextHeight > _scrollView.height) {
        _scrollView.contentSize = CGSizeMake(0, contextHeight + 30);
    }
    
    //时间
    _timeLabel.frame = CGRectMake(5, _contextLabel.bottom + 10, kScreenWidth - 10, 20);
    NSString *time = [self.note.time substringWithRange:NSMakeRange(0, 5)];
    _timeLabel.text = [NSString stringWithFormat:@"创建于 %@ %@",self.note.timeTitle,time];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查看";
    
    [self _creatRightItem];
}

- (void)_creatRightItem
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAction)];
    self.navigationItem.rightBarButtonItem = item;
}
- (void)rightItemAction
{
    CreateViewController *createVC = [[CreateViewController alloc] init];
    createVC.hidesBottomBarWhenPushed = YES;
    createVC.note = self.note;
    
    __weak DetailViewController *weekSelf = self;
    createVC.noteBlock = ^(NoteModel *note)
    {
        weekSelf.note = note;
    };
    //进入创建界面
    [self.navigationController pushViewController:createVC animated:YES];
}


#pragma mark - 创建collectionView
- (void)creatCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(130, 90);
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    layout.minimumInteritemSpacing = 10;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:_collectionView];
    _collectionView.backgroundColor = [UIColor clearColor];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _imagesAry.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    MyImageZoomView *imageV = [[MyImageZoomView alloc] initWithFrame:cell.bounds];
    //设置imageView边框弧度
    cell.layer.cornerRadius = 10;
    cell.layer.borderColor = [UIColor orangeColor].CGColor;
    cell.layer.borderWidth = 2;
    imageV.layer.masksToBounds = YES;
    imageV.layer.cornerRadius = 10;

    
    imageV.tag = 100;
    NSString *name = [DataImageFilePath stringByAppendingPathComponent:_imagesAry[indexPath.row]];
    imageV.image = [UIImage imageNamed:name];
    imageV.event = WatchImageView;
    __weak DetailViewController *weakSelf = self;
    imageV.watchBlock = ^{
        [weakSelf localImageShow:indexPath.row];
    };
    
    [cell.contentView addSubview:imageV];
    
    
    return cell;
}


//查看本地图片
-(void)localImageShow:(NSUInteger)index{
    
    __weak typeof(self) weakSelf=self;
    
    [PhotoBroswerVC show:self type:PhotoBroswerVCTypeZoom index:index photoModelBlock:^NSArray *{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        NSMutableArray *imagesAry = [NSMutableArray array];
        for (NSString *name in strongSelf -> _imagesAry) {
            NSString *namefile = [DataImageFilePath stringByAppendingPathComponent:name];
            UIImage *image = [UIImage imageNamed:namefile];
            [imagesAry addObject:image];
        }
        NSArray *localImages = imagesAry;
        
        NSMutableArray *modelsM = [NSMutableArray arrayWithCapacity:localImages.count];
        for (NSUInteger i = 0; i< localImages.count; i++) {
            
            PhotoModel *pbModel=[[PhotoModel alloc] init];
            pbModel.mid = i + 1;
            pbModel.image = localImages[i];
            
            //源frame
            NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
            UICollectionViewCell *cell = [strongSelf -> _collectionView cellForItemAtIndexPath:path];
            MyImageZoomView *imageView = (MyImageZoomView *)[cell viewWithTag:100];
            //            UIImageView *imageV =imageView //
            pbModel.sourceImageView = imageView;
            
            [modelsM addObject:pbModel];
        }
        
        return modelsM;
    }];
}

@end
