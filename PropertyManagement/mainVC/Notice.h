//
//  Notice.h
//  PropertyManagement
//
//  Created by admin on 14/11/26.
//  Copyright (c) 2014年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Notice : NSObject

//messId		消息id
//messType	消息类型id
//typeName	消息类型名字
//messTitle	消息标题
//messTime	消息创建时间

@property(strong,nonatomic)NSString *messId;
@property(strong,nonatomic)NSString *messType;
@property(strong,nonatomic)NSString *typeName;
@property(strong,nonatomic)NSString *messTitle;
@property(strong,nonatomic)NSString *messTime;
@property(strong,nonatomic)NSString *messDetail;//详细内容



@end
