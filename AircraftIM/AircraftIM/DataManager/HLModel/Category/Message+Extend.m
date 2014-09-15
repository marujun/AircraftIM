//
//  Message+Extend.m
//  MCFriends
//
//  Created by zeke on 3/20/14.
//  Copyright (c) 2014 marujun. All rights reserved.
//

#import "Message+Extend.h"

@implementation Message (Extend)


+ (NSArray *)messageWithMediaName:(NSString *)name
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"media_name == %@", name];
    return [NSManagedObject getTable_sync:@"Message" predicate:pred];
}

+ (Message *)messageWithKey:(NSString *)key
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"key == %@", key];
    NSArray *recentUserArr = [NSManagedObject getTable_sync:@"Message" predicate:pred];
    if (recentUserArr && recentUserArr.count) {
        return [recentUserArr firstObject];
    }
    return nil;
}

@end
