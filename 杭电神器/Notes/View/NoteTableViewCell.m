//
//  NoteTableViewCell.m
//  项目3
//
//  Created by mac on 15/10/4.
//  Copyright (c) 2015年 chenhao. All rights reserved.
//

#import "NoteTableViewCell.h"
#import "NSString+CalculateHeight.h"

@interface NoteTableViewCell ()
{
    UILabel *_titleLbael;
    UILabel *_contentLabel;
    UILabel *_timeLabel;
    UIImageView *_imageView;
}

@end

@implementation NoteTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//绘制单元格最下方线条
- (void)drawRect:(CGRect)rect
{
    NSLog(@"%@",NSStringFromCGRect(rect));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, rect.size.height - 1);
    CGPathAddLineToPoint(path, NULL, rect.size.width, self.contentView.frame.size.height - 1);
    CGPathCloseSubpath(path);
    CGContextSetLineWidth(context, .1);
    [[UIColor lightGrayColor] set];
    CGContextAddPath(context, path);
    CGContextDrawPath(context, kCGPathStroke);
    CGPathRelease(path);
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _creatSubView];
        //self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

//创建子视图
- (void)_creatSubView
{
    //标题
    _titleLbael = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_titleLbael];
    _titleLbael.font = [UIFont boldSystemFontOfSize:20];
    _titleLbael.textColor = [UIColor greenColor];
    _titleLbael.numberOfLines = 0;
    // 时间
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_timeLabel];
    _timeLabel.font = [UIFont systemFontOfSize:10];
    // 内容
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_contentLabel];
    _contentLabel.font = [UIFont systemFontOfSize:15];
    _contentLabel.numberOfLines = 0;
    // 图片
    _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_imageView];
    _imageView.hidden = YES;
    
    
//    _titleLbael.backgroundColor = [UIColor redColor];
//    _timeLabel.backgroundColor = [UIColor yellowColor];
//    _contentLabel.backgroundColor = [UIColor grayColor];
}

- (void)subViewLayout
{
    CGFloat width;
    if (_note.image)
    {
        _imageView.frame = CGRectMake(kScreenWidth - 135, 5, 130, 90);
        _imageView.hidden = NO;
        NSArray *ary = [_note.image componentsSeparatedByString:@","];
        NSString *name = [ary lastObject];
        NSString *file = [DataImageFilePath stringByAppendingPathComponent:name];
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:file];
        _imageView.image = image;
        width = _imageView.left - 10;
    }
    else
    {
        width = kScreenWidth - 10;
        _imageView.hidden = YES;
    }
    //标题
    CGFloat titleHeight = [_note.title getHeightofFont:[UIFont boldSystemFontOfSize:20] width:width];
    _titleLbael.frame = CGRectMake(5, 5, width, titleHeight);
    _titleLbael.text = _note.title;
    
    //时间
    CGFloat timeHeight = [_note.time getHeightofFont:[UIFont systemFontOfSize:10] width:width];
    _timeLabel.frame = CGRectMake( 5, _titleLbael.bottom, width, timeHeight);
    NSString *time = [_note.time substringWithRange:NSMakeRange(0, 5)];
    _timeLabel.text = [NSString stringWithFormat:@"%@ %@",_note.timeTitle,time];
    //内容
    CGFloat contextHeight = [_note.context getHeightofFont:[UIFont systemFontOfSize:15] width:width];
    _contentLabel.frame = CGRectMake(5, _timeLabel.bottom + 5, width, contextHeight);
    _contentLabel.text = _note.context;
    
    if (_contentLabel.bottom > 100) {
        _contentLabel.height = 100 - 5 - _contentLabel.top;
    }
}

- (void)setNote:(NoteModel *)note
{
    if (_note != note) {
        _note = note;
        [self subViewLayout];
    }
}


@end
