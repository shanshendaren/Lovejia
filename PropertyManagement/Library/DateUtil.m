//
//  Dateutil.m
//  CNHbccGGS
//
//  Created by Liu Lexi on 14-3-5.
//  Copyright (c) 2014年 Lexi & Bella. All rights reserved.
//

#import "DateUtil.h"

@implementation DateUtil

+ (NSString *)strFromDate:(NSDate *)date
{
    NSTimeInterval birDiff = [date timeIntervalSinceNow];
    if (birDiff < 0) {
        birDiff = 0 - birDiff;
    }
    
    int minCount = birDiff / (60.0);
    if (minCount < 60) {
        return [NSString stringWithFormat:@"%d分钟前", minCount];
    }
    
    int hourCount = birDiff / (3600.0);
    if (hourCount < 24) {
        return [NSString stringWithFormat:@"%d小时前", hourCount];
    }
    
    int dayCount = birDiff / (3600.0 * 24.0);
    return [NSString stringWithFormat:@"%d天前", dayCount];
}

+ (NSString *)dateStrInDynamicMessage:(NSDate *)date
{
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"mm月dd日 hh:MM"];
    NSString *restStr = [formater stringFromDate:date];
    [formater release]; formater = nil;
    return restStr;
}

+ (NSString *)dateStrInHomeworkAna:(NSDate *)date
{
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-mm-dd"];
    NSString *restStr = [formater stringFromDate:date];
    [formater release]; formater = nil;
    return restStr;
}

+ (NSDate *)datePickFormatString:(NSString *)dateStr
{
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-mm-dd"];
    NSDate *date = [formater dateFromString:dateStr];
    [formater release];
    return date;
}

+ (NSString *)strFormDateWithMess:(NSDate *)date
{
    if ([DateUtil isToday:date]) {
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"hh:MM:ss"];
        NSString *retStr = [formater stringFromDate:[NSDate date]];
        [formater release]; formater = nil;
        return retStr;
    }
    else {
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"mm月dd日 hh:MM:ss"];
        NSString *retStr = [formater stringFromDate:[NSDate date]];
        [formater release]; formater = nil;
        return retStr;
    }
}

+ (BOOL)isToday:(NSDate *)date
{
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-mm-dd"];
    NSString *curStr = [formater stringFromDate:[NSDate date]];
    NSString *dateStr = [formater stringFromDate:date];
    [formater release]; formater = nil;
    return [curStr isEqualToString:dateStr];
}

@end
