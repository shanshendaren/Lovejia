//
//  PersonInfoSetViewController.m
//  PropertyManagement
//
//  Created by admin on 14/11/19.
//  Copyright (c) 2014年 admin. All rights reserved.
//

#import "PersonInfoSetViewController.h"
#import "VersionAdapter.h"
#import "BZAppDelegate.h"
#import "PersonTableViewCell.h"
#import "AdressTableViewCell.h"
#import "UserInfoChangeViewController.h"
#import "RequestUtil.h"
#import "ActivityView.h"
#import "SVProgressHUD.h"

#import "TableViewWithBlock.h"
#import "SelectionCell.h"
#import <QuartzCore/QuartzCore.h>



@interface PersonInfoSetViewController ()<UITextFieldDelegate>
{
    UIButton *b1;
    UIButton *b2;
    int sexType;
    UITextField *cardFiled;
    UITextField *nameFiled;
    UITextField *emailFiled;
    ActivityView *activity;
    BOOL isOpened;
}


@property (nonatomic,strong)TableViewWithBlock *tb;
@property (nonatomic,strong)UITextField *text_Biaoti;
@property (nonatomic,strong)UIButton *biaoti_Btn;
@property (nonatomic,strong)NSArray *listTeams;
@property (nonatomic,strong)UIButton * sexMen;
@property (nonatomic,strong)UIButton * sexWomen;

@end

@implementation PersonInfoSetViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    BZAppDelegate* app = (BZAppDelegate *)[UIApplication sharedApplication].delegate;
    [app.tabBar customTabBarHidden:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    // Do any additional setup after loading the view.
}

-(void)createUI{
    self.title = @"信息设置";
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:FONT_SIZE],NSFontAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];

    [VersionAdapter setViewLayout:self];
    BZAppDelegate *app =[UIApplication sharedApplication].delegate;
    UIView * viewY = [[UIView alloc]initWithFrame:self.view.frame];
    
    viewY.backgroundColor =  [UIColor colorWithWhite:0.98f alpha:1.0f];
    [self.view addSubview:viewY];
    sexType = 0;
    
    UIView * view1 =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    [view1 setBackgroundColor:[UIColor whiteColor]];
    [viewY addSubview: view1];
    
    UILabel *l1 =[[UILabel alloc]initWithFrame:CGRectMake(0, 5, 60, 20)];
    l1.textAlignment =1;
    l1.font =[UIFont fontWithName:@"Arial" size:FONT_SIZE];
    l1.text = @"姓名:";
    [view1 addSubview:l1];
    
    nameFiled =[[UITextField alloc]initWithFrame:CGRectMake(70, 5, self.view.frame.size.width - 100, 20)];
    nameFiled.delegate = self;
    [nameFiled setFont:[UIFont fontWithName:@"Arial" size:FONT_SIZE]];
    if (app.userName) {
        nameFiled.text =[NSString stringWithFormat:@"%@",app.userName];
    }
    [view1 addSubview:nameFiled];
    
    
    UIView * view2 =[[UIView alloc]initWithFrame:CGRectMake(0, 31, self.view.frame.size.width, 30)];
    [view2 setBackgroundColor:[UIColor whiteColor]];
    [viewY addSubview: view2];
    
    UILabel *l2 =[[UILabel alloc]initWithFrame:CGRectMake(0, 5, 60, 20)];
    l2.textAlignment =1;
    l2.font =[UIFont fontWithName:@"Arial" size:FONT_SIZE];
    l2.text = @"身份证号:";
    [view2 addSubview:l2];
    
    cardFiled =[[UITextField alloc]initWithFrame:CGRectMake(70, 5, self.view.frame.size.width - 100, 20)];
    [cardFiled setFont:[UIFont fontWithName:@"Arial" size:FONT_SIZE]];
    cardFiled.placeholder = @"请输入身份证号码";
    cardFiled.delegate = self;
    if (app.userCardNum) {
        cardFiled.text =[NSString stringWithFormat:@"%@",app.userCardNum];
    }
    [view2 addSubview:cardFiled];
    
    UIView * view3 =[[UIView alloc]initWithFrame:CGRectMake(0, 62, self.view.frame.size.width, 30)];
    [view3 setBackgroundColor:[UIColor whiteColor]];
    [viewY addSubview: view3];
    
    UILabel *l3 =[[UILabel alloc]initWithFrame:CGRectMake(0, 5, 60, 20)];
    l3.textAlignment =1;
    l3.font =[UIFont fontWithName:@"Arial" size:FONT_SIZE];
    l3.text = @"邮箱:";
    [view3 addSubview:l3];
    
    emailFiled =[[UITextField alloc]initWithFrame:CGRectMake(70, 5, self.view.frame.size.width - 100, 20)];
    [emailFiled setFont:[UIFont fontWithName:@"Arial" size:FONT_SIZE]];
    emailFiled.placeholder = @"例如:admin@admin.com";
    emailFiled.delegate =self;
    if (app.userEmail) {
        emailFiled.text =[NSString stringWithFormat:@"%@",app.userEmail];
    }
    [view3 addSubview:emailFiled];
    
    UIView * view4 =[[UIView alloc]initWithFrame:CGRectMake(0, 93, self.view.frame.size.width, 30)];
    [view4 setBackgroundColor:[UIColor whiteColor]];
    [viewY addSubview: view4];
    
    UILabel *l4 =[[UILabel alloc]initWithFrame:CGRectMake(0, 5, 60, 20)];
    l4.textAlignment =1;
    l4.font =[UIFont fontWithName:@"Arial" size:FONT_SIZE];
    l4.text = @"性别:";
    [view4 addSubview:l4];
    
    
    self.sexMen = [[UIButton alloc]initWithFrame:CGRectMake(75, 8, 15, 15)];
    [self.sexMen setBackgroundImage:[UIImage imageNamed:@"sex"] forState:UIControlStateNormal];
    [self.sexMen setBackgroundImage:[UIImage imageNamed:@"sexsel"] forState:UIControlStateSelected];
    self.sexMen.tag = 101;
    [self.sexMen addTarget:self action:@selector(sexButClick:) forControlEvents:UIControlEventTouchDown];
    UILabel * labelMen = [[UILabel alloc]initWithFrame:CGRectMake(100, 5, 50, 20)];
    labelMen.text = @"男";
    labelMen.font =[UIFont fontWithName:@"Arial" size:FONT_SIZE];
    [view4 addSubview:labelMen];
    
    [view4 addSubview:self.sexMen];
    
    self.sexWomen = [[UIButton alloc]initWithFrame:CGRectMake(160, 8, 15, 15)];
    [self.sexWomen setBackgroundImage:[UIImage imageNamed:@"sex"] forState:UIControlStateNormal];
    [self.sexWomen setBackgroundImage:[UIImage imageNamed:@"sexsel"] forState:UIControlStateSelected];
    self.sexWomen.tag = 102;
     [self.sexWomen addTarget:self action:@selector(sexButClick:) forControlEvents:UIControlEventTouchDown];
    
    UILabel * labelWomen = [[UILabel alloc]initWithFrame:CGRectMake(185, 5, 50, 20)];
    labelWomen.text = @"女";
    labelWomen.font =[UIFont fontWithName:@"Arial" size:FONT_SIZE];
    [view4 addSubview:labelWomen];

    [view4 addSubview:self.sexWomen];
    
        if ([app.userSex intValue]==1) {
            self.sexMen.selected =YES;
            sexType = 1;
        }
        if ([app.userSex intValue]==2){
            self.sexWomen.selected = YES;
            sexType = 2;
        }
    //TODO: 保存按钮
    UIButton *Savebtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 160, self.view.frame.size.width-60, 30)];
    [Savebtn setBackgroundImage:[UIImage imageNamed:@"17"] forState:UIControlStateNormal];
    [Savebtn setTitle:@"保存" forState:UIControlStateNormal];
    [Savebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    Savebtn.titleLabel.font = [UIFont fontWithName:@"Arial" size:FONT_SIZE];
    [Savebtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    [viewY addSubview:Savebtn];

    [self createBack];
    activity = [[ActivityView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44 - [VersionAdapter getMoreVarHead]) loadStr:NSLocalizedString(@"正在加载...", nil)];

}


-(void)sexButClick:(UIButton *)button{
   NSInteger i = button.tag;
    if (i == 101) {
        self.sexMen.selected = YES;
        self.sexWomen.selected = NO;
        sexType = 1;
    }else{
        self.sexMen.selected = NO;
        self.sexWomen.selected = YES;
        sexType = 2;
    }
    
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)changeOpenStatus:(id)sender {
    //[self.text_neirong setEditable:NO];
    if (isOpened) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame=_tb.frame;
            frame.size.height=1;
            [_tb setFrame:frame];
            [_tb.layer setBorderColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0  blue:245.0/255.0  alpha:1.0].CGColor];
        } completion:^(BOOL finished){
            isOpened=NO;
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame=_tb.frame;
            frame.size.height=60;
            [_tb setFrame:frame];
            [_tb.layer setBorderColor:[UIColor grayColor].CGColor];
            
        } completion:^(BOOL finished){
            //[self.tap setEnabled:YES];
            isOpened=YES;
        }];
    }
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
    [self dismissViewControllerAnimated:NO completion:^{
    }];
