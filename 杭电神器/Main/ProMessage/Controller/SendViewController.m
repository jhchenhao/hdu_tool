//
//  SendViewController.m
//  杭电神器
//
//  Created by 吴玉铁 on 15/10/5.
//  Copyright © 2015年 铁哥. All rights reserved.
//

#import "SendViewController.h"

@interface SendViewController (){
    UITextView *_textView;
    UIImageView *_editorBar;
    UIImageView *_iconView;
    UILabel *_nameLabel;
    NSArray *_f4Icons;
    NSArray *_names;
    NSArray *_positions;
    NSString *_imageName;
    MBProgressHUD *_HUD;
}

@end

@implementation SendViewController
/*
 本页图片
 //lend_yes
 //lend_no
*/
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    [self _initData];
    [self _setNavItems];
    [self _createViews];
    
    
    
}

- (void)_initData{
    _f4Icons = @[@"ldh_icon.jpg",
                 @"gfc_icon.jpg",
                 @"lm_icon.jpg",
                 @"zxy_icon.jpg"];
    _names = @[@"伟大铁哥",@"ch大帅哥",@"刘德华",@"郭富城",@"黎明",@"张学友"];
    _positions = @[@"琅琊阁",@"杭电月牙湖",@"杭电图书馆",@"杭电问鼎广场",@"杭电12号楼319",@"火星"];
}

- (void)_setNavItems{
    //leftItem
    UIButton *leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
    leftItem.backgroundColor = [UIColor clearColor];
    [leftItem setImage:[UIImage imageNamed:@"lend_no"] forState:UIControlStateNormal];
    leftItem.frame = CGRectMake(0,0,35,35);
    [leftItem addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftItem];
    //rightItem
    UIButton *rightItem = [UIButton buttonWithType:UIButtonTypeCustom];
    rightItem.backgroundColor = [UIColor clearColor];
    [rightItem setImage:[UIImage imageNamed:@"lend_yes"] forState:UIControlStateNormal];
    rightItem.frame = CGRectMake(0,0,35,35);
    [rightItem addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightItem];
}

- (void)_createViews{
    //输入框
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 105)];
    [self.view addSubview:_textView];
    _textView.font = [UIFont systemFontOfSize:18.0];
    
    _textView.backgroundColor = [UIColor colorWithRed:0 green:0.8 blue:1.0 alpha:0.5];
    _textView.layer.cornerRadius = 20;
    
   //编辑工具栏
    _editorBar = [[UIImageView alloc] initWithFrame:CGRectMake(0,kScreenHeight, kScreenWidth, 40)];
    UIImage *image = [UIImage imageNamed:@"edit_bg"];
    image = [image stretchableImageWithLeftCapWidth:15 topCapHeight:0];
    _editorBar.image = image;
    _editorBar.userInteractionEnabled = YES;
    [self.view addSubview:_editorBar];
    NSArray *imgs = @[
                      @"edit_icon.png",
                      @"edit_name.png",
                      @"edit_position.png",
                      ];
    for (int i = 0; i < imgs.count; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth / 3) + 40 * i, 1, 38, 38)];
        [button setImage:[UIImage imageNamed:imgs[i]] forState:UIControlStateNormal];
        [_editorBar addSubview:button];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 100 + i;
        
    }
    //选择图片显示
    _iconView = [[UIImageView alloc]initWithFrame:CGRectMake(10, _textView.bottom + 10, 50, 50)];
    [self.view addSubview:_iconView];
    _iconView.image = [UIImage imageNamed:@"follower_icon"];
    _iconView.layer.cornerRadius = 25;
    _iconView.layer.masksToBounds = YES;
    _iconView.hidden = YES;
    //选择名字显示
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_iconView.right + 5, _textView.bottom + 10, kScreenWidth - 65 , 50)];
    [self.view addSubview:_nameLabel];
    _nameLabel.text = @"杭电校草--杭电月牙湖网友";
    _nameLabel.hidden = YES;
    _nameLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.06];
    _nameLabel.layer.cornerRadius = 20;
    _nameLabel.layer.masksToBounds = YES;
    
}

