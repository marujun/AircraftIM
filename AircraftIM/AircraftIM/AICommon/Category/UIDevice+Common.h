//
//  UIDevice(Common).h
//  UIDeviceAddition
//
//  Created by Georg Kitz on 20.08.11.
//  Copyright 2011 Aurora Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIDevice (Common)


//是否越狱
+ (BOOL)jailbroken;

+ (NSString *)BIData;
+ (NSString *)chinaMobileModel;
+ (NSString *)IPv4;
+ (NSString *)IPv6;
+ (NSString *)deviceName;
+ (NSString *)deviceModel;


//是否已插入耳机
+ (BOOL)headphonesConnected;

//是否开启了Airplay
+ (BOOL)isAirplayActived;

//是否已开启麦克风权限
+ (void)recordPermission:(void (^)(BOOL granted))response;

@end