//    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [cardFiled resignFirstResponder];
    [emailFiled resignFirstResponder];
    [nameFiled resignFirstResponder];
}
//保存信息
-(void)saveAction{
     if ([nameFiled.text length] == 0){
        [self doAlert:@"请输入姓名！"];
        [nameFiled becomeFirstResponder];
        return;
    }

    else if (![self validateIdentityCard:cardFiled.text]){
        [self doAlert:@"请输入正确的身份证！"];
        [cardFiled becomeFirstResponder];
        return;
    }
    else if ([cardFiled.text length] == 0){
        [self doAlert:@"请输入身份证号码！"];
        [emailFiled becomeFirstResponder];
        return;
    }

    else if ([emailFiled.text length] == 0){
        [self doAlert:@"请输入邮箱地址！"];
        [emailFiled becomeFirstResponder];
        return;
    }
    else if (![self validateEmail:emailFiled.text]){
        [self doAlert:@"请输入正确的邮箱地址！"];
        [cardFiled becomeFirstResponder];
        return;
    }
    else if (sexType == 0){
        [self doAlert:@"请选择性别！"];
        return;
    }
    BZAppDelegate *app =[UIApplication sharedApplication].delegate;
    RequestUtil *requestUtil = [[RequestUtil alloc]init];
    //业务数据参数组织成JSON字符串
    NSString *biz = [NSString  stringWithFormat:@"{\"userId\":\"%@\",\"userName\":\"%@\",\"email\":\"%@\",\"IDCard\":\"%@\",\"gender\":\"%d\"}",app.userID,nameFiled.text,emailFiled.text,cardFiled.text,sexType];
    NSString *sid = @"UpdateUserInfo";
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
        BZAppDelegate *app =[UIApplication sharedApplication].delegate;
        app.userName = [NSString stringWithFormat:@"%@",nameFiled.text];
        app.userEmail = [NSString stringWithFormat:@"%@",emailFiled.text];
        app.userCardNum = [NSString stringWithFormat:@"%@",cardFiled.text];
        app.userSex = [NSString stringWithFormat:@"%d",sexType];
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


//验证邮箱
- (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//验证身份证
-(BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
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
