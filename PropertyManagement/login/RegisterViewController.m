//
//  RegisterViewController.m
//  PropertyManagement
//
//  Created by admin on 14/11/12.
//  Copyright (c) 2014年 admin. All rights reserved.
//

#import "RegisterViewController.h"
#import "VersionAdapter.h"
#import "RequestUtil.h"
#import "ActivityView.h"
#import "SVProgressHUD.h"
#import "BZAppDelegate.h"
#import "NextRegisterViewController.h"
#import "VallegeViewController.h"
#import "Vallage1ViewController.h"

#import "Vallage.h"
#import "TableViewWithBlock.h"
#import "SelectionCell.h"
#import <QuartzCore/QuartzCore.h>

#pragma mark---------------协议--------------------
#import "BZProtocol.h"
#import "JKAlertDialog.h"


@interface RegisterViewController (){
    UITextField *userLogin;
    UITextField *passWordFiled;
    UITextField *rePassWordFiled;
    UITextField *cardFiled;
    ActivityView *activity;
    Vallage *val;
    UIButton *choose;
    UIButton *choose1;
    UITextField *dongFiled;
    UITextField *danFiled;
    UITextField *numFiled;
    
    BOOL isOpened;
    int fixType;
}

@property (nonatomic,strong)TableViewWithBlock *tb;
@property (nonatomic,strong)UITextField *text_Biaoti;
@property (nonatomic,strong)UIButton *biaoti_Btn;
@property (nonatomic,strong)NSArray *listTeams;
//协议内容参数
@property(nonatomic,copy)NSString *protocolText;


