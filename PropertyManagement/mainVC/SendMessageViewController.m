//
//  SendMessageViewController.m
//  PropertyManagement
//
//  Created by admin on 15/3/6.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "SendMessageViewController.h"
#import "VersionAdapter.h"
#import "RequestUtil.h"
#import "BZAppDelegate.h"
#import "ActivityView.h"
#import "SVProgressHUD.h"


@interface SendMessageViewController (){
    UITextView *contentView;
    ActivityView *activity;

}

@end

@implementation SendMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评论";
    [VersionAdapter setViewLayout:self];
    [self.view setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0  blue:238.0/255.0  alpha:1.0]];
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 15, 15);
    backButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:backButton];

    activity = [[ActivityView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44 - [VersionAdapter getMoreVarHead]) loadStr:NSLocalizedString(@"正在加载...", nil)];

    contentView= [[UITextView  alloc] initWithFrame:CGRectMake(5, 10, self.view.frame.size.width-10, 200)] ; //初始化大小
    contentView.tag = 2;
    [contentView setBackgroundColor:[UIColor whiteColor]];
    contentView.font = [UIFont fontWithName:@"Arial" size:14.0];//设置字体名字和字体大小
    contentView.delegate = self;//设置它的委托方法
    contentView.returnKeyType = UIReturnKeyDefault;//返回键的类型
    contentView.keyboardType = UIKeyboardTypeDefault;//键盘类型
    [contentView setEditable:YES];
    contentView.scrollEnabled = YES;//是否可以拖动
    contentView.textColor = [UIColor blackColor];
    [self.view addSubview: contentView];

    
    UIButton *newBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [newBtn setFrame:CGRectMake(self.view.frame.size.width-60, 0, 50, 30)];
    [newBtn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [newBtn setTintColor:[UIColor lightGrayColor]];
    [newBtn setTintColor:[UIColor whiteColor]];
    [newBtn setTitleEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [newBtn setTitle:@"发送" forState:UIControlStateNormal];
    [newBtn setBackgroundImage:nil forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:newBtn];

}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)click{
    if (contentView.text.length == 0) {
        UIAlertView *view =[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"不能发送空评论" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [view show];
        return;
    }
    
    if (self.valuablesInfo) {
        BZAppDelegate *app =[UIApplication sharedApplication].delegate;
        RequestUtil *requestUtil = [[RequestUtil alloc]init];
        //业务数据参数组织成JSON字符串
        NSString *biz = [NSString  stringWithFormat:@"{\"userId\":\"%@\",\"barterInfoId\":\"%@\",\"content\":\"%@\",\"vallageId\":\"%@\",\"registrationId\":\"%@\",\"deviceType\":\"%@\"}",app.userID,self.valuablesInfo.barterInfoId,contentView.text,app.vallageID,self.valuablesInfo.registrationId,self.valuablesInfo.deviceType];
        NSString *sid = @"SaveBarterCommonInfo";
        [requestUtil startRequest:sid biz:biz send:self];
    }
    else if (self.car) {
        BZAppDelegate *app =[UIApplication sharedApplication].delegate;
        RequestUtil *requestUtil = [[RequestUtil alloc]init];
        //业务数据参数组织成JSON字符串
        NSString *biz = [NSString  stringWithFormat:@"{\"userId\":\"%@\",\"neighborhordCarpoolId\":\"%@\",\"content\":\"%@\",\"vallageId\":\"%@\",\"registrationId\":\"%@\",\"deviceType\":\"%@\"}",app.userID,self.car.neighborhordCarpoolInfoId,contentView.text,app.vallageID,self.car.registrationId,self.car.deviceType];
        NSString *sid = @"SaveNeighborhordCarpoolCommonInfo";
        [requestUtil startRequest:sid biz:biz send:self];
    }
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
        [SVProgressHUD showSuccessWithStatus:json[@"message"]];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [SVProgressHUD showErrorWithStatus:json[@"message"]];
    }
}

-(void)requestError:(ASIHTTPRequest *)request{
    NSError *error = [request error];
    if ([activity isVisible]) {
        [activity stopAcimate];
    }
    [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
