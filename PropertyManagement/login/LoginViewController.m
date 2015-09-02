//
//  LoginViewController.m
//  PropertyManagement
//
//  Created by admin on 14/11/12.
//  Copyright (c) 2014年 admin. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "VersionAdapter.h"
#import "BZAppDelegate.h"
#import "RequestUtil.h"
#import "ActivityView.h"
#import "SVProgressHUD.h"
#import <CommonCrypto/CommonDigest.h>
#import "FirstGetPasswordViewController.h"

@interface LoginViewController (){
    UITextField *userLogin;
    UITextField *passWordFiled;
    ActivityView *activity;
}

@end

@implementation LoginViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self createUI];
    
    

    
    // Do any additional setup after loading the view.
}

//-(BOOL)prefersStatusBarHidden{
//    return YES;
//}
-(void)createUI{
    [VersionAdapter setViewLayout:self];
    
    UIImageView *bgIV =[[UIImageView alloc]initWithFrame:self.view.frame];
    [bgIV setUserInteractionEnabled:YES];
    [bgIV setImage:[UIImage imageNamed:@"denglu"]];
    [self.view addSubview:bgIV];
    
    activity = [[ActivityView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44 - [VersionAdapter getMoreVarHead]) loadStr:NSLocalizedString(@"正在加载...", nil)];
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    
    UIImageView *userIV = [[UIImageView alloc]initWithFrame:CGRectMake(40, 200, self.view.frame.size.width-80, 40)];
    [userIV setUserInteractionEnabled:YES];
    [userIV setImage:[UIImage imageNamed:@"user_inputbox.png"]];
    [bgIV addSubview:userIV];
    
    userLogin =[[UITextField alloc]initWithFrame:CGRectMake(30, 0, self.view.frame.size.width-110, 40)];
    userLogin.tag = 0;
    userLogin.delegate = self;
    userLogin.placeholder = @"请输入账号";
    [userIV addSubview:userLogin];
    
    if ([userDefault objectForKey:@"userName"]) {
        userLogin.text = [NSString stringWithFormat:@"%@",[userDefault objectForKey:@"userName"]];
    }
    UIImageView *passWordIV = [[UIImageView alloc]initWithFrame:CGRectMake(40, 250, self.view.frame.size.width-80, 40)];
    [passWordIV setUserInteractionEnabled:YES];
    [passWordIV setImage:[UIImage imageNamed:@"password_inputbox.png"]];
    [bgIV addSubview:passWordIV];
    
    passWordFiled =[[UITextField alloc]initWithFrame:CGRectMake(30, 0, self.view.frame.size.width-110, 40)];
    passWordFiled.placeholder = @"请输入密码";
    userLogin.tag = 1;
    passWordFiled.delegate = self;
    passWordFiled.secureTextEntry = YES;
    [passWordIV addSubview:passWordFiled];
    if ([userDefault objectForKey:@"passWord"]) {
        passWordFiled.text = [NSString stringWithFormat:@"%@",[userDefault objectForKey:@"passWord"]];
    }
    UIButton *LoginBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    LoginBtn.tag = 1;
    [LoginBtn setFrame:CGRectMake(40, 300, self.view.frame.size.width-80, 40)];
    [LoginBtn setTitle:@"登  录" forState:UIControlStateNormal];
    [LoginBtn setBackgroundImage:[UIImage imageNamed:@"17"] forState:UIControlStateNormal];
    [LoginBtn setTintColor:[UIColor whiteColor]];
    [LoginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
//    [LoginBtn setBackgroundColor:[UIColor yellowColor]];
    [bgIV addSubview:LoginBtn];
    
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    forgetBtn.tag = 2;
    [forgetBtn setFrame:CGRectMake(self.view.frame.size.width/2-70, 375, 60, 30)];
    [forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetBtn setTintColor:[UIColor lightGrayColor]];
    [forgetBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [forgetBtn setBackgroundColor:[UIColor clearColor]];
    [bgIV addSubview:forgetBtn];
    
    UIView * iv = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2, 382, 1, 16)];
    [iv setBackgroundColor:[UIColor lightGrayColor]];
    [bgIV addSubview:iv];
    
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    registerBtn.tag = 3;
    [registerBtn setFrame:CGRectMake(self.view.frame.size.width/2+10,375, 60, 30)];
    [registerBtn setTitle:@"注册账号" forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [registerBtn setTintColor:[UIColor lightGrayColor]];
    [registerBtn setBackgroundColor:[UIColor clearColor]];
    [bgIV addSubview:registerBtn];
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [bgIV addGestureRecognizer:tapGr];
}

-(void)loginAction:(UIButton *)btn{
    switch (btn.tag) {
        case 1:
        {
//            NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
//            [userDefault setObject:userLogin.text forKey:@"userName"];
//            [userDefault setObject:passWordFiled.text forKey:@"passWord"];
//            [app bootMainViewController];
            if ([userLogin.text length]==0){
                [self doAlert:@"请输入手机号！"];
                [userLogin becomeFirstResponder];
                return;
            }
            else if ([passWordFiled.text length] == 0){
                [self doAlert:@"请输入密码！"];
                [passWordFiled becomeFirstResponder];
                return;
            }
            BZAppDelegate *app = [UIApplication sharedApplication].delegate;
            RequestUtil *requestUtil = [[RequestUtil alloc]init];
            //业务数据参数组织成JSON字符串
            NSString *pwdString = passWordFiled.text;
            pwdString = [self md5:pwdString];
            pwdString = [self md5:pwdString];
            NSString *biz = [NSString  stringWithFormat:@"{\"tel\":\"%@\",\"password\":\"%@\",\"registrationID\":\"%@\",\"lastLoginDeviceType\":\"1\"}",userLogin.text ,pwdString,app.registrationID];
            NSString *sid = @"loginService";
            [requestUtil startRequest:sid biz:biz send:self];
        }
            break;
        case 2:{
            FirstGetPasswordViewController * fv =[[FirstGetPasswordViewController alloc]init];
            [self.navigationController pushViewController:fv animated:YES];
        }
            break;
        case 3:
        {
            CATransition *transition = [CATransition animation];
            transition.duration = 1.f;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = @"oglFlip";
            transition.subtype = kCATransitionFromRight;
            transition.delegate = self;
            [self.navigationController.view.layer addAnimation:transition forKey:nil];
            RegisterViewController *rc = [[RegisterViewController alloc]init];
            rc.title = @"注册";
            [self.navigationController pushViewController:rc animated:YES];
        }
            break;
        default:
            break;
            
        
    }
}

-(void)requestStarted:(ASIHTTPRequest *)request{
    if ([activity isVisible] == NO) {
        [activity startAnimate:self];
    }
}

-(void)requestCompleted:(ASIHTTPRequest *)request{
    BZAppDelegate *app =[UIApplication sharedApplication].delegate;
    NSError *error;
    //获取接口总线返回的结果
    NSString *returnData = [request responseString];
    NSData *jsonData = [returnData dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    NSDictionary *biz = json[@"userinfo"];
    if (biz ) {
        app.userName = [biz[@"ownerName"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        app.userMobile = [NSString stringWithFormat:@"%@",biz[@"ownerTel"]];
        if (biz[@"email"]) {
            app.userEmail = [NSString stringWithFormat:@"%@",biz[@"email"]];
        }
        if (biz[@"ownerGender"]) {
            app.userSex =[NSString stringWithFormat:@"%@",biz[@"ownerGender"]];
        }
        if (biz[@"ownerIdCard"]) {
            app.userCardNum =[NSString stringWithFormat:@"%@",biz[@"ownerIdCard"]];
        }
        app.userID =biz[@"ownerId"];
        if ( biz[@"vallageId"]) {
            app.vallageID =[NSString stringWithFormat:@"%@",biz[@"vallageId"]];
        }
        if ( biz[@"vallageName"]) {
            app.vallageName =[NSString stringWithFormat:@"%@",biz[@"vallageName"]];
        }
        if ( biz[@"vallageTel"]) {
            app.vallageTel =[NSString stringWithFormat:@"%@",biz[@"vallageTel"]];
        }
        if ( biz[@"vallageTel"]) {
            app.seat =[NSString stringWithFormat:@"%@",biz[@"seat"]];
        }
        if ( biz[@"unit"]) {
            app.unit =[NSString stringWithFormat:@"%@",biz[@"unit"]];
        }
        if ( biz[@"house"]) {
            app.house =[NSString stringWithFormat:@"%@",biz[@"house"]];
        }
        if ( biz[@"affectionTel1"]) {
            app.affectionTel1 =[NSString stringWithFormat:@"%@",biz[@"affectionTel1"]];
        }
        if ( biz[@"affectionTel2"]) {
            app.affectionTel2 =[NSString stringWithFormat:@"%@",biz[@"affectionTel2"]];
        }
        if ( biz[@"affectionTel3"]) {
            app.affectionTel3 =[NSString stringWithFormat:@"%@",biz[@"affectionTel3"]];
        }
        if ( biz[@"unReadBarterNum"]) {
            app.unReadBarterNum =[biz[@"unReadBarterNum"] intValue];
//            app.unReadBarterNum  = 3;
        }
        if ( biz[@"unReadNeigNum"]) {
            app.unReadNeigNum =[biz[@"unReadNeigNum"] intValue];
//            app.unReadNeigNum = 6;
        }
    }
    if ([activity isVisible]) {
        [activity stopAcimate];
    }
    if ([json[@"status"]isEqualToString:@"success"]) {
        [SVProgressHUD showSuccessWithStatus:json[@"message"]];
        BZAppDelegate *app = [UIApplication sharedApplication].delegate;
        NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
        [userDefault setObject:userLogin.text forKey:@"userName"];
        [userDefault setObject:passWordFiled.text forKey:@"passWord"];
        [app bootMainViewController];
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

- (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result);
    return [[NSString stringWithFormat:
             @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] uppercaseString];
}

-(void)doAlert:(NSString *)inMessage {
    UIAlertView *alertDialog = [[UIAlertView alloc] initWithTitle:@"提示信息" message:inMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertDialog show];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 80;
    const float movementDuration = 0.3f;
    int movement = (up ? -movementDistance : movementDistance);
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [userLogin resignFirstResponder];
    [passWordFiled resignFirstResponder];
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
