//  RequestUtil.m
//
//
//  Created by kaiyitech on 14-8-4.
//  Copyright (c) 2014年 kaiyitech. All rights reserved.
#import "RequestUtil.h"

@implementation  RequestUtil:NSObject
//#define SP_SERVER_ROOT @"http://www.whwyt.com.cn/PropertyManagement/"
//#define SP_SERVER_ROOT @"http://192.168.100.108:8080/PropertyManagement/"
#define SP_SERVER_ROOT @"http://www.whaijia.cn/PropertyManagement/"
/*www.whaijia.cn/PropertyManagement/
 192.168.1.100:8080/PropertyManagement/
 */

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
   NSLog(@"%@_____%@",biz,url);
}

//异步请求
-(void) startRequest:(NSString *)sid biz:(NSString *)biz send:(id)sender requestTag:(int)tag{
    NSString *urlString = [[NSString stringWithFormat:@"%@%@",SP_SERVER_ROOT,sid] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.tag = tag;
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
-(void)startUploadFileRequest:(NSString *)biz  sid :(NSString *)sid file:(NSArray *)fileArray send:(id)sender{
    NSString *urlString = [[NSString stringWithFormat:@"%@%@",SP_SERVER_ROOT,sid] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    NSString * str = [biz stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [request addPostValue:str forKey:@"biz"];
    if(fileArray!=nil&&fileArray.count>0){
        for(int i=0;i<fileArray.count;i++){
            NSString *filePath = [fileArray objectAtIndex:i];
            [request setFile:filePath forKey:[NSString stringWithFormat:@"FILE%d",i]];
        }
    }
//    else{
//        [request setFile:@"312313" forKey:[NSString stringWithFormat:@"FILE%d",1]];
//    }
    [request buildPostBody];
    [request setDidFinishSelector:@selector(requestCompleted:)];
    [request setDidFailSelector:@selector(requestError:)];
    [request setDelegate:sender];
    [request setTimeOutSeconds:45];
    [request startAsynchronous];
}

@end
