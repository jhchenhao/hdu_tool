//
//  PlistModel.m
//  项目3
//
//  Created by mac on 15/9/28.
//  Copyright (c) 2015年 chenhao. All rights reserved.
//

#import "PlistModel.h"

@implementation PlistModel

- (id)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.time = dic[@"time"];
        self.title = dic[@"title"];
        self.href = dic[@"href"];
        
        self.imageAry = @[@"校2.jpg",
                          @"园2.jpg",
                          @"动2.jpg",
                          @"态2.jpg"];
        self.imageAry2 = @[@"杭2.jpg",
                          @"电2.jpg",
                          @"要2.jpg",
                          @"闻2.jpg"];
    }
    return self;
}


@end
