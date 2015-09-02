//
//  Vallage.h
//  PropertyManagement
//
//  Created by admin on 15/1/28.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Vallage : NSObject
/*
 “orgId”: 省/地市/区域编号
 “orgName”: 省/地市/区域名称
 “vallageId”: 小区ID
 “vallageName”: 小区名称
 "seat",  栋
 "unit",  单元
 "house"  房号
 */
@property(strong,nonatomic)NSString *orgId;
@property(strong,nonatomic)NSString *orgName;
@property(strong,nonatomic)NSString *vallageId;
@property(strong,nonatomic)NSString *vallageName;
@property(strong,nonatomic)NSString *seat;
@property(strong,nonatomic)NSString *unit;
@property(strong,nonatomic)NSString *house;


@end
