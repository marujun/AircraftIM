//
//  NSDate+Common.m
//  HLMagic
//
//  Created by marujun on 14-1-26.
//  Copyright (c) 2014年 chen ying. All rights reserved.
//

#import "NSDate+Common.h"

@implementation NSDate (Common)

//获取天数索引
- (int)dayIndexSince1970
{
    NSTimeInterval interval = [[self changeZone] timeIntervalSince1970];
    return (interval / (24 * 60 * 60));
}

- (int)dayIndexSinceNow
{
    return [self dayIndexSinceDate:[NSDate date]];
}
- (int)dayIndexSinceDate:(NSDate *)date
{
    int days = 0;
    @try {
        NSDate *baseBegin = [date dateAccurateToDay];
        NSDate *lastBegin = [self dateAccurateToDay];
        days = [[NSString stringWithFormat:@"%.0f",[lastBegin timeIntervalSinceDate:baseBegin]/(24*60*60)] intValue];
    }
    @catch (NSException *exception) {
        NSLog(@"%s [Line %d] exception:\n%@",__PRETTY_FUNCTION__, __LINE__,exception);
    }
    return days;
}

//返回星期的字符串
- (NSString *)weekDayString
{
    NSArray *weekDayChinese = @[@"", @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六"];
    NSInteger weekDay = [[self allDateComponent] weekday];
    @try {
        return weekDayChinese[weekDay];
    }
    @catch (NSException *exception) {
        return @"";
    }
}

//返回月份的字符串
- (NSString *)monthString
{
    NSArray *monthChinese = @[@"", @"一月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月", @"九月", @"十月", @"十一月", @"十二月"];
    NSInteger month = [[self allDateComponent] month];
    @try {
        return monthChinese[month];
    }
    @catch (NSException *exception) {
        return @"";
    }
}

//生成timestamp
- (NSString *)timestamp
{
    return [NSString stringWithFormat:@"%.0f",[self timeIntervalSince1970]*1000.f];
}

//获取字符串
- (NSString *)string
{
    return [self stringWithDateFormat:@"yyyy-MM-dd HH:mm:ss"];
}
- (NSString *)stringWithDateFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:self];
}


//格式化日期 精确到天
- (NSDate *)dateAccurateToDay
{
    NSDate *current = nil;
    @try {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self];
        current = [calendar dateFromComponents:components];
    }
    @catch (NSException *exception) {
        NSLog(@"%s [Line %d] exception:\n%@",__PRETTY_FUNCTION__, __LINE__,exception);
    }
    return current;
}

//格式化日期 精确到小时
- (NSDate *)dateAccurateToHour
{
    NSDate *current = nil;
    @try {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit) fromDate:self];
        current = [calendar dateFromComponents:components];
    }
    @catch (NSException *exception) {
        NSLog(@"%s [Line %d] exception:\n%@",__PRETTY_FUNCTION__, __LINE__,exception);
    }
    return current;
}

//计算年龄
- (NSInteger)age
{
    if (!self) {
        return 0;
    }
    // 出生日期转换 年月日
    NSDateComponents *components1 = [self allDateComponent];
    NSInteger brithDateYear  = [components1 year];
    NSInteger brithDateDay   = [components1 day];
    NSInteger brithDateMonth = [components1 month];
    
    // 获取系统当前 年月日
    NSDateComponents *components2 = [[NSDate date] allDateComponent];
    NSInteger currentDateYear  = [components2 year];
    NSInteger currentDateDay   = [components2 day];
    NSInteger currentDateMonth = [components2 month];
    
    // 计算年龄
    NSInteger iAge = currentDateYear - brithDateYear - 1;
    if ((currentDateMonth > brithDateMonth) || (currentDateMonth == brithDateMonth && currentDateDay >= brithDateDay)) {
        iAge++;
    }
    
    return iAge;
}

//判断2个日期是否在同一天
- (BOOL)isSameDayWithDate:(NSDate *)date
{
    BOOL isSame = NO;
    @try {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
        NSDateComponents *componentsA = [calendar components:unitFlags fromDate:date];
        NSDateComponents *componentsB = [calendar components:unitFlags fromDate:self];
        
        isSame = (componentsA.year == componentsB.year &&
                   componentsA.month == componentsB.month &&
                   componentsA.day == componentsB.day);
    }
    @catch (NSException *exception) {
        NSLog(@"%s [Line %d] exception:\n%@",__PRETTY_FUNCTION__, __LINE__,exception);
    }
    return isSame;
}
//判断日期是否为当天
- (BOOL)isToday
{
    return [self isSameDayWithDate:[NSDate date]];
}

//忽略年月日
- (NSDate *)dateRemoveYMD
{
    NSDate *lastDate = nil;
    @try {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:self];
        [components setYear:2014];
        lastDate = [calendar dateFromComponents:components];
    }
    @catch (NSException *exception) {
        NSLog(@"%s [Line %d] exception:\n%@",__PRETTY_FUNCTION__, __LINE__,exception);
    }
    return lastDate;
}

- (NSDateComponents *)allDateComponent
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour
                                                         | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday ) fromDate:self];
    return components;
}

//加上时区偏移
- (NSDate *)changeZone
{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:self];
    return [self  dateByAddingTimeInterval: interval];
}

@end

@implementation NSString (DateCommon)
- (NSDate *)date
{
    return [self dateWithDateFormat:@"yyyy-MM-dd HH:mm:ss"];
}
- (NSDate *)dateWithDateFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter dateFromString:self];
}
@end
