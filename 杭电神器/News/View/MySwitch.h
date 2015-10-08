//
//  MySwitch.h
//  项目3
//
//  Created by mac on 15/9/28.
//  Copyright (c) 2015年 chenhao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MySwitchDelegate <NSObject>

//选择左边
- (void)selectLeft;
//选择右边
- (void)selectRight;

@end


@interface MySwitch : UIView

@property (nonatomic, copy) NSString *leftName;
@property (nonatomic, copy) NSString *rightName;
@property (nonatomic, strong) UIColor *color;

@property (nonatomic, assign) id<MySwitchDelegate> delegate;

@end
