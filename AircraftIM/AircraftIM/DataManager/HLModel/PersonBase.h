//
//  PersonBase.h
//  AircraftIM
//
//  Created by marujun on 14-9-15.
//  Copyright (c) 2014年 marujun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PersonBase : NSManagedObject

@property (nonatomic, retain) NSString * avater;
@property (nonatomic, retain) NSString * extra;
@property (nonatomic, retain) NSNumber * gender;
@property (nonatomic, retain) NSString * nickName;
@property (nonatomic, retain) NSString * uid;

@end