@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:147.0/255.0 green:147.0/255.0  blue:147.0/255.0  alpha:1.0]];
    [VersionAdapter setViewLayout:self];
    self.navigationController.navigationBarHidden = NO;
    
    fixType =1;
    [self createUI];
    [self createBack];
}
-(void)createUI{
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    activity = [[ActivityView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44 - [VersionAdapter getMoreVarHead]) loadStr:NSLocalizedString(@"正在加载...", nil)];
    
    
   UIScrollView* sv =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44-[VersionAdapter getMoreVarHead])];
    sv.userInteractionEnabled = YES;
    [sv setBackgroundColor:[UIColor colorWithRed:242.0/255.0 green:242.0/255.0  blue:242.0/255.0  alpha:1.0]];
    [sv setScrollEnabled:YES];
    [self.view addSubview:sv];

    
    UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 40)];
    [view1 setBackgroundColor:[UIColor whiteColor]];
    [sv addSubview:view1];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 60, 20)];
    label1.text = @"姓名:";
    label1.textAlignment =1;
    [label1 setFont:[UIFont fontWithName:nil size:14]];
    [view1 addSubview:label1];

    cardFiled =[[UITextField alloc]initWithFrame:CGRectMake(80, 5, self.view.frame.size.width-150, 30)];
    cardFiled.tag =0;
    cardFiled.placeholder = @"请输入姓名";
    cardFiled.delegate = self;
    [cardFiled setFont:[UIFont fontWithName:nil size:14]];
    [view1 addSubview:cardFiled];
    
    
    self.listTeams = [[NSArray alloc] initWithObjects:@"业主", @"租户", nil];
    self.biaoti_Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [ self.biaoti_Btn  setFrame:CGRectMake(self.view.frame.size.width-70, 0,  60, 40)];
    [ self.biaoti_Btn  addTarget:self action:@selector(changeOpenStatus:) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview: self.biaoti_Btn ];
    
    UIImageView *iv1 =[[UIImageView alloc]initWithFrame:CGRectMake(40, 10, 20, 20)];
    [iv1 setImage:[UIImage imageNamed:@"select.png"]];
    [self.biaoti_Btn addSubview:iv1];
    
    self.text_Biaoti = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
    [self.text_Biaoti setEnabled:NO];
    self.text_Biaoti.text = [NSString stringWithFormat:@"%@",self.listTeams[0]];
    [self.biaoti_Btn addSubview:self.text_Biaoti];
    
    _tb = [[TableViewWithBlock alloc]initWithFrame:CGRectMake(self.view.frame.size.width-70, 60, 60, 1)];
    [_tb initTableViewDataSourceAndDelegate:^(UITableView *tableView,NSInteger section){
        return 2;
    } setCellForIndexPathBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
        if (!cell) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"SelectionCell" owner:self options:nil]objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        [cell.lb setText:[NSString stringWithFormat:@"%@",[self.listTeams objectAtIndex:indexPath.row]]];
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    } setDidSelectRowBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=(SelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
        self.text_Biaoti.text=cell.lb.text;
        [_biaoti_Btn sendActionsForControlEvents:UIControlEventTouchUpInside];
        fixType = (int)indexPath.row+1;
    }];
    
    [_tb.layer setBorderColor:[UIColor clearColor].CGColor];
    [_tb.layer setBorderWidth:1];
    
    UIView * view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 62, self.view.frame.size.width, 40)];
    [view2 setBackgroundColor:[UIColor whiteColor]];
    [sv addSubview:view2];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 60, 20)];
    label2.text = @"账号:";
    label2.textAlignment =1;
    [label2 setFont:[UIFont fontWithName:nil size:14]];
    [view2 addSubview:label2];


    userLogin =[[UITextField alloc]initWithFrame:CGRectMake(80, 5, self.view.frame.size.width-80, 30)];
    userLogin.tag = 1;
    userLogin.placeholder = @"请输入手机号";
    userLogin.delegate = self;
    [userLogin setFont:[UIFont fontWithName:nil size:14]];
    [view2 addSubview:userLogin];
    
    
    UIView * view3 = [[UIView alloc]initWithFrame:CGRectMake(0, 104, self.view.frame.size.width, 40)];
    [view3 setBackgroundColor:[UIColor whiteColor]];
    [sv addSubview:view3];
    
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 60, 20)];
    label3.text = @"密码:";
    label3.textAlignment =1;
    [label3 setFont:[UIFont fontWithName:nil size:14]];
    [view3 addSubview:label3];

    passWordFiled =[[UITextField alloc]initWithFrame:CGRectMake(80, 5, self.view.frame.size.width-80, 30)];
    passWordFiled.tag =2;
    passWordFiled.placeholder = @"请输入6-8位密码";
    passWordFiled.delegate = self;
    passWordFiled.secureTextEntry = YES;
    [passWordFiled setFont:[UIFont fontWithName:nil size:14]];
    [view3 addSubview:passWordFiled];
    
    
    UIView * view4 = [[UIView alloc]initWithFrame:CGRectMake(0, 146, self.view.frame.size.width, 40)];
    [view4 setBackgroundColor:[UIColor whiteColor]];
    [sv addSubview:view4];
    
    UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 60, 20)];
    label4.text = @"重复密码:";
    label4.textAlignment =1;
    [label4 setFont:[UIFont fontWithName:nil size:14]];
    [view4 addSubview:label4];
    
    rePassWordFiled =[[UITextField alloc]initWithFrame:CGRectMake(80, 5, self.view.frame.size.width-80, 30)];
    rePassWordFiled.tag = 3;
    rePassWordFiled.placeholder = @"请确认密码";
    rePassWordFiled.delegate = self;
    rePassWordFiled.secureTextEntry = YES;
    [rePassWordFiled setFont:[UIFont fontWithName:nil size:14]];
    [view4 addSubview:rePassWordFiled];
    
    
    UIView * view5 = [[UIView alloc]initWithFrame:CGRectMake(0, 188, self.view.frame.size.width, 40)];
    [view5 setBackgroundColor:[UIColor whiteColor]];
    [sv addSubview:view5];
    
    UILabel *label5 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 60, 20)];
    label5.text = @"区域:";
    label5.textAlignment =1;
    [label5 setFont:[UIFont fontWithName:nil size:14]];
    [view5 addSubview:label5];
    
    choose = [UIButton buttonWithType:UIButtonTypeCustom];
    choose.tag = 1;
    [choose setFrame:CGRectMake(80, 5, self.view.frame.size.width-100, 30)];
    [choose setTitle:@"选择区域" forState:UIControlStateNormal];
    choose.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [choose addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];
    [choose setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [choose setBackgroundColor:[UIColor whiteColor]];
    choose.titleLabel.font=[UIFont fontWithName:nil size:14];

    [view5 addSubview:choose];

    UIView * view6 = [[UIView alloc]initWithFrame:CGRectMake(0, 230, self.view.frame.size.width, 40)];
    [view6 setBackgroundColor:[UIColor whiteColor]];
    [sv addSubview:view6];
    
    UILabel *label6 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 60, 20)];
    label6.text = @"小区:";
    label6.textAlignment =1;
    [label6 setFont:[UIFont fontWithName:nil size:14]];
    [view6 addSubview:label6];

    choose1 = [UIButton buttonWithType:UIButtonTypeCustom];
    choose1.tag = 2;
    choose1.titleLabel.font=[UIFont fontWithName:nil size:14];
    [choose1 setFrame:CGRectMake(80, 5, self.view.frame.size.width-100, 30)];
    [choose1 setTitle:@"选择小区" forState:UIControlStateNormal];
    [choose1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [choose1 setBackgroundColor:[UIColor whiteColor]];
    choose1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [choose1 addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];
    [view6 addSubview:choose1];
    
    UIView * view7 = [[UIView alloc]initWithFrame:CGRectMake(0, 272, self.view.frame.size.width, 40)];
    [view7 setBackgroundColor:[UIColor whiteColor]];
    [sv addSubview:view7];
    
    UILabel *label7 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 60, 20)];
    label7.text = @"楼/栋:";
    label7.textAlignment =1;
    [label7 setFont:[UIFont fontWithName:nil size:14]];
    [view7 addSubview:label7];
    
    dongFiled =[[UITextField alloc]initWithFrame:CGRectMake(80, 5, self.view.frame.size.width-80, 30)];
    dongFiled.tag = 3;
    dongFiled.placeholder = @"请输入楼/栋号";
    dongFiled.delegate = self;
    [dongFiled setFont:[UIFont fontWithName:nil size:14]];
    [view7 addSubview:dongFiled];
    
    
    UIView * view8 = [[UIView alloc]initWithFrame:CGRectMake(0, 314, self.view.frame.size.width, 40)];
    [view8 setBackgroundColor:[UIColor whiteColor]];
    [sv addSubview:view8];
    
    UILabel *label8 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 60, 20)];
    label8.text = @"单元号:";
    label8.textAlignment =1;
    [label8 setFont:[UIFont fontWithName:nil size:14]];
    [view8 addSubview:label8];
    
    danFiled =[[UITextField alloc]initWithFrame:CGRectMake(80, 5, self.view.frame.size.width-80, 30)];
    danFiled.tag = 9;
    danFiled.placeholder = @"请输入单元号";
    danFiled.delegate = self;
    [danFiled setFont:[UIFont fontWithName:nil size:14]];
    [view8 addSubview:danFiled];
    
    UIView * view9 = [[UIView alloc]initWithFrame:CGRectMake(0, 356, self.view.frame.size.width, 40)];
    [view9 setBackgroundColor:[UIColor whiteColor]];
    [sv addSubview:view9];
    
    UILabel *label9 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 60, 20)];
    label9.text = @"房号:";
    label9.textAlignment =1;
    [label9 setFont:[UIFont fontWithName:nil size:14]];
    [view9 addSubview:label9];
    
    numFiled =[[UITextField alloc]initWithFrame:CGRectMake(80, 5, self.view.frame.size.width-80, 30)];
    numFiled.tag = 9;
    numFiled.placeholder = @"请输入单元号";
    numFiled.delegate = self;
    [numFiled setFont:[UIFont fontWithName:nil size:14]];
    [view9 addSubview:numFiled];

    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.tag = 1;
    [nextBtn setFrame:CGRectMake(15, 400, self.view.frame.size.width-30, 40)];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"17"] forState:UIControlStateNormal];
    [sv addSubview:nextBtn];
    
    UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(15, 450, 20, 20)];
    [iv setImage:[UIImage imageNamed:@"agree.png"]];
    [sv addSubview:iv];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setFrame:CGRectMake(40, 450, 250, 20)];
    [btn1 addTarget:self action:@selector(agreeAction) forControlEvents:UIControlEventTouchUpInside];
    [sv addSubview:btn1];
    
    UILabel *agreeL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 250, 20)];
    agreeL.text =@"我已阅读并同意使用条款和隐私政策";
    [agreeL setFont:[UIFont fontWithName:nil size:14]];
    [agreeL setTextColor:[UIColor redColor]];
    agreeL.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cheekLable)];
    [agreeL addGestureRecognizer:tap];
    [btn1 addSubview:agreeL];
    
    [self.view addSubview:_tb];
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
    [userLogin setInputAccessoryView:topView];
    [passWordFiled setInputAccessoryView:topView];
    [rePassWordFiled setInputAccessoryView:topView];
    [cardFiled setInputAccessoryView:topView];
    [numFiled setInputAccessoryView:topView];
    [dongFiled setInputAccessoryView:topView];
    [danFiled setInputAccessoryView:topView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateOrg:) name:@"updateOrg" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateVallege:) name:@"updateVallege" object:nil];
    [sv setContentSize:CGSizeMake(self.view.frame.size.width, 470)];
    
}
#pragma mark-   用户责任协议

