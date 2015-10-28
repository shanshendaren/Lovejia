//
//  information.h
//  PropertyManagement
//
//  Created by admin on 14/11/19.
//  Copyright (c) 2014年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface information : NSObject

@property(strong,nonatomic)NSString *informationTypeId;//资讯类型
@property(strong,nonatomic)NSString *typeName;//类型资讯的标题
@property(strong,nonatomic)NSURL *typePic;//类型资讯的图片路径
@property(strong,nonatomic)NSString *typeInfo;//类型资讯的简介
@property(strong,nonatomic)NSString *information_id;//一个类型中一条资讯的id
@property(strong,nonatomic)NSString *information_title;//一个类型中一条资讯的标题
@property(strong,nonatomic)NSString *information_content;//一个类型中一条资讯的内容
@property(strong,nonatomic)NSString *information_picture_s;//一个类型中一条资讯的小图片
@property(strong,nonatomic)NSString *information_picture_b;//一个类型中一条资讯的大图片
@property(strong,nonatomic)NSString *createTime;//一个类型中一条资讯的创建时间
@property(assign)BOOL isSubscribe;//一个类型中一条资讯的创建时间

@end
