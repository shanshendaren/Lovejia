//
//  LastGetPasswordViewController.m
//  PropertyManagement
//
//  Created by admin on 14/12/3.
//  Copyright (c) 2014年 admin. All rights reserved.
//

#import "LastGetPasswordViewController.h"
#import "VersionAdapter.h"
#import "BZAppDelegate.h"
#import "RequestUtil.h"
#import "ActivityView.h"
#import "SVProgressHUD.h"


@interface LastGetPasswordViewController (){
    UITextField *passWordFiled;
    UITextField *rePassWordFiled;
    ActivityView *activity;

}

@end

@implementation LastGetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    [iv1 setImage:[UIImage imageNamed:@"step_1.png"]];
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, iv1.frame.size.width, 30)];      
    [label1 setFont:[UIFont fontWithName:nil size:14]];
    label1.text = @"1.手机验证";
    label1.textAlignment = 1;
    [iv1 addSubview:label1];
    [self.view addSubview:iv1];
    
    UIImageView *iv2 =[[UIImageView alloc]initWithFrame:CGRectMake(20+iv1.frame.size.width,10 , (self.view.frame.size.width-40)/3, 30)];
    [iv2 setImage:[UIImage imageNamed:@"step_1.png"]];
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, iv1.frame.size.width, 30)];
    [label2 setFont:[UIFont fontWithName:nil size:14]];
    label2.text = @"2.手机确认";
    label2.textAlignment = 1;
    [iv2 addSubview:label2];
    [self.view addSubview:iv2];
    
    UIImageView *iv3 =[[UIImageView alloc]initWithFrame:CGRectMake(30+2*iv1.frame.size.width, 10, (self.view.frame.size.width-40)/3, 30)];
    [iv3 setImage:[UIImage imageNamed:@"step_now_2.png"]];
    UILabel * label3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, iv1.frame.size.width, 30)];
    [label3 setFont:[UIFont fontWithName:nil size:14]];
    label3.text = @"3.密码重置";
    label3.textAlignment = 1;
    [iv3 addSubview:label3];
    [self.view addSubview:iv3];
    
    UIView *lineview = [[UIView alloc]initWithFrame:CGRectMake(10, 45, self.view.frame.size.width-20, 1)];
    [lineview setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:lineview];
    
    UILabel * infoL = [[UILabel alloc]initWithFrame:CGRectMake(10, 55, self.view.frame.size.width, 30)];
    [infoL setFont:[UIFont fontWithName:nil size:14]];
    infoL.text = @"您可以重新设置您的登录密码";
    [self.view addSubview:infoL];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 95, 60, 30)];
    [label setFont:[UIFont fontWithName:nil size:14]];
    label.text = @"新密码";
    label.textAlignment = 1;
    [self.view addSubview:label];
    
    UIImageView *im = [[UIImageView alloc]initWithFrame:CGRectMake(75, 95, self.view.frame.size.width-90, 30)];
    [im setImage:[UIImage imageNamed: @"message_bg.png"]];
    [im setUserInteractionEnabled:YES];
    [self.view addSubview:im];
    
    passWordFiled =[[UITextField alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-130, 30)];
    passWordFiled.tag =0;
    passWordFiled.placeholder = @"6-16个字符，区分大小写";
    passWordFiled.secureTextEntry = YES;
    [passWordFiled setBackgroundColor:[UIColor clearColor]];
    passWordFiled.delegate = self;
    [passWordFiled setFont:[UIFont fontWithName:nil size:14]];
    [im addSubview:passWordFiled];
    
    UILabel * newlabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 135, 60, 30)];
    [newlabel setFont:[UIFont fontWithName:nil size:14]];
    newlabel.text = @"确认密码";
    newlabel.textAlignment = 1;
    [self.view addSubview:newlabel];
    
    UIImageView *newim = [[UIImageView alloc]initWithFrame:CGRectMake(75, 135, self.view.frame.size.width-90, 30)];
    [newim setImage:[UIImage imageNamed: @"message_bg.png"]];
    [newim setUserInteractionEnabled:YES];
    [self.view addSubview:newim];
    
    rePassWordFiled =[[UITextField alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-130, 30)];
    rePassWordFiled.tag =0;
    rePassWordFiled.secureTextEntry = YES;
    rePassWordFiled.placeholder = @"6-16个字符，区分大小写";
    [rePassWordFiled setBackgroundColor:[UIColor clearColor]];
    rePassWordFiled.delegate = self;
    [rePassWordFiled setFont:[UIFont fontWithName:nil size:14]];
    [newim addSubview:rePassWordFiled];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.tag = 1;
    [nextBtn setFrame:CGRectMake(15, 250, self.view.frame.size.width-30, 40)];
    [nextBtn setTitle:@"确定" forState:UIControlStateNormal];
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
    [passWordFiled setInputAccessoryView:topView];
    [rePassWordFiled setInputAccessoryView:topView];
}


-(void)dismissKeyBoard
{
    [passWordFiled resignFirstResponder];
    [rePassWordFiled resignFirstResponder];
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

-(void)nextAction{
     if ([passWordFiled.text length] == 0){
        [self doAlert:@"请输入密码！"];
        [passWordFiled becomeFirstResponder];
        return;
    }
    else if ([rePassWordFiled.text length] == 0){
        [self doAlert:@"请输确认密码！"];
        [rePassWordFiled becomeFirstResponder];
        return;
    }
    else if (![passWordFiled.text isEqualToString:rePassWordFiled.text]){
        [self doAlert:@"两次密码不一致！"];
        [rePassWordFiled becomeFirstResponder];
        return;
    }
    RequestUtil *requestUtil = [[RequestUtil alloc]init];
    //业务数据参数组织成JSON字符串
    NSString *biz = [NSString  stringWithFormat:@"{\"mobile\":\"%@\",\"pwd\":\"%@\"}",self.mobile,passWordFiled.text];
    NSString *sid = @"UpdateUserPWD";
    [requestUtil startRequest:sid biz:biz send:self];

}


-(void)doAlert:(NSString *)inMessage {
    UIAlertView *alertDialog = [[UIAlertView alloc] initWithTitle:@"提示信息" message:inMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertDialog show];
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
        NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
        [userDefault setObject:self.mobile forKey:@"userName"];
        [userDefault setObject:passWordFiled.text forKey:@"passWord"];
        [userDefault synchronize];
        BZAppDelegate *app = [UIApplication sharedApplication].delegate;
        [app bootLoginViewController];
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
