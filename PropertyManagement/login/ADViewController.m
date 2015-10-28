//
//  ADViewController.m
//  PropertyManagement
//
//  Created by admin on 15/2/4.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "ADViewController.h"
#import "VersionAdapter.h"
#import "SDWebImageManager.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "RequestUtil.h"
#import "ActivityView.h"
#import "SVProgressHUD.h"
#import "BZGuangGaoUrl.h"

@interface ADViewController (){
    ActivityView *activity;
}

@end

@implementation ADViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [VersionAdapter setViewLayout:self];
    
    UIImageView *iv =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:iv];
    [iv setImage:[UIImage imageNamed:@"loginView"]];
    [self createUI];
}

-(void)createUI{
    RequestUtil *request1 =[[RequestUtil alloc]init];
    NSString *biz1 = [NSString  stringWithFormat:@"{\"type\":\"3\"}"];
    NSString *sid1 = @"QueryPic";
    [request1 startRequest:sid1 biz:biz1 send:self];
}

-(void)requestStarted:(ASIHTTPRequest *)request{
    if ([activity isVisible] == NO) {
        [activity startAnimate:self];
    }
}

-(void)requestCompleted:(ASIHTTPRequest *)request{
    NSError *error;
    //获取接口总线返回的结果
    NSString *returnData = [request responseString];
    NSData *jsonData = [returnData dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    if ([activity isVisible]) {
        [activity stopAcimate];
    }
    if ([json[@"status"]isEqualToString:@"success"]) {
        if (((NSArray *)[json objectForKey:@"picInfo"]).count >0){
            if([[json objectForKey:@"type"]  isEqual: @3])
            {
                NSArray * arr =[json objectForKey:@"picInfo"];
                NSDictionary *dic =[arr firstObject];
                _url =[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"picPath"]]];
                BZGuangGaoUrl *GGUrl = [BZGuangGaoUrl sharedInstance];
                GGUrl.GGurl = _url;
            }else{
                [SVProgressHUD showErrorWithStatus:json[@"message"]];
}}}}

-(void)requestError:(ASIHTTPRequest *)request{
    NSError *error = [request error];
    if ([activity isVisible]) {
        [activity stopAcimate];
    }
    [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