#pragma mark-左右两边动作
- (void)leftAction:(UIButton *)button{
    [_textView resignFirstResponder];
    [self.navigationController dismissViewControllerAnimated:YES  completion:nil];

}
//发送
- (void)rightAction:(UIButton *)button{
    [self showHUD:@"发送中"];
    //配置参数
    if (_imageName.length == 0) {
        _imageName = @"follower_icon.png";
    }
    if ([_imageName isEqualToString:@"local"]) {
        UIImage *image = _iconView.image;
        CGSize newSize = CGSizeMake(30, 30);
        UIGraphicsBeginImageContext(newSize);
        // new size
        [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
        // Get the new image from the context
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        // End the context
        UIGraphicsEndImageContext();
        NSData *data = UIImageJPEGRepresentation(newImage,1);
        //上传文件
        [BmobProFile uploadFileWithFilename:@"data.jpg" fileData:data block:^(BOOL isSuccessful, NSError *error, NSString *filename, NSString *url,BmobFile *bmobFile) {
            if (isSuccessful) {
           
                NSLog(@"%@",bmobFile.url);
                NSLog(@"%@",_textView.text);
                //往HduGarden表添加一条follower为小明黄，内容为78开心的数据
                BmobObject *hduGarden = [BmobObject objectWithClassName:@"HduGarden"];
                [hduGarden setObject:bmobFile.url forKey:@"followerThumbnail"];
                [hduGarden setObject:_nameLabel.text forKey:@"followerName"];
                [hduGarden setObject:_textView.text forKey:@"followerContent"];
                [hduGarden setObject:[NSNumber numberWithInteger:0] forKey:@"followerSupport"];
                [hduGarden saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    //进行操作
                    if (isSuccessful == YES) {
                        [self completeHUD:@"发送成功"];
                        _textView.text = nil;
                        [[NSNotificationCenter defaultCenter]postNotificationName:kGardenLoadData object:nil];
                        [self performSelector:@selector(leftAction:) withObject:nil afterDelay:1];
                        NSLog(@"发送成功");
                    }
                }];
            } else {
                if (error) {
                    NSLog(@"error %@",error);
                }
            }
        } progress:^(CGFloat progress) {
            //上传进度，此处可编写进度条逻辑
            // NSLog(@"progress %f",progress);
        }];
        
    }else{
        //缩略图
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSString *path       = [mainBundle bundlePath];
        path                 = [path stringByAppendingPathComponent:_imageName];
        //指定宽为200，等比例对1.jpg进行缩放
        [BmobProFile localThumbnailImageWithFilepath:path mode:ThumbnailImageScaleModeWidth width:30 height:30 resultBlock:^(BOOL isSuccessful, NSError *error, NSString *filepath) {
            //打印缩略图文件路
            NSData *data = [NSData dataWithContentsOfFile:filepath];
            //上传文件
            [BmobProFile uploadFileWithFilename:_imageName fileData:data block:^(BOOL isSuccessful, NSError *error, NSString *filename, NSString *url,BmobFile *bmobFile) {
                if (isSuccessful) {
                    //打印文件名
                    //                NSLog(@"filename %@",filename);
                    //                //打印url
                    //                NSLog(@"url %@",url);
                    //                NSLog(@"bmobFile:%@\n",bmobFile);
                    //NSLog(@"%@",bmobFile.url);
                    
                    //往HduGarden表添加一条follower为小明黄，内容为78开心的数据
                    BmobObject *hduGarden = [BmobObject objectWithClassName:@"HduGarden"];
                    [hduGarden setObject:bmobFile.url forKey:@"followerThumbnail"];
                    [hduGarden setObject:_nameLabel.text forKey:@"followerName"];
                    [hduGarden setObject:_textView.text forKey:@"followerContent"];
                    [hduGarden setObject:[NSNumber numberWithInteger:0] forKey:@"followerSupport"];
                    [hduGarden saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                        //进行操作
                        if (isSuccessful == YES) {
                            NSLog(@"发送成功");
                             [self completeHUD:@"发送成功"];
                            _textView.text = nil;
                            [[NSNotificationCenter defaultCenter]postNotificationName:kGardenLoadData object:nil];
                            [self performSelector:@selector(leftAction:) withObject:nil afterDelay:1];
                        }
                    }];
                } else {
                    if (error) {
                        NSLog(@"error %@",error);
                    }
                }
            } progress:^(CGFloat progress) {
                //上传进度，此处可编写进度条逻辑
                // NSLog(@"progress %f",progress);
            }];
        }];

    }
}

