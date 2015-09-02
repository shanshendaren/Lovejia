//
//  Complain.h
//  PropertyManagement
//
//  Created by admin on 14/11/21.
//  Copyright (c) 2014年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Complain : NSObject

//cpId		投诉信息id
//cpTitle		投诉标题
//cpMess		投诉内容
//cpAcceptRemark	物业反馈
//cpTime		投诉时间
//cpAcceptMess	物业处理方案
//cpAcceptTime	物业受理时间
//cpFeedback	用户投诉反馈
//cpFeedbackStatus用户是否反馈（0未反馈 1反馈）
//cpFeedbackDate  用户反馈时间

@property(strong,nonatomic)NSString *cpId;
@property(strong,nonatomic)NSString *cpTitle;
@property(strong,nonatomic)NSString *cpMess;
@property(strong,nonatomic)NSString *cpTime;
@property(strong,nonatomic)NSString *cpAcceptRemark;
@property(strong,nonatomic)NSString *cpAcceptMess;
@property(strong,nonatomic)NSString *cpAcceptTime;
@property(strong,nonatomic)NSString *cpFeedback;
@property(strong,nonatomic)NSString *cpFeedbackStatus;
@property(strong,nonatomic)NSString *cpFeedbackDate;
@property(assign,nonatomic)int cp_isAccept;
@property(nonatomic,strong)NSArray *photos;





@end
