//
//  VersionAdapter.m
//  SchoolApp
//
//  Created by Liu Lexi on 13-11-4.
//  Copyright (c) 2013年 Lexi & Bella. All rights reserved.

#import "VersionAdapter.h"
static CGFloat MoreHeightInHead = 20.0;

@implementation VersionAdapter

+ (void)initialize
{
    if ([UIApplication sharedApplication].statusBarHidden == YES
        || [[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        MoreHeightInHead = 0;
    }
    else {
        MoreHeightInHead = 20.0;
    }
}

+ (BOOL)aboveiOS7
{
    return [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0;
}

+ (void)setViewLayout:(UIViewController *)viewCon
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        viewCon.edgesForExtendedLayout = UIRectEdgeNone;
        viewCon.extendedLayoutIncludesOpaqueBars = YES;
    }
}

+ (CGFloat)getMoreVarHead
{
    return MoreHeightInHead;
}

@end
