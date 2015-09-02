//
//  Barter.h
//  PropertyManagement
//
//  Created by iosMac on 15-1-10.
//  Copyright (c) 2015年 iosMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Barter : NSObject

/*
 物品交换信息
 barterInfoId:        “帖子ID”
 barterInfoTitle:	  “帖子标题”
 barterInfoContent:	  “帖子详情”
 repaeaseDate:       “发帖时间”
 repaeaseName:	  “发帖人姓名”
 repaeaseTel:		  “发帖人电话”
 
 photos：            “照片”
 status：“帖子状态[1-审核通过 2-交易完成”
 isOpen： 信息发布者是否原因公开自己的手机号0-否  1-是
 registrationId : 评论时推送给对方的注册id
 deviceType: 帖子对应发布人最后一次登录使用设备类型 0-android   1-ios
 barterCommentContent： 自己的评论信息
 isAgree： 信息发布者是否同意和你的交易  0-不同意  1-同意
*/

@property(strong,nonatomic)NSString *barterInfoId;
@property(strong,nonatomic)NSString *barterInfoTitle;
@property(strong,nonatomic)NSString *barterInfoContent;
@property(strong,nonatomic)NSString *repaeaseDate;
@property(strong,nonatomic)NSString *repaeaseName;
@property(strong,nonatomic)NSString *repaeaseTel;
@property(strong,nonatomic)NSString *status;
@property(strong,nonatomic)NSString *isOpen;
@property(strong,nonatomic)NSString *registrationId;
@property(strong,nonatomic)NSString *deviceType;
@property(strong,nonatomic)NSString *barterCommentContent;
@property(strong,nonatomic)NSString *isAgree;
@property(nonatomic,strong)NSArray *photos;


@end
