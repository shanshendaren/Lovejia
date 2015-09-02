//
//  NoticeInfoViewController.m
//  PropertyManagement
//
//  Created by admin on 14/11/26.
//  Copyright (c) 2014年 admin. All rights reserved.
//

#import "NoticeInfoViewController.h"
#import "VersionAdapter.h"
#import "RequestUtil.h"
#import "SVProgressHUD.h"
#import "ActivityView.h"
#import "Notice.h"

@interface NoticeInfoViewController (){
    ActivityView *activity;
    UILabel *titleLabel;
    UILabel * timeLabel;
    UITextView * contentView;
}

@end

@implementation NoticeInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    // Do any additional setup after loading the view.
}

-(void)createUI{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [VersionAdapter setViewLayout:self];
    self.title = @"通知详情";
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];

    activity = [[ActivityView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44 - [VersionAdapter getMoreVarHead]) loadStr:NSLocalizedString(@"正在加载...", nil)];
    RequestUtil *requestUtil = [[RequestUtil alloc]init];
    //业务数据参数组织成JSON字符串
    NSString *biz = [NSString  stringWithFormat:@"{\"messId\":\"%@\"}",self.noticeId];
    NSString *sid = @"FindMessage";
    [requestUtil startRequest:sid biz:biz send:self];
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 30)];
    titleLabel.textAlignment = 1;
    titleLabel.font = [UIFont fontWithName:nil size:16];
    [self.view addSubview:titleLabel];
    
    timeLabel =  [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-120, 40,120,20)];
    timeLabel.font = [UIFont fontWithName:nil size:12];
    [self.view addSubview:timeLabel];
    
    contentView= [[UITextView  alloc] initWithFrame:CGRectMake(20, 60, self.view.frame.size.width-40, self.view.frame.size.height-60-44-[VersionAdapter getMoreVarHead])] ; //初始化大小
    contentView.textColor = [UIColor blackColor];//设置textview里面的字体颜色
    contentView.font = [UIFont fontWithName:@"Arial" size:14.0];//设置字体名字和字体大小
    contentView.delegate = self;//设置它的委托方法
    contentView.backgroundColor = [UIColor whiteColor];//设置它的背景颜色
    contentView.returnKeyType = UIReturnKeyDefault;//返回键的类型
    contentView.keyboardType = UIKeyboardTypeDefault;//键盘类型
    [contentView setEditable:NO];
    contentView.scrollEnabled = YES;//是否可以拖动
    contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    [self.view addSubview: contentView];
    [self createBack];
}


-(void)createBack{
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 15, 15);
    backButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:backButton];
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
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
    NSDictionary *rdic = json[@"mess"];
    Notice *notice = [[Notice alloc]init];
    if (rdic) {
        notice.messDetail = [rdic objectForKey:@"messDetail"];
        notice.messTitle = [rdic objectForKey:@"messTitle"];
        notice.messType = [rdic objectForKey:@"messType"];
        notice.messTime = [rdic objectForKey:@"messTime"];
    }
    if ([json[@"status"]isEqualToString:@"success"]) {
        titleLabel.text = [NSString stringWithFormat:@"%@",notice.messTitle];
        timeLabel.text = [NSString stringWithFormat:@"%@",notice.messTime];
        contentView.text = [NSString stringWithFormat:@"%@",notice.messDetail];
    }else{
        [SVProgressHUD showErrorWithStatus:json[@"message"]];
    }
    if ([activity isVisible]) {
        [activity stopAcimate];
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
