//
//  CreateViewController.m
//  项目3
//
//  Created by mac on 15/10/3.
//  Copyright (c) 2015年 chenhao. All rights reserved.
//

#import "CreateViewController.h"
#import "RegexKitLite.h"
#import "NoteDB.h"
#import "NoteModel.h"
#import "MyImageZoomView.h"
#import "PhotoBroswerVC.h"


@interface CreateViewController ()<UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    MyImageZoomView *_imageView;  //显示图片
    UITextView *_contentView;  //显示内容
    
    UILabel *_contextPromptLabel;
    NSString *_imagePath;
    NSString *_imageName; //图片的名字
    
    NSMutableArray *_imagesAry; //存储图片
    UICollectionView *_collectionView;
    
}

@end

@implementation CreateViewController

#pragma mark - 通知
//移除通知
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//添加通知
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _createSubViews];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    return self;
}

- (void)keyBoardChangeFrame:(NSNotification *)notification
{
    NSDictionary *dic = notification.userInfo;
    NSValue *value = dic[UIKeyboardFrameEndUserInfoKey];
    CGRect frame = [value CGRectValue];
    NSLog(@"%@",notification.userInfo);
    _contentView.height = kScreenHeight - _contentView.frame.origin.y  - (kScreenHeight - frame.origin.y) - 64 - 5;
    
}

#pragma mark - textviewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        _contextPromptLabel.hidden = NO;
    }
    else
    {
        _contextPromptLabel.hidden = YES;
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleText becomeFirstResponder];
    [self addTapGesture];
    [self _creatRightItem];
    
}

