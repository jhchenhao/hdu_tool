//
//  MyImageZoomView.h
//  项目3
//
//  Created by mac on 15/10/5.
//  Copyright (c) 2015年 chenhao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    NoneImageView = 0,
    WatchImageView,
    EditImageView
    
} ImageViewEvent;


typedef void(^deleteBlock)(void);
@interface MyImageZoomView : UIImageView

@property (nonatomic, assign) ImageViewEvent event;
@property (nonatomic, copy) deleteBlock block;
@property (nonatomic, copy) deleteBlock watchBlock;
@property (nonatomic, copy) deleteBlock checkBlock;
@end
