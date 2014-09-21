//
//  MessageTimeTableCell.m
//  AircraftIM
//
//  Created by 马汝军 on 14-9-21.
//  Copyright (c) 2014年 marujun. All rights reserved.
//

#import "MessageTimeTableCell.h"

@implementation MessageTimeTableCell

- (void)updateDisplay
{
    //测试用
    self.textLabel.text = (NSString *)self.dataInfo;
}

+ (NSString *)stringWithDate:(NSDate *)date
{
    NSString *dateStr = @"";
    if ([date dayIndexSinceNow] < 0) {
        //超过两天
        switch ([date dayIndexSinceNow]) {
            case -1:
                dateStr = [date stringWithDateFormat:@"昨天 HH:mm"];
                break;
            case -2:
                dateStr = [date stringWithDateFormat:@"前天 HH:mm"];
                break;
            default:
                if ([[date allDateComponent] year] != [[[NSDate date] allDateComponent] year]) {
                    dateStr = [date stringWithDateFormat:@"yyyy年MM月dd日 HH:mm"];
                }else{
                    dateStr = [date stringWithDateFormat:@"MM月dd日 HH:mm"];
                }
                break;
        }
    } else {
        dateStr = [dateStr stringByAppendingString:[date stringWithDateFormat:@"HH:mm"]];
    }
    return dateStr;
}

@end
