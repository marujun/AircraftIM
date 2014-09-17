//
//  MessageManager.h
//  AircraftIM
//
//  Created by marujun on 14-9-15.
//  Copyright (c) 2014年 marujun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SoundPlayer.h"
#import "RecordAudio.h"

extern NSString *const kNewMessageNotification;

@interface MessageManager : NSObject <IChatManagerDelegate>

@property (nonatomic, strong) SoundPlayer *vibratePlayer;
@property (nonatomic, strong) SoundPlayer *soundPlayer;

@property (nonatomic, strong) ChatUser *currentChatUser;

+ (MessageManager *)defaultManager;

@end
