//
//  main.m
//  杭电神器
//
//  Created by 吴玉铁 on 15/9/13.
//  Copyright (c) 2015年 铁哥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <BmobSDK/Bmob.h>


int main(int argc, char * argv[]) {
    @autoreleasepool {
        NSString *appKey = @"e141522742be4a0cd8480df2cfb45882";
        [Bmob registerWithAppKey:appKey];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
