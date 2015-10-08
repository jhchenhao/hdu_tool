//
//  AppDelegate.m
//  杭电神器
//
//  Created by 吴玉铁 on 15/9/13.
//  Copyright (c) 2015年 铁哥. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarViewController.h"
#import "MMDrawerController.h"
#import "LeftViewController.h"
#import "MMExampleDrawerVisualStateManager.h"



@interface AppDelegate ()

@property (nonatomic,strong) NSNumber *num;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    //构建左视图
    MainTabBarViewController *mainTabVC = [[MainTabBarViewController alloc]init];
    LeftViewController *leftVC = [[LeftViewController alloc]init];
    MMDrawerController *mmDrawerVC = [[MMDrawerController alloc]initWithCenterViewController:mainTabVC leftDrawerViewController:leftVC];
    [mmDrawerVC setMaximumLeftDrawerWidth:120];
    //设置手势区域
    [mmDrawerVC setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [mmDrawerVC setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    //设置动画类型
    [[MMExampleDrawerVisualStateManager sharedManager]setLeftDrawerAnimationType:MMDrawerAnimationTypeSwingingDoor];
    
    [mmDrawerVC setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
        MMDrawerControllerDrawerVisualStateBlock block = [[MMExampleDrawerVisualStateManager sharedManager]drawerVisualStateBlockForDrawerSide:drawerSide];
        if (block) {
            block(drawerController,drawerSide,percentVisible);
        }
    }];
    
    self.window.rootViewController = mmDrawerVC;
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
