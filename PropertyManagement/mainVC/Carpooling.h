//
//  Carpooling.h
//  PropertyManagement
//
//  Created by admin on 15/3/10.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Carpooling : NSObject
/*
 neighborhordCarpoolInfoId:        “帖子ID”
 neighborhordCarpoolInfoTitle:	  “帖子标题”
 neighborhordCarpoolInfoContent:	  “帖子详情”
 repaeaseDate:       “发帖时间”
 repaeaseName:	  “发帖人姓名”
 repaeaseTel:		  “发帖人电话”
 Photos:[
 {
 path:	       “图片路径1（大）”，
 paths: 	   “图片路径1（小），用于列表显示”
 },
 
 status：			帖子状态[1-审核通过 2-交易完成”]
 registrationId：“帖子对应发布人注册ID（极光推送API生成）”
 deviceType：“帖子对应发布人最后一次登录使用设备类型 0-android   1-ios”
 isOpen：信息发布者是否原因公开自己的手机号0-否  1-是
 startPlace： 出发地
 endPlace： 目的地
 line：线路描述
 type：拼车类型（1-有车 2-拼车/无车）
 
 commentContent： 自己的评论信息
 isAgree： 信息发布者是否同意和你的交易  0-不同意  1-同意
 */

@property(strong,nonatomic)NSString *neighborhordCarpoolInfoId;
@property(strong,nonatomic)NSString *neighborhordCarpoolInfoTitle;
@property(strong,nonatomic)NSString *neighborhordCarpoolInfoContent;
@property(strong,nonatomic)NSString *repaeaseDate;
@property(strong,nonatomic)NSString *repaeaseName;
@property(strong,nonatomic)NSString *repaeaseTel;
@property(strong,nonatomic)NSString *status;
@property(strong,nonatomic)NSString *registrationId;
@property(strong,nonatomic)NSString *deviceType;
@property(strong,nonatomic)NSString *isOpen;
@property(strong,nonatomic)NSString *startPlace;
@property(strong,nonatomic)NSString *endPlace;
@property(strong,nonatomic)NSString *line;
@property(strong,nonatomic)NSString *type;
@property(strong,nonatomic)NSString *commentContent;
@property(strong,nonatomic)NSString *isAgree;
@property(nonatomic,strong)NSArray *photos;


@end
