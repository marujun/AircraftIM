//
//  MessageManager.m
//  AircraftIM
//
//  Created by marujun on 14-9-15.
//  Copyright (c) 2014年 marujun. All rights reserved.
//

#import "MessageManager.h"

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
    }
    return self;
}



@end
