//  Created by chen ying on 12-11-6.
//  Copyright (c) 2012年 hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Common)

// 验证邮箱
-(BOOL)isValidateEmail;

// 验证身份证号码
- (BOOL)isValidateIDCard;

// 验证手机号码
- (BOOL)isValidateMobileNumber;

// 验证银行卡 (Luhn算法)
- (BOOL)isValidCardNumber;

//是否含有系统表情
- (BOOL)isContainEmoji;

- (float)stringWidthWithFont:(UIFont *)font height:(float)height;
- (float)stringHeightWithFont:(UIFont *)font width:(float)width;

- (float)heightForTextViewWithFont:(UIFont *)font width:(float)width;

//根据","分割字符串为数组
+ (NSMutableArray *)stringSegmentationByComma:(NSString *)string type:(NSString *)type;

@end
