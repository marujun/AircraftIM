//
//  ChatUser+Extend.m
//  MCFriends
//
//  Created by marujun on 14-6-4.
//  Copyright (c) 2014年 marujun. All rights reserved.
//

#import "ChatUser+Extend.h"

@implementation ChatUser (Extend)


- (BOOL)shouldShowTime:(Message *)message
{
    if (self.messageCount == 0) {
        //第一条消息 或者 送花，必须显示打点时间
        return YES;
    } else {
        //每隔2分钟并且此时间段内没有消息，记录一次时间
        if ([self.lastMsg.date timeIntervalSinceNow] < - 2 * 60) {
            return YES;
        } else {
            return NO;
        }
    }
    return NO;
}

- (Message *)lastMessage
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(uid_from == %@ AND uid_to == %@) OR (uid_from == %@ AND uid_to == %@)",
                         self.uid, self.tid, self.tid, self.uid];
    NSArray *resultArray = [NSManagedObject getTable_sync:NSStringFromClass([Message class]) actions:^(NSFetchRequest *request) {
        [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]]];
        [request setFetchLimit:1];
        [request setPredicate:pred];
    }];
    if (resultArray && resultArray.count) {
        return (Message *)resultArray[0];
    }
    return nil;
}

- (NSUInteger)messageCount
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(uid_from == %@ AND uid_to == %@) OR (uid_from == %@ AND uid_to == %@)",
                         self.uid, self.tid, self.tid, self.uid];
    return [NSManagedObject countTable_sync:NSStringFromClass([Message class]) predicate:pred];
}



@end