-(void)cheekLable{
    JKAlertDialog *alert = [[JKAlertDialog alloc] initWithTitle:@"用户须知" message:@""];
    UITextView *textV = [[UITextView alloc] initWithFrame:CGRectStandardize(alert.frame)];
    [textV setEditable:NO];
    BZProtocol *pro = [BZProtocol sharedManager];
    textV.text = pro.protocol2;
    textV.font = [UIFont fontWithName:@"Arial" size:15.0];
    alert.contentView = textV;
    [alert addButtonWithTitle:@"注册"];
    
    [alert show];
}

- (void) updateOrg: (NSNotification *) notification{
    val = [[Vallage alloc]init];
    NSDictionary * dic =[notification object];
    Vallage *va = [dic objectForKey:@"Vallage"];
    val.orgName = va.orgName;
    val.orgId = va.orgId;
    [choose setTitle:[NSString stringWithFormat:@"%@",val.orgName] forState:UIControlStateNormal];
    [choose1 setTitle:@"选择小区" forState:UIControlStateNormal];
}

#pragma mark- 更新小区信息
- (void) updateVallege: (NSNotification *) notification{
    NSDictionary * dic =[notification object];
    Vallage *va = [dic objectForKey:@"Vallage"];
    val.vallageName = va.vallageName;
    val.vallageId = va.vallageId;
    [choose1 setTitle:[NSString stringWithFormat:@"%@",val.vallageName] forState:UIControlStateNormal];
}


