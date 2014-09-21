//
//  NSObject+Common.m
//  MCFriends
//
//  Created by marujun on 14-7-7.
//  Copyright (c) 2014年 marujun. All rights reserved.
//

#import "NSObject+Common.h"

@implementation NSObject (Common)

- (NSString *)stringValue
{
    NSString *finalString = @"";
    NSString *_string = [NSString stringWithFormat:@"%@", self];
    if (_string && ![_string isEqual:[NSNull null]] && ![_string isEqualToString:@"null"] && ![_string isEqualToString:@"(null)"] && ![_string isEqualToString:@"<null>"]) {
        finalString = [NSString stringWithFormat:@"%@", _string];
    }
    return finalString;
}


//去掉 json 中的多余的 null
- (id)cleanNull
{
	NSError *error;
	if (self == (id)[NSNull null]) {
		return [[NSObject alloc] init];
	}
    
	id jsonObject;
	if ([self isKindOfClass:[NSData class]]) {
		jsonObject = [NSJSONSerialization JSONObjectWithData:(NSData *)self options:kNilOptions error:&error];
	}
    else {
		jsonObject = self;
	}
    
	if ([jsonObject isKindOfClass:[NSArray class]]) {
		NSMutableArray *array = [jsonObject mutableCopy];
		for (NSInteger i = array.count - 1; i >= 0; i--) {
			id a = array[i];
			if (a == (id)[NSNull null]) {
				[array removeObjectAtIndex:i];
			}
			else {
				array[i] = [a cleanNull];
			}
		}
		return array;
	}
	else if ([jsonObject isKindOfClass:[NSDictionary class]]) {
		NSMutableDictionary *dictionary = [jsonObject mutableCopy];
		for (NSString *key in[dictionary allKeys]) {
			id d = dictionary[key];
			if (d == (id)[NSNull null]) {
				dictionary[key] = @"";
			}
			else {
				dictionary[key] = [d cleanNull];
			}
		}
		return dictionary;
	}
	else {
		return jsonObject;
	}
}

@end
