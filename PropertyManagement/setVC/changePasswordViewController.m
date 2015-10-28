//
//  changePasswordViewController.m
//  PropertyManagement
//
//  Created by admin on 14/11/18.
//  Copyright (c) 2014年 admin. All rights reserved.
//

#import "changePasswordViewController.h"
#import "BZAppDelegate.h"
#import "RequestUtil.h"
#import "ActivityView.h"
#import "SVProgressHUD.h"


@interface changePasswordViewController (){
    UITextField *OldpassWordFiled;
    UITextField *newpassWordFiled;
    UITextField *rePassWordFiled;
    ActivityView *activity;

}

@end

@implementation changePasswordViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    BZAppDelegate* app = (BZAppDelegate *)[UIApplication sharedApplication].delegate;
    [app.tabBar customTabBarHidden:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [VersionAdapter setViewLayout:self];
    [self.view setBackgroundColor:[UIColor colorWithRed:242.0/255.0 green:242.0/255.0  blue:242.0/255.0  alpha:1.0]];
    self.title = @"修改密码";
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:FONT_SIZE],NSFontAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    [self createUI];
}

-(void)createUI{
    activity = [[ActivityView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44 - [VersionAdapter getMoreVarHead]) loadStr:NSLocalizedString(@"正在加载...", nil)];
    
    UILabel *oldLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, 200, 20)];
    oldLabel.text = @"原始密码";
    [oldLabel setFont:[UIFont fontWithName:@"Arial" size:FONT_SIZE]];
    [self.view addSubview:oldLabel];
    
    UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, 40)];
    [view1 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view1];

    OldpassWordFiled =[[UITextField alloc]initWithFrame:CGRectMake(20, 5, self.view.frame.size.width-40, 30)];
    OldpassWordFiled.tag = 0;
    OldpassWordFiled.placeholder = @"6-16个字符，区分大小写";
    OldpassWordFiled.delegate = self;
    OldpassWordFiled.secureTextEntry = YES;
    [OldpassWordFiled setFont:[UIFont fontWithName:@"Arial" size:FONT_SIZE]];
    [view1 addSubview:OldpassWordFiled];
    
    
    UILabel *newLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 95, 200, 20)];
    newLabel.text = @"新密码";
    [newLabel setFont:[UIFont fontWithName:@"Arial" size:FONT_SIZE]];

    [self.view addSubview:newLabel];
    
    UIView * view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 120, self.view.frame.size.width, 40)];
    [view2 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view2];

    newpassWordFiled =[[UITextField alloc]initWithFrame:CGRectMake(20, 5, self.view.frame.size.width-40, 30)];
    newpassWordFiled.tag =1;
    newpassWordFiled.placeholder = @"6-16个字符，区分大小写";
    newpassWordFiled.delegate = self;
    [newpassWordFiled setFont:[UIFont fontWithName:@"Arial" size:FONT_SIZE]];
    newpassWordFiled.secureTextEntry = YES;
    [view2 addSubview:newpassWordFiled];
    
    UILabel *renewLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 175, 200, 20)];
    renewLabel.text = @"确认新密码";
    [renewLabel setFont:[UIFont fontWithName:@"Arial" size:FONT_SIZE]];
    [self.view addSubview:renewLabel];
    
    UIView * view3 = [[UIView alloc]initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 40)];
    [view3 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view3];
    
    rePassWordFiled =[[UITextField alloc]initWithFrame:CGRectMake(20, 5, self.view.frame.size.width-40, 30)];
    rePassWordFiled.tag = 2;
    [rePassWordFiled setFont:[UIFont fontWithName:@"Arial" size:FONT_SIZE]];
    rePassWordFiled.placeholder = @"6-16个字符，区分大小写";
    rePassWordFiled.delegate = self;
    rePassWordFiled.secureTextEntry = YES;
    [view3 addSubview:rePassWordFiled];
    
    UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeBtn setFrame:CGRectMake(10, 260, self.view.frame.size.width-20, 40)];
    [changeBtn setTitle:@"确定" forState:UIControlStateNormal];
    [changeBtn setBackgroundImage:[UIImage imageNamed:@"17"] forState:UIControlStateNormal];
    [changeBtn addTarget:self action:@selector(changeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeBtn];
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

-(void)dismissKeyBoard
{
    [rePassWordFiled resignFirstResponder];
    [OldpassWordFiled resignFirstResponder];
    [newpassWordFiled resignFirstResponder];
}


-(void)backAction{
    [self dismissViewControllerAnimated:NO completion:^{
    }];
}


-(void)changeAction{
    if ([OldpassWordFiled.text length]==0){
        [self doAlert:@"请输入原始密码！"];
        [OldpassWordFiled becomeFirstResponder];
        return;
    }
    else if ([newpassWordFiled.text length] == 0){
        [self doAlert:@"请输入新密码！"];
        [newpassWordFiled becomeFirstResponder];
        return;
    }
    else if ([rePassWordFiled.text length] == 0){
        [self doAlert:@"请输确认新密码！"];
        [rePassWordFiled becomeFirstResponder];
        return;
    }
    else if (![newpassWordFiled.text isEqualToString:rePassWordFiled.text]){
        [self doAlert:@"两次输入的新密码不一致！"];
        [rePassWordFiled becomeFirstResponder];
        return;
    }
    BZAppDelegate *app =[UIApplication sharedApplication].delegate;
    RequestUtil *requestUtil = [[RequestUtil alloc]init];
    //业务数据参数组织成JSON字符串
    NSString *biz = [NSString  stringWithFormat:@"{\"tel\":\"%@\",\"oldpwd\":\"%@\",\"newpwd\":\"%@\"}",app.userMobile,OldpassWordFiled.text,newpassWordFiled.text];
    NSString *sid = @"ChangePassword";
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
    if ([json[@"status"]isEqualToString:@"success"]) {
        [SVProgressHUD showSuccessWithStatus:json[@"message"]];
        NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
        [userDefault setObject:newpassWordFiled.text forKey:@"passWord"];
        [userDefault synchronize];
        [self dismissViewControllerAnimated:NO completion:^{
        }];
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

-(void)doAlert:(NSString *)inMessage {
    UIAlertView *alertDialog = [[UIAlertView alloc] initWithTitle:@"提示信息" message:inMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertDialog show];
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
