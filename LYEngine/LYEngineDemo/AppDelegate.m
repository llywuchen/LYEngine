//
//  AppDelegate.m
//  LYEngineDemo
//
//  Created by lly on 2017/3/27.
//  Copyright © 2017年 franklin. All rights reserved.
//

#import "AppDelegate.h"
#import "MainModule.h"
#import "MineModule.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [LYModule sharedInstance].APIHost = @"http://www.hoolyshine.com/llywuchen";
    LYWebClientInstance.endPoint = [NSURL URLWithString:@"http://www.hoolyshine.com/llywuchen"];
    [MainModule install];
    [MineModule install];
    
    NSLog(@"%p--%p",[MainModule sharedInstance],[MineModule sharedInstance]);
    
    UIViewController *v = [MainModule objectForURL:MainVC];
    self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:v];
    [self.window makeKeyWindow];
    [self.window makeKeyAndVisible];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3ull*NSEC_PER_SEC),dispatch_get_global_queue(0, 0), ^{
//        [MainModule unInstall];
//        [MineModule unInstall];
    });
    
    
//    [MainModule unInstall];
//    [MineModule unInstall];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
