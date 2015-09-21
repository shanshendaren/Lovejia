//
//  NextRegisterViewController.m
//  PropertyManagement
//
//  Created by admin on 14/12/3.
//  Copyright (c) 2014年 admin. All rights reserved.
//

#import "NextRegisterViewController.h"
#import "VersionAdapter.h"
#import "RequestUtil.h"
#import "ActivityView.h"
#import "SVProgressHUD.h"
#import "BZAppDelegate.h"


@interface NextRegisterViewController (){
    UITextField *cardFiled;
    NSString *codeNum;
    ActivityView *activity;
    UITextView * ruleView;
    UILabel *countL;
    NSTimer*timer;
    int a;

}

@end

@implementation NextRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:242.0/255.0 green:242.0/255.0  blue:242.0/255.0  alpha:1.0]];
    [VersionAdapter setViewLayout:self];
    [self createUI];
    RequestUtil *requestUtil = [[RequestUtil alloc]init];
    //业务数据参数组织成JSON字符串
    NSString *biz = [NSString  stringWithFormat:@"{\"mobile\":\"%@\"}",self.mobile];
    NSString *sid = @"CheckUserExist";
    [requestUtil startRequest:sid biz:biz send:self];

}

-(void)createUI{
    [self createBack];
    activity = [[ActivityView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44 - [VersionAdapter getMoreVarHead]) loadStr:NSLocalizedString(@"正在加载...", nil)];
    self.title = @"短信验证";
    
    ruleView= [[UITextView  alloc] initWithFrame:CGRectMake(10, 15, self.view.frame.size.width-20, 40)] ; //初始化大小
    ruleView.textColor = [UIColor blackColor];//设置textview里面的字体颜色
    ruleView.font = [UIFont fontWithName:@"Arial" size:14.0];//设置字体名字和字体大小
    ruleView.delegate = self;//设置它的委托方法
    ruleView.backgroundColor = [UIColor clearColor];//设置它的背景颜色
    ruleView.text = [NSString stringWithFormat:@"我们已给你的手机号码%@发送了一条验证短信!",self.mobile];//设置它显示的内容
    ruleView.returnKeyType = UIReturnKeyDefault;//返回键的类型
    ruleView.keyboardType = UIKeyboardTypeDefault;//键盘类型
    [ruleView setEditable:NO];
    ruleView.scrollEnabled = NO;//是否可以拖动
    [self.view addSubview: ruleView];
    
    UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 75, self.view.frame.size.width, 40)];
    [view1 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view1];
    
    
    cardFiled =[[UITextField alloc]initWithFrame:CGRectMake(20, 5, self.view.frame.size.width-120, 30)];
    cardFiled.tag =0;
    cardFiled.placeholder = @"请输入验证码";
    cardFiled.delegate = self;
    [cardFiled setFont:[UIFont fontWithName:@"Arial" size:14]];
    [view1 addSubview:cardFiled];
    
    UIButton *reBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [reBtn setFrame:CGRectMake(self.view.frame.size.width-130,10, 80, 20)];
    [reBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *agreeL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 20)];
    agreeL.text =@"重获验证码";
    [agreeL setFont:[UIFont fontWithName:@"Arial" size:14]];
    [agreeL setTextColor:[UIColor redColor]];
    [reBtn addSubview:agreeL];
    [view1 addSubview:reBtn];
    
    countL = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-50,10, 45, 20)];
    [countL setFont:[UIFont fontWithName:@"Arial" size:14]];
    [countL setTextColor:[UIColor grayColor]];
    [view1 addSubview:countL];


    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.tag = 1;
    [nextBtn setFrame:CGRectMake(15, 150, self.view.frame.size.width-30, 40)];
    [nextBtn setTitle:@"确定" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(clickedAction) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"17"] forState:UIControlStateNormal];
    [self.view addSubview:nextBtn];
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];

}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [cardFiled resignFirstResponder];
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
    CATransition *transition = [CATransition animation];
    transition.duration = 1.f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = @"oglFlip";
    transition.subtype = kCATransitionFromRight;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
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
    if ([activity isVisible]) {
        [activity stopAcimate];
    }
    if ([json[@"SID"]isEqualToString:@"GetVerificationCode"]){
        if ([json[@"status"]isEqualToString:@"success"]) {
            codeNum =[NSString stringWithFormat:@"%@",json[@"code"]];
            a = 90;
            countL.text =[NSString stringWithFormat:@"%i",a];
            timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector: @selector(logo) userInfo: nil repeats: YES];
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"验证码已发送请稍等"]];
        }else{
            [SVProgressHUD showErrorWithStatus:json[@"message"]];
        }
    }
    else if([json[@"SID"]isEqualToString:@"RegistrationService"]){
        if ([json[@"status"]isEqualToString:@"success"]){
            [SVProgressHUD showSuccessWithStatus:json[@"msg"]];
            NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
            [userDefault setObject:self.mobile forKey:@"userName"];
            [userDefault setObject:self.passWord forKey:@"passWord"];
            [userDefault synchronize];
            BZAppDelegate *app = [UIApplication sharedApplication].delegate;
            [app bootLoginViewController];
        }else{
            [SVProgressHUD showErrorWithStatus:json[@"message"]];
        }
    }
    if ([json[@"status"]isEqualToString:@"yes"]) {
        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"该用户已存在"]];
        ruleView.text = [NSString stringWithFormat:@"手机号码%@已被注册请换个手机号注册",self.mobile];//设置它显示的内容
    }
    else if ([json[@"status"]isEqualToString:@"no"]) {
        RequestUtil *requestUtil = [[RequestUtil alloc]init];
        //业务数据参数组织成JSON字符串
        NSString *biz = [NSString  stringWithFormat:@"{\"mobile\":\"%@\"}",self.mobile];
        NSString *sid = @"GetVerificationCode";
        [requestUtil startRequest:sid biz:biz send:self];
    }
}

