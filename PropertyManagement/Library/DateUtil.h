//
//  Dateutil.h
//  CNHbccGGS
//
//  Created by Liu Lexi on 14-3-5.
//  Copyright (c) 2014年 Lexi & Bella. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtil : NSObject

+ (NSString *)strFromDate:(NSDate *)date;

+ (NSString *)dateStrInDynamicMessage:(NSDate *)date;

+ (NSString *)dateStrInHomeworkAna:(NSDate *)date;

+ (NSDate *)datePickFormatString:(NSString *)dateStr;

+ (NSString *)strFormDateWithMess:(NSDate *)date;

@end
