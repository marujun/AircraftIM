//
//  NSManagedObject+Magic.m
//  HLMagic
//
//  Created by marujun on 14-1-14.
//  Copyright (c) 2014年 chen ying. All rights reserved.
//

#import "NSManagedObject+Magic.h"

extern NSManagedObjectContext *globalManagedObjectContext_util;
extern NSManagedObjectModel *globalManagedObjectModel_util;

@implementation NSManagedObject (Magic)

+ (NSArray *)getAllObjets
{
    NSString *tableName = NSStringFromClass([self class]);
    if ([tableName isEqualToString:@"NSManagedObject"]) {
        return @[];
    }
    NSArray *resultArr = [NSManagedObject getTable_sync:tableName predicate:nil];
    return (resultArr && resultArr.count != 0)?resultArr:nil;
}

+ (void)cleanTable
{
    NSString *tableName = NSStringFromClass([self class]);
    if ([tableName isEqualToString:@"NSManagedObject"]) {
        return;
    }
    NSArray *array = [self getTable_sync:NSStringFromClass([self class]) predicate:nil];
    [self deleteObjects_sync:array];
}



//通过对象的 URIRepresentation 查找对象
+ (id)objectWithRepresent:(NSData *)represent
{
    __block NSManagedObject *resultObejct = nil;
    
    [self asyncQueue:false actions:^{
        /*  NSData *represent = [NSKeyedArchiver archivedDataWithRootObject:message.objectID.URIRepresentation]; */
        NSURL *url = [NSKeyedUnarchiver unarchiveObjectWithData:represent];
        if (url != nil)
        {
            NSManagedObjectID *objectID = [globalManagedObjectContext_util.persistentStoreCoordinator managedObjectIDForURIRepresentation:url];

            if (objectID) {
                NSError *objWithIdError = nil;
                resultObejct = [globalManagedObjectContext_util existingObjectWithID:objectID error:&objWithIdError];
                if (objWithIdError != nil)
                {
                    FLOG(@"existing object error: %@", objWithIdError);
                    resultObejct = nil;
                }
            }
        }
    }];
    return resultObejct;
}


@end
