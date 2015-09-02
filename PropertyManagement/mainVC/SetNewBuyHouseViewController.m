//
//  SetNewBuyHouseViewController.m
//  PropertyManagement
//
//  Created by admin on 15/2/27.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "SetNewBuyHouseViewController.h"
#import "VersionAdapter.h"
#import "CommonUtil.h"
#import "RequestUtil.h"
#import "BZAppDelegate.h"
#import "SVProgressHUD.h"
#import "ActivityView.h"


@interface SetNewBuyHouseViewController ()<UITextFieldDelegate,UITextViewDelegate>
{
    UIImageView *iv;
    NSString *picPath;
    ActivityView *activity;
    int changeType;
    CGFloat Y;
    BOOL isOpened;
}

@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray *photoArray;
@property (nonatomic,strong)UITextField *titleTextField;
@property (nonatomic,strong)UITextField *typeTextField;
@property (nonatomic,strong)UITextField *priceTextField;
@property (nonatomic,strong)UITextField *addTextField;
@property (nonatomic,strong)UITextView *describeTextField;
@property (nonatomic,strong)UITextView *text_neirong;
@property (nonatomic,strong)UITapGestureRecognizer *tap;//单击手势
@property (nonatomic,strong)UITextField *text_type;
@property (nonatomic,strong)UIButton *type_btn;
@property (nonatomic,strong)NSArray *listTeams;

@end

@implementation SetNewBuyHouseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [VersionAdapter setViewLayout:self];
    [self.view setBackgroundColor:[UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.0]];
    
    self.title = @"买房信息";
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    [self createBack];
    
    UIScrollView * sv =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 60-44-[VersionAdapter getMoreVarHead])];
    [sv setUserInteractionEnabled:YES];
    [self.view addSubview:sv];
    
    activity = [[ActivityView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44 - [VersionAdapter getMoreVarHead]) loadStr:NSLocalizedString(@"正在加载...", nil)];

    Y = 0;
    UIView *back_one = [[UIView alloc]initWithFrame:CGRectMake(0, Y+10, self.view.frame.size.width, 44)];
    [back_one setBackgroundColor:[UIColor whiteColor]];
    [sv addSubview:back_one];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 44)];
    titleLabel.text = @"标题";
    titleLabel.textAlignment = 1;
    titleLabel.backgroundColor = [UIColor whiteColor];
    [back_one addSubview:titleLabel];
    
    UIImageView *lineView = [[UIImageView alloc]initWithFrame:CGRectMake(40, 4, 1, 36)];
    [lineView setImage:[UIImage imageNamed:@"line.png"]];
    [back_one addSubview:lineView];
    
    self.titleTextField = [[UITextField alloc]initWithFrame:CGRectMake(44, 0, self.view.frame.size.width - 44, 44)];
    [self.titleTextField setBackgroundColor:[UIColor whiteColor]];
    self.titleTextField.placeholder = @"请输入";
    [back_one addSubview:self.titleTextField];
    Y = back_one.frame.size.height + back_one.frame.origin.y + 10;
    
    //类型
    UIView *back_two = [[UIView alloc]initWithFrame:CGRectMake(0, Y, self.view.frame.size.width, 44)];
    [back_two setBackgroundColor:[UIColor whiteColor]];
    [sv addSubview:back_two];
    
    UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 44)];
    typeLabel.text = @"房型";
    typeLabel.textAlignment = 1;
    typeLabel.backgroundColor = [UIColor whiteColor];
    [back_two addSubview:typeLabel];
    
    UIImageView *lView = [[UIImageView alloc]initWithFrame:CGRectMake(40, 4, 1, 36)];
    [lView setImage:[UIImage imageNamed:@"line.png"]];
    [back_two addSubview:lView];
    
    self.typeTextField = [[UITextField alloc]initWithFrame:CGRectMake(44, 0, self.view.frame.size.width - 44, 44)];
    [self.typeTextField setBackgroundColor:[UIColor whiteColor]];
    self.typeTextField.placeholder = @"请输入";
    [back_two addSubview:self.typeTextField];
    
    
    Y = back_two.frame.size.height + back_two.frame.origin.y + 10;
    
    
    //地址
    UIView *back_three = [[UIView alloc]initWithFrame:CGRectMake(0, Y, self.view.frame.size.width, 44)];
    [back_three setBackgroundColor:[UIColor whiteColor]];
    [sv addSubview:back_three];
    
    UILabel *addLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 44)];
    addLabel.text = @"地址";
    addLabel.textAlignment = 1;
    addLabel.backgroundColor = [UIColor whiteColor];
    [back_three addSubview:addLabel];
    
    UIImageView *addView = [[UIImageView alloc]initWithFrame:CGRectMake(40, 4, 1, 36)];
    [addView setImage:[UIImage imageNamed:@"line.png"]];
    [back_three addSubview:addView];
    
    self.addTextField = [[UITextField alloc]initWithFrame:CGRectMake(44, 0, self.view.frame.size.width - 44, 44)];
    [self.addTextField setBackgroundColor:[UIColor whiteColor]];
    self.addTextField.placeholder = @"请输入";
    self.addTextField.delegate = self;
    self.addTextField.tag = 4;
    [back_three addSubview:self.addTextField];
    
    Y = back_three.frame.size.height + back_three.frame.origin.y + 10;
    
    
    //价格
    UIView *back_four = [[UIView alloc]initWithFrame:CGRectMake(0, Y, self.view.frame.size.width, 44)];
    [back_four setBackgroundColor:[UIColor whiteColor]];
    [sv addSubview:back_four];
    
    UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 44)];
    priceLabel.text = @"价格";
    priceLabel.textAlignment = 1;
    priceLabel.backgroundColor = [UIColor whiteColor];
    [back_four addSubview:priceLabel];
    
    UIImageView *priceView = [[UIImageView alloc]initWithFrame:CGRectMake(40, 4, 1, 36)];
    [priceView setImage:[UIImage imageNamed:@"line.png"]];
    [back_four addSubview:priceView];
    
    self.priceTextField = [[UITextField alloc]initWithFrame:CGRectMake(44, 0, self.view.frame.size.width - 44, 44)];
    [self.priceTextField setBackgroundColor:[UIColor whiteColor]];
    self.priceTextField.placeholder = @"请输入";
    self.priceTextField.tag = 3;
    self.priceTextField.delegate = self;
    [back_four addSubview:self.priceTextField];
    
    Y = back_four.frame.size.height + back_four.frame.origin.y + 10;
    
    //描述
    UIView *back_five = [[UIView alloc]initWithFrame:CGRectMake(0, Y, self.view.frame.size.width, 160)];
    [back_five setBackgroundColor:[UIColor whiteColor]];
    [sv addSubview:back_five];
    UILabel *label_two = [[UILabel alloc]initWithFrame:CGRectMake(0,0, 40, 160)];
    label_two.text = @"描述:";
    label_two.textAlignment = 1;
    [back_five addSubview:label_two];
    UIImageView *llView = [[UIImageView alloc]initWithFrame:CGRectMake(40, 4, 1, 152)];
    [llView setImage:[UIImage imageNamed:@"line.png"]];
    [back_five addSubview:llView];
    self.text_neirong = [[UITextView alloc]initWithFrame:CGRectMake(44, 0,self.view.frame.size.width- 44 ,160)];
    self.text_neirong.delegate = self;
    [back_five addSubview:self.text_neirong ];
    
    [sv setContentSize:CGSizeMake(self.view.frame.size.width, Y +165)];
    //发布
    UIImageView *backView = [[UIImageView alloc]init];
    backView.userInteractionEnabled = YES;
   backView.backgroundColor = [UIColor whiteColor];
    backView.frame = CGRectMake(0, self.view.frame.size.height - 60-44-[VersionAdapter getMoreVarHead]+10, self.view.frame.size.width, 60);
    [self.view addSubview:backView];
    
    UIButton * btn1 =[UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setFrame:CGRectMake(60, 15, 200, 30)];
    
    [btn1 setTitle:@"发布" forState:UIControlStateNormal];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"17"] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(cilckAction) forControlEvents:UIControlEventTouchUpInside];
   [backView addSubview:btn1];
    
    //定义键盘
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    [view setBackgroundColor:[UIColor grayColor]];
    UIButton *downBtn = [[UIButton alloc]initWithFrame:CGRectMake(280, 0, 40, 30)];
    [downBtn setTitle:@"完成" forState:UIControlStateNormal];
    [downBtn addTarget:self action:@selector(downKb:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:downBtn];
    [self.titleTextField setInputAccessoryView:view];
    [self.typeTextField setInputAccessoryView:view];
    [self.text_neirong setInputAccessoryView:view];
    [self.addTextField setInputAccessoryView:view];
    [self.priceTextField setInputAccessoryView:view];
    
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
        int movementDistance = 120;
        const float movementDuration = 0.3f;
        int movement = (up ? -movementDistance : movementDistance);
        [UIView beginAnimations: @"anim" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        self.view.frame = CGRectOffset(self.view.frame, 0, movement);
        [UIView commitAnimations];
    }
}


