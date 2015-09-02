//
//  Discuss.h
//  PropertyManagement
//
//  Created by admin on 15/3/9.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Discuss : NSObject
/*
 
 //物品交换
 barterCommentInfoId:        “评论信息ID”
 barterInfoId:	  “帖子ID”
 barterCommentContent:	  “评论内容”
 criticsDate:       “评论时间”
 isAgree:	  “帖子发布人是否同意交易 0-不同意  1-同意”
 ownerName:	   “评论人姓名”
 ownerTel：		“评论人联系电话
 registrationId：“评论人登录手机注册ID（极光推送API生成）”
 deviceType：	“评论人登录最后一次登录使用设备类型 0-android   1-ios”
 vallageName：
 
 
 
 //拼车
 commentInfoId:        “评论信息ID”
 neighborhordCarpoolCommentInfoId:	  “帖子ID”
 commentContent:	  “评论内容”
 criticsDate:       “评论时间”
 isAgree:	  “帖子发布人是否同意交易 0-不同意  1-同意”
 ownerName:	   “评论人姓名”
 ownerTel：		“评论人联系电话
 registrationId：“评论人登录手机注册ID（极光推送API生成）”
 deviceType：	“评论人登录最后一次登录使用设备类型 0-android   1-ios”
 vallageName： 评论人小区名称
 */
@property(strong,nonatomic)NSString * barterCommentInfoId;
@property(strong,nonatomic)NSString * barterInfoId;
@property(strong,nonatomic)NSString * barterCommentContent;
@property(strong,nonatomic)NSString * criticsDate;
@property(strong,nonatomic)NSString * isAgree;
@property(strong,nonatomic)NSString * ownerName;
@property(strong,nonatomic)NSString * ownerTel;
@property(strong,nonatomic)NSString * registrationId;
@property(strong,nonatomic)NSString * deviceType;
@property(strong,nonatomic)NSString * vallageName;



@end
