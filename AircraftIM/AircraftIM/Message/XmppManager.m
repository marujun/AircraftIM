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
        // 监测网络情况
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChanged:)
                                                     name: kReachabilityChangedNotification
                                                   object: nil];
    }
    return self;
}

//网络状态发生变化
- (void)reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus networkStatus = [curReach currentReachabilityStatus];
    
    if (networkStatus == NotReachable) {
//        [self disconnect];
//    }else if (MyInfo) {
//        [self connect];
    }
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

@end
