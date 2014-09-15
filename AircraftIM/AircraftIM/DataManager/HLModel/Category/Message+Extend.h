//
//  Message+Extend.h
//  MCFriends
//
//  Created by zeke on 3/20/14.
//  Copyright (c) 2014 marujun. All rights reserved.
//

#import "Message.h"


@interface Message (Extend)

//通过key获取消息
+ (Message *)messageWithKey:(NSString *)key;

//通过文件名查找消息
+ (NSArray *)messageWithMediaName:(NSString *)name;

@end
