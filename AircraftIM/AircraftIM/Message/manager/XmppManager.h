//
//  XmppManager.h
//  AircraftIM
//
//  Created by marujun on 14-9-17.
//  Copyright (c) 2014年 marujun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageManager.h"

extern NSString *const kXmppConnectChangedNotification;

typedef enum{
    XmppNotConnect = 0,
    XmppConnecting,
    XmppConnected
} XmppConnetStatus;

@interface XmppManager : NSObject

/*!
 @property
 @brief 和服务器之间的连接状态
 */
@property (nonatomic, readonly, assign) XmppConnetStatus connetStatus;

+ (XmppManager *)defaultManager;

+ (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
               completion:(void (^)(NSDictionary *loginInfo, EMError *error))completion;
+ (void)logoffWithCompletion:(void (^)(NSDictionary *info, EMError *error))completion;

@end
