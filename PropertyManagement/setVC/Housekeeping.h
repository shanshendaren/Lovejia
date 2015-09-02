//
//  Housekeeping.h
//  PropertyManagement
//
//  Created by admin on 15/3/17.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Housekeeping : NSObject
/*
 hsId:        “ID”
 hsName:	  “标题”
 typeName:	  “服务类型”
 hsDetail:       “内容”
 hsTime:	  		发布的时间
 acceptTime:		  受理时间
 acceptStatus:			受理状态  0 -未处理  1-已处理
 acceptRemark:			受理结果备注
 acceptCompany:			受理服务公司
 acceptBusinner:			受理业务员姓名
 acceptBusinnerMobile:   受理业务员联系电话
 feedback：				用户评价内容
 feedbackDate：			用户评价时间
 feedbackStatus：		用户评价（1差，2 中 3好)
 */
@property(strong,nonatomic)NSString *hsId;
@property(strong,nonatomic)NSString *hsName;
@property(strong,nonatomic)NSString *typeName;
@property(strong,nonatomic)NSString *hsDetail;
@property(strong,nonatomic)NSString *hsTime;
@property(strong,nonatomic)NSString *acceptTime;
@property(strong,nonatomic)NSString *acceptStatus;
@property(strong,nonatomic)NSString *acceptRemark;
@property(strong,nonatomic)NSString *acceptCompany;
@property(strong,nonatomic)NSString *acceptBusinner;
@property(strong,nonatomic)NSString *acceptBusinnerMobile;
@property(strong,nonatomic)NSString *feedback;
@property(strong,nonatomic)NSString *feedbackDate;
@property(assign)int feedbackStatus;
@end
