//
//  FirstGetPasswordViewController.m
//  PropertyManagement
//
//  Created by admin on 14/12/3.
//  Copyright (c) 2014年 admin. All rights reserved.
//

#import "FirstGetPasswordViewController.h"
#import "SecoGetPasswordViewController.h"
#import "VersionAdapter.h"
#import "RequestUtil.h"
#import "ActivityView.h"
#import "SVProgressHUD.h"


@interface FirstGetPasswordViewController (){
    UITextField *cardFiled;
    ActivityView *activity;
}

@end

@implementation FirstGetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.title = @"找回密码";
    [self.view setBackgroundColor:[UIColor colorWithRed:242.0/255.0 green:242.0/255.0  blue:242.0/255.0  alpha:1.0]];
    [VersionAdapter setViewLayout:self];
    [self createUI];
    // Do any additional setup after loading the view.
}

-(void)createUI{
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    activity = [[ActivityView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44 - [VersionAdapter getMoreVarHead]) loadStr:NSLocalizedString(@"正在加载...", nil)];

    
    UIImageView *iv1 =[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, (self.view.frame.size.width-40)/3, 30)];
    [iv1 setImage:[UIImage imageNamed:@"step_now_1.png"]];
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, iv1.frame.size.width, 30)];
    [label1 setFont:[UIFont fontWithName:@"Arial" size:14]];
    label1.text = @"1.手机验证";
    label1.textAlignment = 1;
    [iv1 addSubview:label1];
    [self.view addSubview:iv1];
    
    UIImageView *iv2 =[[UIImageView alloc]initWithFrame:CGRectMake(20+iv1.frame.size.width,10 , (self.view.frame.size.width-40)/3, 30)];
    [iv2 setImage:[UIImage imageNamed:@"step_1.png"]];
    
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, iv1.frame.size.width, 30)];
    [label2 setFont:[UIFont fontWithName:@"Arial" size:14]];
    label2.text = @"2.手机确认";
    label2.textAlignment = 1;
    [iv2 addSubview:label2];
    [self.view addSubview:iv2];
    
    UIImageView *iv3 =[[UIImageView alloc]initWithFrame:CGRectMake(30+2*iv1.frame.size.width, 10, (self.view.frame.size.width-40)/3, 30)];
    [iv3 setImage:[UIImage imageNamed:@"step_2.png"]];
    UILabel * label3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, iv1.frame.size.width, 30)];
    [label3 setFont:[UIFont fontWithName:@"Arial" size:14]];
    label3.text = @"3.密码重置";
    label3.textAlignment = 1;
    [iv3 addSubview:label3];
    [self.view addSubview:iv3];
    
    UIView *lineview = [[UIView alloc]initWithFrame:CGRectMake(10, 45, self.view.frame.size.width-20, 1)];
    [lineview setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:lineview];
    
    
    UILabel * infoL = [[UILabel alloc]initWithFrame:CGRectMake(10, 55, self.view.frame.size.width, 30)];
    [infoL setFont:[UIFont fontWithName:@"Arial" size:14]];
    infoL.text = @"请输入您的手机号（用户号）进行验证";
    [self.view addSubview:infoL];

    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 95, 60, 30)];
    [label setFont:[UIFont fontWithName:@"Arial" size:14]];
    label.text = @"手机号";
    label.textAlignment = 1;
    [self.view addSubview:label];
    
    UIImageView *im = [[UIImageView alloc]initWithFrame:CGRectMake(65, 95, self.view.frame.size.width-120, 30)];
    [im setImage:[UIImage imageNamed: @"message_bg.png"]];
    [im setUserInteractionEnabled:YES];
    [self.view addSubview:im];

    cardFiled =[[UITextField alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-130, 30)];
    cardFiled.tag =0;
    cardFiled.placeholder = @"请输入手机";
    [cardFiled setBackgroundColor:[UIColor clearColor]];
    cardFiled.delegate = self;
    [cardFiled setFont:[UIFont fontWithName:@"Arial" size:14]];
    [im addSubview:cardFiled];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.tag = 1;
    [nextBtn setFrame:CGRectMake(15, 250, self.view.frame.size.width-30, 40)];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"17"] forState:UIControlStateNormal];
    [self.view addSubview:nextBtn];
    
    [self createBack];
    
    
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    [topView setBarStyle:UIBarStyleBlackTranslucent];
    
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(2, 5, 50, 25);
    [btn addTarget:self action:@selector(dismissKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"退出" forState:UIControlStateNormal];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneBtn,nil];
    [topView setItems:buttonsArray];
    [cardFiled setInputAccessoryView:topView];

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


-(void)dismissKeyBoard
{
    [cardFiled resignFirstResponder];
}



-(void)nextAction{
    RequestUtil *requestUtil = [[RequestUtil alloc]init];
    //业务数据参数组织成JSON字符串
    NSString *biz = [NSString  stringWithFormat:@"{\"mobile\":\"%@\"}",cardFiled.text];
    NSString *sid = @"CheckUserExist";
    [requestUtil startRequest:sid biz:biz send:self];

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
    if ([json[@"status"]isEqualToString:@"yes"]) {
        SecoGetPasswordViewController * sv = [[SecoGetPasswordViewController alloc]init];
        sv.mobile = [NSString stringWithFormat:@"%@",cardFiled.text];
        [self.navigationController pushViewController:sv animated:YES];
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