-(void)requestError:(ASIHTTPRequest *)request{
    NSError *error = [request error];
    if ([activity isVisible]) {
        [activity stopAcimate];
    }
    [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
}


-(void)logo{
    int b = a--;
    if (b>=0) {
        countL.text =[NSString stringWithFormat:@"%i",b];
    }else{
        [timer invalidate];
    }
}


-(void)clickedAction{
    if (cardFiled.text.length == 0) {
        [self doAlert:@"请输入验证码！"];
        return;
    }else if (![cardFiled.text isEqualToString:codeNum]){
        [self doAlert:@"输入验证码错误！"];
        return;
    }
    RequestUtil *requestUtil = [[RequestUtil alloc]init];
    //业务数据参数组织成JSON字符串
    NSString *biz = [NSString  stringWithFormat:@"{\"username\":\"%@\",\"tel\":\"%@\",\"password\":\"%@\",\"vallageId\":\"%@\",\"address\":\"\",\"seat\":\"%@\",\"unit\":\"%@\",\"house\":\"%@\"}",self.userName,self.mobile,self.passWord,self.vallegeId,self.seat,self.unit,self.house];
    NSString *sid = @"RegistrationService";
    [requestUtil startRequest:sid biz:biz send:self];
}

-(void)doAlert:(NSString *)inMessage {
    UIAlertView *alertDialog = [[UIAlertView alloc] initWithTitle:@"提示信息" message:inMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertDialog show];
}

-(void)nextAction{
    [timer invalidate];
    RequestUtil *requestUtil = [[RequestUtil alloc]init];
    //业务数据参数组织成JSON字符串
    NSString *biz = [NSString  stringWithFormat:@"{\"mobile\":\"%@\"}",self.mobile];
    NSString *sid = @"GetVerificationCode";
    [requestUtil startRequest:sid biz:biz send:self];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [super viewWillDisappear:animated];
    [timer invalidate];
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