-(void)downKb:(UIButton *)sender
{
    [self.text_neirong resignFirstResponder];
    [self.titleTextField resignFirstResponder];
    [self.typeTextField resignFirstResponder];
    [self.priceTextField resignFirstResponder];
    [self.addTextField resignFirstResponder];
    CGRect curFrame = self.view.frame;
    [UIView animateWithDuration:0.3f animations:^{
        self.view.frame=CGRectMake(0, self.navigationController.navigationBar.frame.size.height + [VersionAdapter getMoreVarHead], curFrame.size.width, curFrame.size.height);
    }];
}


-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [self.tap setEnabled:YES];
    CGRect curFrame = self.view.frame;
    [UIView animateWithDuration:0.3f animations:^{
        self.view.frame=CGRectMake(0, self.navigationController.navigationBar.frame.size.height + [VersionAdapter getMoreVarHead] - self.text_neirong.frame.size.height - 60, curFrame.size.width, curFrame.size.height);
    }];
}


-(void)cilckAction{
    if ([self.titleTextField.text isEqualToString:@""]) {
        UIAlertView *view =[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请输入标题" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [view show];
        return;
    }
    if ([self.text_neirong.text isEqualToString:@""]) {
        UIAlertView *view =[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请描述该房子" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [view show];
        return;
    }
    
    if ([self.addTextField.text isEqualToString:@""]) {
        UIAlertView *view =[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请输入地址" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [view show];
        return;
    }
    if ([self.priceTextField.text isEqualToString:@""]) {
        UIAlertView *view =[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请输入价格" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [view show];
        return;
    }
    BZAppDelegate *app =[UIApplication sharedApplication].delegate;
    RequestUtil *requestUtil = [[RequestUtil alloc]init];
    NSString *biz = [NSString  stringWithFormat:@"{\"userId\":\"%@\",\"title\":\"%@\",\"content\":\"%@\",\"houseType\":\"%@\",\"houseAddress\":\"%@\",\"housePrice\":\"%@\",\"saleType\":\"1\",\"vallageId\":\"%@\"}",app.userID ,self.titleTextField.text,self.text_neirong.text,self.typeTextField.text,self.addTextField.text,self.priceTextField.text,app.vallageID];
    NSString *sid = @"SaveSecondarysaleInfoInfoOfPurchase";
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
        [self.navigationController popToRootViewControllerAnimated:YES];
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
