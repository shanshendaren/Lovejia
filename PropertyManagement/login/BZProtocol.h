//
//  BZProtocol.h
//  PropertyManagement
//
//  Created by mac on 15/7/29.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BZProtocol : NSObject
@property(nonatomic,strong)NSString *protocol2;

+ (BZProtocol *)sharedManager;

@end
