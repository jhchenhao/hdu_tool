//
//  MySwitch.m
//  项目3
//
//  Created by mac on 15/9/28.
//  Copyright (c) 2015年 chenhao. All rights reserved.
//

#import "MySwitch.h"

@interface MySwitch()
{
    UILabel *_letfLabel;
    UILabel *_rightLabel;
}

@end

@implementation MySwitch

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.width = 200;
        self.height = 30;
       // self.backgroundColor = [UIColor orangeColor];
        self.clipsToBounds = YES;
        self.layer.borderWidth = 2;
        self.layer.borderColor = [UIColor blueColor].CGColor;
        self.layer.cornerRadius = 10;
        _color = [UIColor blueColor];
    }
    return self;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if (point.x > 75) {
        if ([self.delegate respondsToSelector:@selector(selectRight)]) {
            [self.delegate selectRight];
        }
        _rightLabel.textColor = [UIColor whiteColor];
        _rightLabel.backgroundColor = _color;
        _letfLabel.textColor = _color;
        _letfLabel.backgroundColor = [UIColor whiteColor];
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(selectLeft)]) {
            [self.delegate selectLeft];
        }
        _letfLabel.textColor = [UIColor whiteColor];
        _letfLabel.backgroundColor = _color;
        _rightLabel.textColor = _color;
        _rightLabel.backgroundColor = [UIColor whiteColor];
    }
    
}


//创建左右label
- (void)_creatLeftLabel
{
    _letfLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    //_letfLabel.layer.borderWidth = 2;
    //_letfLabel.layer.borderColor = [UIColor blueColor].CGColor;
    _letfLabel.text = _leftName;
    _letfLabel.backgroundColor = _color;
    _letfLabel.textAlignment = NSTextAlignmentCenter;
    _letfLabel.textColor = [UIColor whiteColor];
    [self addSubview:_letfLabel];
}

- (void)_creatRightLabel
{
    _rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 100, 30)];
    _rightLabel.text = _rightName;
    //_rightLabel.layer.borderWidth = 2;
    //_rightLabel.layer.borderColor = [UIColor blueColor].CGColor;
    _rightLabel.textAlignment = NSTextAlignmentCenter;
    _rightLabel.textColor = _color;
    [self addSubview:_rightLabel];
}

- (void)setLeftName:(NSString *)leftName
{
    if (_leftName != leftName) {
        _leftName = leftName;
        [self _creatLeftLabel];
    }
}


- (void)setRightName:(NSString *)rightName
{
    if (_rightName != rightName) {
        _rightName = rightName;
        [self _creatRightLabel];
    }
}

- (void)setColor:(UIColor *)color
{
    if (_color != color) {
        _color = color;
        _letfLabel.backgroundColor = _color;
        _rightLabel.textColor = _color;
        self.layer.borderColor = _color.CGColor;
    }
}
@end