- (void)_creatRightItem
{
    UIButton *right = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [right addTarget:self action:@selector(completionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [right setBackgroundImage:[UIImage imageNamed:@"share_send@2x"] forState:UIControlStateNormal];
    [right setBackgroundImage:[UIImage imageNamed:@"share_send_highlighted@2x"] forState:UIControlStateHighlighted];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:right];
}

//存入数据库
- (void)completionButtonAction:(UIButton *)sender
{
    if (self.note) {
        [NoteDB removeNote:self.note];
    }
    if (_titleText.text.length > 20) {
        UIAlertView *aler = [[UIAlertView alloc] initWithTitle:@"标题请少于20字" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [aler show];
        return;
    }
    if (_contentView.text.length == 0 && _imagePath.length == 0) {
        UIAlertView *aler = [[UIAlertView alloc] initWithTitle:@"请输入内容" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [aler show];
        return;
    }
    //创建noteModel
    NoteModel *model = [[NoteModel alloc] init];
    //设置时间
    NSDate *date = [NSDate new];
    NSDateFormatter *fomter = [[NSDateFormatter alloc] init];
    [fomter setDateFormat:@"yyyy-MM-dd"];
    NSString *year =[fomter stringFromDate:date];
    [fomter setDateFormat:@"HH:mm:ss"];
    NSString *time = [fomter stringFromDate:date];
    //设置note
    model.timeTitle = year;
    model.time = time;
    model.title = _titleText.text;
    model.context = _contentView.text;
    
    NSString *imageName = [_imagesAry componentsJoinedByString:@","];
    model.image = imageName;
    
    [NoteDB addNote:model];
    //返回原本控制器
    if (self.block) {
        self.block();
    }
    if (self.noteBlock) {
        self.noteBlock(model);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

//给视图添加一个手势
- (void)addTapGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];
}
- (void)tapAction
{
    [self.titleText resignFirstResponder];
    [_contentView resignFirstResponder];
}

#pragma mark - 创建子视图
- (void)_createSubViews
{
    //创建imageV
    _imageView = [[MyImageZoomView alloc] initWithFrame:CGRectZero];
    _imageView.event = EditImageView;
    
    
    [self.view addSubview:_imageView];
    
    //创建内容视图
    _contentView = [[UITextView alloc] initWithFrame:CGRectMake(5,_addImageB.bottom , kScreenWidth - 10, kScreenHeight - _contentView.frame.origin.y - 64 - 5 - 80  )];
    _contentView.layer.cornerRadius = 5;
    _contentView.layer.borderWidth = 1;
    _contentView.layer.borderColor = [UIColor blackColor].CGColor;
    _contentView.font = [UIFont  systemFontOfSize:20];
//    _contentView.backgroundColor = [UIColor darkGrayColor];
    _contentView.delegate = self;
    [self.view addSubview:_contentView];
    //创建内容视图的提示视图
    _contextPromptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, _contentView.bounds.size.width, 20)];
    _contextPromptLabel.text = @"  请输入内容";
    _contextPromptLabel.textColor = [UIColor lightGrayColor];
    [_contentView addSubview:_contextPromptLabel];
    
    //创建collectionView
    [self creatCollectionView];
}

- (void)deleteImageView:(NSIndexPath *)indexPath
{
    [_imagesAry removeObjectAtIndex:indexPath.row];
    [self layoutSubView];
}

//如果有图片则重新布局
- (void)layoutSubView
{
    if (_imagesAry.count != 0) {
        _collectionView.hidden = NO;
        _collectionView.frame = CGRectMake(0, _addImageB.bottom, kScreenWidth, 100);
        _contentView.top = _collectionView.bottom + 5;
        _contentView.height = kScreenHeight - _contentView.frame.origin.y - 64 - 5;
    }
    else
    {
        _collectionView.hidden = YES;
        _collectionView.frame = CGRectZero;
        [UIView animateWithDuration:.3 animations:^{
            _contentView.top = _addImageB.bottom;
            _contentView.height = kScreenHeight - _contentView.frame.origin.y - 64 - 5;
        }];
    }
    [_collectionView reloadData];
}


- (void)setNote:(NoteModel *)note
{
    if (_note != note) {
        _note = note;
        
        if (note.image) {
            NSArray *ary = [note.image componentsSeparatedByString:@","];
            _imagesAry = [NSMutableArray arrayWithArray:ary];
            [self layoutSubView];
        }
        
        _titleText.text = note.title;
        _contentView.text = note.context;
        if (_contentView.text.length > 0) {
            _contextPromptLabel.hidden = YES;
        }
    }
}

#pragma mark - 创建collectionView
- (void)creatCollectionView
{
    _imagesAry = [NSMutableArray array];
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
    imageV.event = EditImageView;
    __weak CreateViewController *weakSelf = self;
    imageV.block = ^{
        [weakSelf deleteImageView:indexPath];
    };
    imageV.watchBlock = ^{
        [weakSelf localImageShow:indexPath.row];
    };
    imageV.checkBlock = ^{
        [weakSelf tapAction];
    };
    
    [cell.contentView addSubview:imageV];
    
    
    return cell;
}





#pragma mark - 添加图片
//添加图片
- (IBAction)addImage:(UIButton *)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相册" otherButtonTitles:@"相机", nil];
    [sheet showInView:self.view];
}
//弹出视图代理方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"0");
        [self selectedPhoto];
    }
    else if (buttonIndex == 1)
    {
        NSLog(@"1");
        [self selectCamera];
    }
}

//选择相册
- (void)selectedPhoto
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
//选择相机
- (void)selectCamera
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
    if (!isCamera) {
        UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"摄像头不可用" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [view show];
        return;
    }
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}
//assets-library://asset/asset.JPG?id=CF92F4B6-5DF0-4127-86FA-90001449E9DC&ext=JPG
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //取得图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    NSData *data = UIImageJPEGRepresentation(image, 1);
    
    //取得图片名字
    NSString *regex = @"(?<=id=).+(?=&)";
    NSURL *url = info[UIImagePickerControllerReferenceURL];
    NSString *str = [url absoluteString];
    NSArray *ary = [str componentsMatchedByRegex:regex];
    NSString *name = [ary lastObject];
    name = [NSString stringWithFormat:@"%@.jpg",name];
    _imageName = name;
    [_imagesAry addObject:name];
    [_collectionView reloadData];
    [_collectionView setContentOffset:CGPointMake(kScreenWidth * _imagesAry.count, 0)   ];
    //创建文件路径
    _imagePath = [DataImageFilePath stringByAppendingPathComponent:name];
    NSFileManager *manager = [NSFileManager defaultManager];
    //将图片存入沙盒
    if (![manager fileExistsAtPath:_imagePath]) {
        [manager createFileAtPath:_imagePath contents:data attributes:nil];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"%@",info);
    _imageView.image = image;
    [self layoutSubView];
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
