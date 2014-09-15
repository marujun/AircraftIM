//
//  ChatUser+Extend.h
//  MCFriends
//
//  Created by marujun on 14-6-4.
//  Copyright (c) 2014年 marujun. All rights reserved.
//

#import "ChatUser.h"

typedef enum
{
    MessageType_Text = 0 ,
    MessageType_Image = 1 ,
    MessageType_Audio = 2 ,
    MessageType_Video = 3
} MessageType;

@interface ChatUser (Extend)

- (Message *)lastMessage;

- (NSUInteger)messageCount;

- (BOOL)shouldShowTime:(Message *)message;


@end
