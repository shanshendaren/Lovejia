//调用后台接口总线的统一请求方法的实现不含登录请求
//  RequestUtil.m
//
//
//  Created by kaiyitech on 14-8-4.
//  Copyright (c) 2014年 kaiyitech. All rights reserved.
//
#import "RequestUtil.h"
@implementation  RequestUtil:NSObject

#define SP_SERVER_ROOT @"http://192.167.0.104:8080/PropertyManagement/"

static NSString *serverRoot = @"";

//异步请求
-(void) startRequest:(NSString *)sid biz:(NSString *)biz send:(id)sender{
    
    NSString *urlString = [[NSString stringWithFormat:@"%@%@",SP_SERVER_ROOT,sid] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addPostValue:biz forKey:@"biz"];
    [request setDidStartSelector:@selector(requestStarted:)];
    [request setDidFinishSelector:@selector(requestCompleted:)];
    [request setDidFailSelector:@selector(requestError:)];
    [request setDelegate:sender];
    [request setTimeOutSeconds:45];
    [request startAsynchronous];
}

//同步请求
-(NSDictionary *)startSynRequest:(NSString *)sid biz:(NSString *)biz{
    NSDictionary *json = nil;
    NSString *urlString = [[NSString stringWithFormat:@"%@%@",SP_SERVER_ROOT,sid] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addPostValue:biz forKey:@"biz"];
    [request startSynchronous];
    NSError *requestError = [request error];
    if(!requestError)
    {
        NSString *returnData = [request responseString];
        if(returnData !=nil){
            NSData *jsonData = [returnData dataUsingEncoding:NSUTF8StringEncoding];
            json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&requestError];
        }
    }
    return json;
}

//文件上传请求
//-(void)startUploadFileRequest:(NSString *)biz file:(NSArray *)fileArray send:(id)sender{
//    SpbAppDelegate *appDel = (SpbAppDelegate *)[UIApplication sharedApplication].delegate;
//    NSString *dJson = [[NSString stringWithFormat:@"{\"bid\":\"%@\",\"uid\":\"%@\",\"cid\":\"%@\",\"sid\":\"%@\",\"stat\":\"0\",\"rmk\":\"\",\"ver\":\"\",\"token\":\"%@\",\"biz\":%@}", [CommonUtil getCurrentDateString:3],appDel.userMobile,appDel.companyId,@"com.cmhb.uploadfile",appDel.loginToken,biz]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//     dJson = [DESUtil encryptUseDES:dJson];
//    NSString *urlString = [[NSString stringWithFormat:@"%@",SP_UPLOADFILE_SERVER_ROOT] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURL *url = [NSURL URLWithString:urlString];
//    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
//    [request addPostValue:appDel.loginToken forKey:@"tok"];
//    [request addPostValue:dJson forKey:@"d"];
//    if(fileArray!=nil&&fileArray.count>0){
//        for(int i=0;i<fileArray.count;i++){
//            NSString *filePath = [fileArray objectAtIndex:i];
//            [request setFile:filePath forKey:[NSString stringWithFormat:@"FILE%d",i]];
//        }
//    }
//    [request buildPostBody];
//    [request setDidFinishSelector:@selector(requestCompleted:)];
//    [request setDidFailSelector:@selector(requestError:)];
//    [request setDelegate:sender];
//    [request setTimeOutSeconds:60];
//    [request startAsynchronous];
//}
//
////以block的方式请求
//- (ASIFormDataRequest *)startBlockRequest:(NSString *)sid biz:(NSString *)biz timeOutSeconds:(NSTimeInterval)timeOutSeconds completionBlock:(void (^)(NSDictionary *))completionBlock failedBlock:(void (^)(NSError *))failedBlock bytesReceivedBlock:(ASIProgressBlock)bytesReceivedBlock{
//    SpbAppDelegate *appDel = (SpbAppDelegate *)[UIApplication sharedApplication].delegate;
//    NSString *dJson = [[NSString stringWithFormat:@"{\"bid\":\"%@\",\"uid\":\"%@\",\"cid\":\"%@\",\"sid\":\"%@\",\"stat\":\"0\",\"rmk\":\"\",\"ver\":\"\",\"token\":\"%@\",\"biz\":%@}", [CommonUtil getCurrentDateString:3],appDel.userMobile,appDel.companyId,sid,appDel.loginToken,biz]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    dJson = [DESUtil encryptUseDES:dJson];
//    NSString *action = @"cmhb/control/BusinessServlet";
//    
//    NSString *urlString = [[NSString stringWithFormat:@"%@%@",SP_SERVER_ROOT,action] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURL *url = [NSURL URLWithString:urlString];
//    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
//    [request addPostValue:appDel.loginToken forKey:@"tok"];
//    [request addPostValue:dJson forKey:@"d"];
//    __weak ASIFormDataRequest *theRequest=request;
//    [request setCompletionBlock:^{
//          NSError *error = nil;
//        NSString *jsonStr = [theRequest responseString];
//        NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
//        if(jsonData==nil){//接口请求发生异常，直接返回
//            return;
//        }
//
//        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
//        if (completionBlock) {
//            completionBlock(json);
//        }
//    }];
//    [request setFailedBlock:^{
//        if (failedBlock) {
//            NSError *requestError = [theRequest error];
//            failedBlock(requestError);
//        }
//    }];
//    [request setBytesReceivedBlock:bytesReceivedBlock];
//    [request setTimeOutSeconds:timeOutSeconds];
//    return request;
//}


@end
