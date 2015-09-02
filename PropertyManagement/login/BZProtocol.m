//
//  BZProtocol.m
//  PropertyManagement
//
//  Created by mac on 15/7/29.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "BZProtocol.h"

@implementation BZProtocol

/**
 *   GCD实现单例
 *
 *   @return 一个值不变的变量
 */
+ (BZProtocol *)sharedManager
{
    static BZProtocol *protocol1 = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        protocol1 = [[self alloc] init];
    });
    return protocol1;
}


@end