#pragma mark-编辑栏按钮动作
- (void)buttonAction:(UIButton *)button{
    if (button.tag == 100) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册",@"刘德华",@"郭富城",@"黎明",@"张学友", nil];
        actionSheet.delegate = self;
        actionSheet.tag = 500;
        [actionSheet showInView:self.view];
    }else if (button.tag == 101){
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"伟大铁哥",@"ch大帅哥",@"刘德华",@"郭富城",@"黎明",@"张学友", nil];
        actionSheet.delegate = self;
        actionSheet.tag = 501;
        [actionSheet showInView:self.view];
    }else if (button.tag == 102){
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"琅琊阁",@"杭电月牙湖",@"杭电图书馆",@"杭电问鼎广场",@"杭电12号楼319",@"火星", nil];
        actionSheet.delegate = self;
        actionSheet.tag = 502;
        [actionSheet showInView:self.view];
    }
    
}

#pragma mark-KeyBoardNotification
- (void)keyBoardWillShow:(NSNotification *)notification{
    //NSLog(@"%@",notification);
    NSValue *boundsValue = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect frame = [boundsValue CGRectValue];
    CGFloat height = frame.size.height;
    _editorBar.bottom = kScreenHeight - height- 64;
}

- (void)keyBoardWillHide:(NSNotification *)notification{
    _editorBar.bottom = kScreenHeight - 65;
}

#pragma mark-ActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 500) {
        UIImagePickerControllerSourceType sourceType;
        if (buttonIndex == 0) {
            sourceType = UIImagePickerControllerSourceTypeCamera;
            BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
            if (!isCamera) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"摄像头无法使用" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
        }else if(buttonIndex == 1){
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }else if(buttonIndex == 6){
            return;
        }else{
            _iconView.hidden = NO;
            _iconView.image = [UIImage imageNamed:_f4Icons[buttonIndex - 2]];
            _imageName = _f4Icons[buttonIndex - 2];
            return;
        }
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = sourceType;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
    }else if(actionSheet.tag == 501){
        if (buttonIndex == 6) {
            return;
        }
        _nameLabel.hidden = NO;
        NSString *string;
        if (_nameLabel.text.length > 7) {
            _nameLabel.text = nil;
            string = @"";
        }else{
            string = _nameLabel.text;
        }
        _nameLabel.text = [NSString stringWithFormat:@"%@-%@",_names[buttonIndex],string];
    }else if(actionSheet.tag == 502){
        if (buttonIndex == 6) {
            return;
        }
         NSString *string;
        if (_nameLabel.text.length > 7) {
            _nameLabel.text = nil;
            string = @"";
        }else {
            string = _nameLabel.text;
        }
        _nameLabel.hidden = NO;
        _nameLabel.text = [NSString stringWithFormat:@"%@-%@",string,_positions[buttonIndex]];
    }
    
}


#pragma mark -UIImagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    _iconView.image = image;
    _iconView.hidden = NO;
    //创建空文件来保存下载数据
    NSString *fileName = @"image.jpg";
    NSString *filePath = [NSHomeDirectory() stringByAppendingFormat:@"/杭电神器.app/%@", fileName];
    NSLog(@"%@", filePath);
    [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
    NSData *data = UIImageJPEGRepresentation(image,1);
    //(1)创建文件句柄
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
        //（2）把文件位置指针定位到末尾
        [fileHandle seekToEndOfFile];
        //（3）写入数据
        [fileHandle writeData:data];
        //(4)关闭文件
        [fileHandle closeFile];
    _imageName = @"local";

}

//压缩图片质量
- (UIImage *)reduceImage:(UIImage *)image percent:(float)percent
{
    NSData *imageData = UIImageJPEGRepresentation(image, percent);
    UIImage *newImage = [UIImage imageWithData:imageData];
    return newImage;
}
//压缩图片尺寸
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
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
- (void)completeHUD:(NSString *)title{
    _HUD.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"completed_icon"]];
    _HUD.mode = MBProgressHUDModeCustomView;
    _HUD.labelText = title;
    [_HUD hide:YES afterDelay:1.5];
}


@end
