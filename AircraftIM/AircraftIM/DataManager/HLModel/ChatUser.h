//
//  ChatUser.h
//  AircraftIM
//
//  Created by marujun on 14-9-15.
//  Copyright (c) 2014年 marujun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "PersonBase.h"

@class Message;

@interface ChatUser : PersonBase

@property (nonatomic, retain) NSString * draft;
@property (nonatomic, retain) NSString * tid;
@property (nonatomic, retain) NSNumber * unReadCount;
@property (nonatomic, retain) NSNumber * unReceiveScore;
@property (nonatomic, retain) NSNumber * unSendCount;
@property (nonatomic, retain) Message *lastMsg;
@property (nonatomic, retain) NSOrderedSet *messages;
@end

@interface ChatUser (CoreDataGeneratedAccessors)

- (void)insertObject:(Message *)value inMessagesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromMessagesAtIndex:(NSUInteger)idx;
- (void)insertMessages:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeMessagesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInMessagesAtIndex:(NSUInteger)idx withObject:(Message *)value;
- (void)replaceMessagesAtIndexes:(NSIndexSet *)indexes withMessages:(NSArray *)values;
- (void)addMessagesObject:(Message *)value;
- (void)removeMessagesObject:(Message *)value;
- (void)addMessages:(NSOrderedSet *)values;
- (void)removeMessages:(NSOrderedSet *)values;
@end
