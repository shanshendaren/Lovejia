//
//  DatePickViewCon.h
//  CNHbccGGS
//
//  Created by Liu Lexi on 14-3-30.
//  Copyright (c) 2014年 Lexi & Bella. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _DatePickType{
    DatePickTypeNone = 0,
    DatePickTypeClassStart = 1,
    DatePickTypeClassEnd = 2,
    DatePickTypeGradeStart = 3,
    DatePickTypeGradeEnd = 4,
    DatePickTypeAreaStart = 5,
    DatePickTypeAreaEnd = 6,
} DatePickType;

@class DatePickViewCon;

@protocol DatePickDelegate <NSObject>

- (void)datePickDidSelected:(DatePickViewCon *)viewCon;

@end

@interface DatePickViewCon : UIViewController
{
    NSDate *curDate;
    DatePickType type;
    
    id<DatePickDelegate> delegate;
}

@property (retain) NSDate *curDate;
@property (assign) DatePickType type;
@property (assign) id<DatePickDelegate> delegate;

+ (id)ShareDatePickViewCon;

- (void)setShowDate:(NSDate *)showDate;
- (void)show;
- (void)dismiss;

@end
