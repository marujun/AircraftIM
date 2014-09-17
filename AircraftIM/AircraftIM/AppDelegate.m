//
//  AppDelegate.m
//  AircraftIM
//
//  Created by marujun on 14-9-15.
//  Copyright (c) 2014年 marujun. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //初始化模型
    [CoreDataUtil launch];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _rootViewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
    self.window.rootViewController = _rootViewController;
    
    [[EaseMob sharedInstance] registerSDKWithAppKey:@"witmob#nightforappios" apnsCertName:nil];
	[[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
	[self.window makeKeyAndVisible];
    
    return YES;
}
							
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken
{
    [[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [[EaseMob sharedInstance] applicationWillResignActive:application];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[EaseMob sharedInstance] applicationDidBecomeActive:application];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[EaseMob sharedInstance] applicationWillTerminate:application];
}

@end
