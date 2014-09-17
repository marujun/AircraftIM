//
//  MessageManager.m
//  AircraftIM
//
//  Created by marujun on 14-9-15.
//  Copyright (c) 2014年 marujun. All rights reserved.
//

#import "MessageManager.h"

NSString *const kNewMessageNotification = @"kNewMessageNotification";

@implementation MessageManager

+ (MessageManager *)defaultManager
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
        _vibratePlayer = [SoundPlayer initVibratePlayer];
        _soundPlayer = [SoundPlayer initSystemPlayerWithFileName:@"sms-received1.caf"];
        
        // 注册一个delegate
        [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    }
    return self;
}


// 实现接收消息的委托
#pragma mark - IChatManagerDelegate
-(void)didReceiveMessage:(EMMessage *)message
{
    FLOG(@"message %@",message);
}

@end