- (void)changeOpenStatus:(id)sender {
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
    CATransition *transition = [CATransition animation];
    transition.duration = 1.0f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = @"oglFlip";
    transition.subtype = kCATransitionFromRight;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
}

- (void) animateTextField: (UITextField*) textField up:(BOOL) up
{
    if (textField.tag >2) {
        int movementDistance = 0;
        if (textField.tag == 9) {
            movementDistance = 180;
        }else{
            movementDistance = 80;
        }
        const float movementDuration = 0.3f;
        int movement = (up ? -movementDistance : movementDistance);
        [UIView beginAnimations: @"anim" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        self.view.frame = CGRectOffset(self.view.frame, 0, movement);
        [UIView commitAnimations];
    }
}

-(void)dismissKeyBoard
{
    [userLogin resignFirstResponder];
    [passWordFiled resignFirstResponder];
    [rePassWordFiled resignFirstResponder];
    [cardFiled resignFirstResponder];
    [dongFiled resignFirstResponder];
    [danFiled resignFirstResponder];
    [numFiled resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)agreeAction{
    
}

-(void)chooseAction:(UIButton *)send{
    switch (send.tag) {
        case 1:{
            VallegeViewController *cv = [[VallegeViewController alloc]init];
            cv.type =@"1";
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:cv];
            [self presentViewController:navigationController animated:YES completion:^{
            }];
        }
            break;
        case 2:{
            if (val.orgId) {
                Vallage1ViewController *cv = [[Vallage1ViewController alloc]init];
                cv.type =@"1";
                cv.orgId =[NSString stringWithFormat:@"%@",val.orgId];
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:cv];
                [self presentViewController:navigationController animated:YES completion:^{
                }];
 
            }else{
                UIAlertView *alertDialog = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"请您先选择区域" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertDialog show];
            }
        }
            break;
        default:
            break;
    }
}


