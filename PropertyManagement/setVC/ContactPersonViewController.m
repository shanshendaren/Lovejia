//
//  ContactPersonViewController.m
//  PropertyManagement
//
//  Created by admin on 15/2/11.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "ContactPersonViewController.h"
#import "VersionAdapter.h"
#import "BZAppDelegate.h"
#import "RequestUtil.h"
#import "ActivityView.h"
#import "SVProgressHUD.h"


@interface ContactPersonViewController (){
    UITextField *affectionTel1;
    UITextField *affectionTel2;
    UITextField *affectionTel3;
    ActivityView *activity;
}

@end

@implementation ContactPersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"亲情号码";
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    [VersionAdapter setViewLayout:self];
    
    activity = [[ActivityView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44 - [VersionAdapter getMoreVarHead]) loadStr:NSLocalizedString(@"正在加载...", nil)];

    
    [self.view setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0  blue:238.0/255.0  alpha:1.0]];
    BZAppDelegate *app =[UIApplication sharedApplication].delegate;
    UIView * view1 =[[UIView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 40)];
    [view1 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview: view1];
    
    UILabel *l1 =[[UILabel alloc]initWithFrame:CGRectMake(0, 10, 80, 20)];
    l1.textAlignment =1;
    l1.font =[UIFont fontWithName:nil size:13];
    l1.text = @"亲属号码1";
    [view1 addSubview:l1];
    
    affectionTel1 =[[UITextField alloc]initWithFrame:CGRectMake(90, 5, self.view.frame.size.width - 100, 30)];
    [affectionTel1 setFont:[UIFont fontWithName:nil size:13]];
    if (app.affectionTel1) {
        affectionTel1.text =[NSString stringWithFormat:@"%@",app.affectionTel1];
    }
    [view1 addSubview:affectionTel1];
    
    
    UIView * view2 =[[UIView alloc]initWithFrame:CGRectMake(0, 70, self.view.frame.size.width, 40)];
    [view2 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview: view2];
    
    UILabel *l2 =[[UILabel alloc]initWithFrame:CGRectMake(0, 10, 80, 20)];
    l2.textAlignment =1;
    l2.font =[UIFont fontWithName:nil size:13];
    l2.text = @"亲属号码2";
    [view2 addSubview:l2];
    
    affectionTel2 =[[UITextField alloc]initWithFrame:CGRectMake(90, 5, self.view.frame.size.width - 100, 30)];
    [affectionTel2 setFont:[UIFont fontWithName:nil size:13]];
    if (app.affectionTel2) {
        affectionTel2.text =[NSString stringWithFormat:@"%@",app.affectionTel2];
    }
    [view2 addSubview:affectionTel2];
    
    UIView * view3 =[[UIView alloc]initWithFrame:CGRectMake(0, 120, self.view.frame.size.width, 40)];
    [view3 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview: view3];
    
    UILabel *l3 =[[UILabel alloc]initWithFrame:CGRectMake(0, 10, 80, 20)];
    l3.textAlignment =1;
    l3.font =[UIFont fontWithName:nil size:13];
    l3.text = @"亲属号码3";
    [view3 addSubview:l3];
    
    affectionTel3 =[[UITextField alloc]initWithFrame:CGRectMake(90, 5, self.view.frame.size.width - 100, 30)];
    [affectionTel3 setFont:[UIFont fontWithName:nil size:13]];
    if (app.affectionTel3) {
        affectionTel3.text =[NSString stringWithFormat:@"%@",app.affectionTel3];
    }
    [view3 addSubview:affectionTel3];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.tag = 1;
    [nextBtn setFrame:CGRectMake(15, 250, self.view.frame.size.width-30, 40)];
    [nextBtn setTitle:@"保存" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"next_button_bg.png"] forState:UIControlStateNormal];
    [self.view addSubview:nextBtn];
    
    UILabel *infLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 180, self.view.frame.size.width, 20)];
    infLabel.textAlignment =1;
    infLabel.textColor =[UIColor redColor];
    infLabel.font =[UIFont fontWithName:nil size:15];
    infLabel.text = @"设置亲情号码，方便一键求助时短信及时联系";
    [self.view addSubview:infLabel];

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
    [affectionTel1 setInputAccessoryView:topView];
    [affectionTel2 setInputAccessoryView:topView];
    [affectionTel3 setInputAccessoryView:topView];

}


-(void)dismissKeyBoard
{
    [affectionTel1 resignFirstResponder];
    [affectionTel2 resignFirstResponder];
    [affectionTel3 resignFirstResponder];
}

-(void)nextAction{
    
    if (![self validateMobile:affectionTel1.text] && affectionTel1.text.length > 0){
        [self doAlert:@"请输入正确的手机号！"];
        [affectionTel1 becomeFirstResponder];
        return;
    }
    if (![self validateMobile:affectionTel2.text] && affectionTel2.text.length >0){
        [self doAlert:@"请输入正确的手机号！"];
        [affectionTel2 becomeFirstResponder];
        return;
    }

    if (![self validateMobile:affectionTel3.text] && affectionTel3.text.length > 0){
        [self doAlert:@"请输入正确的手机号！"];
        [affectionTel3 becomeFirstResponder];
        return;
    }
    RequestUtil *requestUtil = [[RequestUtil alloc]init];
    //业务数据参数组织成JSON字符串
    BZAppDelegate *app =[UIApplication sharedApplication].delegate;
    NSString *biz = [NSString  stringWithFormat:@"{\"userId\":\"%@\",\"affectionTel1\":\"%@\",\"affectionTel2\":\"%@\",\"affectionTel3\":\"%@\"}",app.userID,affectionTel1.text,affectionTel2.text,affectionTel3.text];
    NSString *sid = @"UpdateUserAffectionTel";
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
        BZAppDelegate *app =[UIApplication sharedApplication].delegate;
        app.affectionTel1 = [NSString stringWithFormat:@"%@",affectionTel1.text];
        app.affectionTel2 = [NSString stringWithFormat:@"%@",affectionTel2.text];
        app.affectionTel3 = [NSString stringWithFormat:@"%@",affectionTel3.text];
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

//验证手机号
- (BOOL) validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}


-(void)doAlert:(NSString *)inMessage {
    UIAlertView *alertDialog = [[UIAlertView alloc] initWithTitle:@"提示信息" message:inMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertDialog show];
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
    //    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
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
