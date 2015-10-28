//
//  BZGuangGaoUrl.h
//  PropertyManagement
//
//  Created by mac on 15/10/25.
//  Copyright © 2015年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BZGuangGaoUrl : NSObject

@property(nonatomic,strong)NSURL *GGurl;

+ (id)sharedInstance;

@end