//注册
-(void)nextAction{
    if ([userLogin.text length]==0){
        [self doAlert:@"请输入手机号！"];
        [userLogin becomeFirstResponder];
        return;
    }
    else if (![self validateMobile:userLogin.text]){
        [self doAlert:@"请输入正确的手机号！"];
        [userLogin becomeFirstResponder];
        return;
    }

    else if ([passWordFiled.text length] == 0){
        [self doAlert:@"请输入密码！"];
        [passWordFiled becomeFirstResponder];
        return;
    }
    
    else if ([passWordFiled.text length] < 6){
        [self doAlert:@"请输入6-8位密码！"];
        [passWordFiled becomeFirstResponder];
        return;
    }
    
    else if ([passWordFiled.text length] > 6){
        [self doAlert:@"请输入6-8位密码！"];
        [passWordFiled becomeFirstResponder];
        return;
    }

    else if ([rePassWordFiled.text length] == 0){
        [self doAlert:@"请确认密码！"];
        [rePassWordFiled becomeFirstResponder];
        return;
    }
    else if (![passWordFiled.text isEqualToString:rePassWordFiled.text]){
        [self doAlert:@"两次密码不一致！"];
        [rePassWordFiled becomeFirstResponder];
        return;
    }
    else if (!val.orgId){
        [self doAlert:@"请选择区域！"];
        [rePassWordFiled becomeFirstResponder];
        return;
    }
    else if (!val.vallageId){
        [self doAlert:@"请选择小区！"];
        [rePassWordFiled becomeFirstResponder];
        return;
    }
    else if ([danFiled.text length] == 0){
        [self doAlert:@"请输入单元号！"];
        [rePassWordFiled becomeFirstResponder];
        return;
    }
    else if ([dongFiled.text length] == 0){
        [self doAlert:@"请输入楼栋号！"];
        [rePassWordFiled becomeFirstResponder];
        return;
    }
    else if ([numFiled.text length] == 0){
        [self doAlert:@"请输入房号！"];
        [rePassWordFiled becomeFirstResponder];
        return;
    }


    CATransition *transition = [CATransition animation];
    transition.duration = 1.f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = @"oglFlip";
    transition.subtype = kCATransitionFromRight;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    NextRegisterViewController *nrc = [[NextRegisterViewController alloc]init];
    nrc.mobile = [NSString stringWithFormat:@"%@",userLogin.text];
    nrc.passWord =[NSString stringWithFormat:@"%@",passWordFiled.text];
    nrc.userName =[NSString stringWithFormat:@"%@",cardFiled.text];
    nrc.vallegeId =[NSString stringWithFormat:@"%@",val.vallageId];
    nrc.unit =[NSString stringWithFormat:@"%@",danFiled.text];
    nrc.seat =[NSString stringWithFormat:@"%@",dongFiled.text];
    nrc.house =[NSString stringWithFormat:@"%@",numFiled.text];
    [self.navigationController pushViewController:nrc animated:YES];
    
//        else if (![self validateIdentityCard:cardFiled.text]){
//            [self doAlert:@"请输入正确的身份证！"];
//            [cardFiled becomeFirstResponder];
//            return;
//        }
//        else if ([emailFiled.text length] == 0){
//            [self doAlert:@"请输入邮箱地址！"];
//            [emailFiled becomeFirstResponder];
//            return;
//        }
//        else if (![self validateEmail:emailFiled.text]){
//            [self doAlert:@"请输入正确的邮箱地址！"];
//            [cardFiled becomeFirstResponder];
//            return;
//        }
//        else if (se == 0){
//            [self doAlert:@"请选择性别！"];
//            return;
//        }

//    RequestUtil *requestUtil = [[RequestUtil alloc]init];
//    //业务数据参数组织成JSON字符串
//    NSString *biz = [NSString  stringWithFormat:@"{\"username\":\"%@\",\"tel\":\"%@\",\"password\":\"%@\"}",cardFiled.text,userLogin.text,passWordFiled.text];
//    NSString *sid = @"RegistrationService";
//    [requestUtil startRequest:sid biz:biz send:self];
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
        [SVProgressHUD showSuccessWithStatus:json[@"msg"]];
        NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
        [userDefault setObject:userLogin.text forKey:@"userName"];
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
