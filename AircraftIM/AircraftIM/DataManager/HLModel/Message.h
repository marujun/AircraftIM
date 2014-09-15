//
//  Message.h
//  AircraftIM
//
//  Created by marujun on 14-9-15.
//  Copyright (c) 2014年 marujun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ChatUser;

@interface Message : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * extra;
@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSString * media_duration;
@property (nonatomic, retain) NSString * media_name;
@property (nonatomic, retain) NSString * media_size;
@property (nonatomic, retain) NSString * media_thumb;
@property (nonatomic, retain) NSNumber * showTime;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSString * uid_from;
@property (nonatomic, retain) NSString * uid_to;
@property (nonatomic, retain) ChatUser *target;

@end
