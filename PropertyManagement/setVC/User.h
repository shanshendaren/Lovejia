//
//  User.h
//  PropertyManagement
//
//  Created by admin on 14/12/18.
//  Copyright (c) 2014年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property(strong,nonatomic)NSString * userName; //用户名字
@property(strong,nonatomic)NSString * userMobile;//用户手机号
@property(strong,nonatomic)NSString * userEmail;//用户邮件
@property(strong,nonatomic)NSString * userID;//用户id
@property(strong,nonatomic)NSString * userSex;//用户性别
@property(strong,nonatomic)NSString * userCardNum;//用户身份证
@property(strong,nonatomic)NSString * userPlace;//用户身份证

@end
