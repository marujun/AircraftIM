//
//  NSManagedObject+Magic.h
//  HLMagic
//
//  Created by marujun on 14-1-14.
//  Copyright (c) 2014年 chen ying. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "ChatUser+Extend.h"
#import "Message+Extend.h"


@interface NSManagedObject (Magic)


+ (void)cleanTable;
+ (NSArray *)getAllObjets;

//通过对象的 URIRepresentation 查找对象
+ (id)objectWithRepresent:(NSData *)represent;

@end
