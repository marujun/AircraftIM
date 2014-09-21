//
//  XmppManager.m
//  AircraftIM
//
//  Created by marujun on 14-9-17.
//  Copyright (c) 2014年 marujun. All rights reserved.
//

#import "XmppManager.h"

NSString *const kXmppConnectChangedNotification = @"kXmppConnectChangedNotification";

@implementation XmppManager

+ (XmppManager *)defaultManager
{
    static dispatch_once_t pred = 0;
    __strong static id defaultMessageManager = nil;
    dispatch_once( &pred, ^{
        defaultMessageManager = [[self alloc] init];
    });
    return defaultMessageManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        [MessageManager defaultManager];
    }
    return self;
}

- (void)setConnetStatus:(XmppConnetStatus)connetStatus
{
    _connetStatus = connetStatus;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kXmppConnectChangedNotification
                                                            object:self];
    });
}

+ (void)loginWithUsername:(NSString *)username password:(NSString *)password
{
    [[XmppManager defaultManager] setConnetStatus:XmppConnecting];
    
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:username
                                                        password:password
                                                      completion:
     ^(NSDictionary *loginInfo, EMError *error) {
         if (loginInfo && !error) {
             FLOG(@"登录成功");
             [[XmppManager defaultManager] setConnetStatus:XmppConnected];
         }else {
             [[XmppManager defaultManager] setConnetStatus:XmppNotConnect];
             FLOG(@"登录失败 %@",error.description);
         }
     } onQueue:nil];
}

+ (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
               completion:(void (^)(NSDictionary *loginInfo, EMError *error))completion
{
    [[XmppManager defaultManager] setConnetStatus:XmppConnecting];
    
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:username
                                                        password:password
                                                      completion:
     ^(NSDictionary *loginInfo, EMError *error) {
         if (loginInfo && !error) {
             FLOG(@"登录成功");
             [[XmppManager defaultManager] setConnetStatus:XmppConnected];
         }else {
             [[XmppManager defaultManager] setConnetStatus:XmppNotConnect];
             FLOG(@"登录失败 %@",error.description);
         }
         completion?completion(loginInfo,error):nil;
     } onQueue:nil];
}

+ (void)logoffWithCompletion:(void (^)(NSDictionary *info, EMError *error))completion
{
    [[EaseMob sharedInstance].chatManager asyncLogoffWithCompletion:completion onQueue:nil];
}

#pragma mark - IChatManagerDelegate 登陆回调（主要用于监听自动登录是否成功）
- (void)didLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error
{
    if (error) {
        //你的账号登录失败，正在重试中...
    }
}

#pragma mark - IChatManagerDelegate 登录状态变化
- (void)didLoginFromOtherDevice
{
    //你的账号已在其他地方登录
    [[self class] logoffWithCompletion:nil];
}

- (void)didRemovedFromServer
{
    //你的账号已被从服务器端移除
    [[self class] logoffWithCompletion:nil];
}

- (void)didConnectionStateChanged:(EMConnectionState)connectionState
{
    if (connectionState == eEMConnectionConnected) {
        _connetStatus = XmppConnected;
    }else if (connectionState == eEMConnectionDisconnected){
        _connetStatus = XmppNotConnect;
    }
}

#pragma mark -
- (void)willAutoReconnect
{
    //正在重连中...
    _connetStatus = XmppConnecting;
}

- (void)didAutoReconnectFinishedWithError:(NSError *)error
{
    if (error) {
        //重连失败，稍候将继续重连
        _connetStatus = XmppNotConnect;
    }else{
        //重连成功！
        _connetStatus = XmppConnected;
    }
}

@end
