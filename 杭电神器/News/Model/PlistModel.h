//
//  PlistModel.h
//  项目3
//
//  Created by mac on 15/9/28.
//  Copyright (c) 2015年 chenhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlistModel : NSObject

- (id)initWithDic:(NSDictionary *)dic;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *href;
@property (nonatomic, strong) NSArray *imageAry;
@property (nonatomic, strong) NSArray *imageAry2;
@end
