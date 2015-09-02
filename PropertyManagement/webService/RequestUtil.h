//  调用后台接口总线的统一请求方法不含登录请求
//  RequestUtil.h
//
//
//  Created by kaiyitech on 14-8-4.
//  Copyright (c) 2014年 kaiyitech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
@interface  RequestUtil:NSObject

//sid:对应接口总线的中SID，接口惟一标识  参数为明文，不可加密
//biz:对应接口总线的biz ，业务参数的JSON字符串 参数为明文，不可加密
-(void) startRequest:(NSString *)sid biz:(NSString *)biz send:(id)sender;
//同步请求
-(NSDictionary *)startSynRequest:(NSString *)sid biz:(NSString *)biz;

//上传文件
-(void)startUploadFileRequest:(NSString *)biz  sid :(NSString *)sid file:(NSArray *)fileArray send:(id)sender;


-(void) startRequest:(NSString *)sid biz:(NSString *)biz send:(id)sender requestTag:(int)tag;

@end
