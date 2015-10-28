//
//  HousekeepServiceViewController.m
//  PropertyManagement
//
//  Created by iosMac on 15/1/28.
//  Copyright (c) 2015年 iosMac. All rights reserved.
//

#import "HousekeepServiceViewController.h"
#import "BZAppDelegate.h"
#import "RequestUtil.h"
#import "ActivityView.h"
#import "SVProgressHUD.h"
#import "VersionAdapter.h"
#import "TableViewWithBlock.h"
#import "SelectionCell.h"
#import <QuartzCore/QuartzCore.h>

@interface HousekeepServiceViewController (){
    BOOL isOpened;
    int complainType;
    UITextField *complainTitle;
    UITextView * contentView;
    UITextField * time1;
    ActivityView *activity;
}

@property (nonatomic,strong)TableViewWithBlock *tb;
@property (nonatomic,strong)UITextField *text_Biaoti;
@property (nonatomic,strong)UIButton *biaoti_Btn;
@property (nonatomic,strong)NSArray *listTeams;
@end

@implementation HousekeepServiceViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    BZAppDelegate* app = (BZAppDelegate *)[UIApplication sharedApplication].delegate;
    [app.tabBar customTabBarHidden:YES];
//    [app.tabBar tabBarHidden:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    RequestUtil *request =[[RequestUtil alloc]init];
    NSString * str =@"JZFW";
    NSString *biz = [NSString  stringWithFormat:@"{\"type\":\"%@\"}",str];
    NSString *sid = @"Sysdiclist";
    [request startRequest:sid biz:biz send:self];
    [self createUI];
    // Do any additional setup after loading the view.
}

-(void)createUI{
    [VersionAdapter setViewLayout:self];
    [self.view setBackgroundColor:[UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.0]];
    
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:FONT_SIZE],NSFontAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    self.title = @"家政服务";
    complainType =1;
    
    UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 35)];
    [view1 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view1];
    
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(95, 7, 1, 20)];
    [line1 setBackgroundColor:LINECOLOR];
    [view1 addSubview:line1];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 35)];
    titleLabel.text = @"标题";
    [titleLabel setFont:[UIFont fontWithName:@"Arial" size:FONT_SIZE]];
    [titleLabel setTextColor:[UIColor blackColor]];
    [view1 addSubview:titleLabel];
    
    complainTitle =[[UITextField alloc]initWithFrame:CGRectMake(100, 0, self.view.frame.size.width-110, 40)];
    complainTitle.font = [UIFont systemFontOfSize:FONT_SIZE];
    complainTitle.placeholder = @"请输入标题";
    [view1 addSubview:complainTitle];
    
    UIView * view3 = [[UIView alloc]initWithFrame:CGRectMake(0, 72, self.view.frame.size.width, 200)];
    [view3 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view3];
    
    UILabel *infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, 80, 40)];
    infoLabel.text = @"说明";
    [infoLabel setFont:[UIFont fontWithName:@"Arial" size:FONT_SIZE]];
    [view3 addSubview:infoLabel];
    
    UIView * line3 = [[UIView alloc]initWithFrame:CGRectMake(95, 10, 1, 180)];
    [line3 setBackgroundColor:LINECOLOR];
    [view3 addSubview:line3];
    
    contentView= [[UITextView  alloc] initWithFrame:CGRectMake(100, 0, self.view.frame.size.width-110, 200)] ; //初始化大小
    contentView.tag = 2;
    [contentView setBackgroundColor:[UIColor clearColor]];
    contentView.font = [UIFont fontWithName:@"Arial" size:FONT_SIZE];//设置字体名字和字体大小
    [contentView setEditable:YES];
    contentView.scrollEnabled = YES;//是否可以拖动
    contentView.textColor = [UIColor blackColor];
    [view3 addSubview: contentView];
    
    UIView * view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 36, self.view.frame.size.width, 35)];
    [view2 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view2];
    
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(95, 7, 1, 20)];
    [line2 setBackgroundColor:LINECOLOR];
    [view2 addSubview:line2];
    
    UILabel *complainLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 35)];
    complainLabel.text = @"服务类型";
    [complainLabel setFont:[UIFont fontWithName:@"Arial" size:FONT_SIZE]];
    [view2 addSubview:complainLabel];
    
    self.biaoti_Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [ self.biaoti_Btn  setFrame:CGRectMake(100, 0,  self.view.frame.size.width-110, 35)];
    [ self.biaoti_Btn  addTarget:self action:@selector(changeOpenStatus:) forControlEvents:UIControlEventTouchUpInside];
    [view2 addSubview: self.biaoti_Btn ];
    
    UIImageView *iv =[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-110, 25, 10, 10)];
    [iv setImage:[UIImage imageNamed:@"select.png"]];
    [self.biaoti_Btn addSubview:iv];
    
//    contentView = [[UITextView alloc]initWithFrame:CGRectMake(0, 56, self.view.frame.size.width, 200)];
//    contentView.backgroundColor = [UIColor whiteColor];
//    contentView.delegate = self;
//    [self.view addSubview:contentView];
//    
//    UIView * view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 265, self.view.frame.size.width, 40)];
//    [view2 setBackgroundColor:[UIColor whiteColor]];
//    [self.view addSubview:view2];
//    
//    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(105, 10, 1, 20)];
//    [line2 setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0  blue:238.0/255.0  alpha:1.0]];
//    [view2 addSubview:line2];
//    
//    UILabel * timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 80, 40)];
//    timeLabel.text = @"处理时间";
//    [timeLabel setTextColor:[UIColor blackColor]];
//    [timeLabel setFont:[UIFont fontWithName:nil size:18]];
//
//    [view2 addSubview:timeLabel];
//    
//    time1 =[[UITextField alloc]initWithFrame:CGRectMake(110, 0, self.view.frame.size.width-110, 40)];
//
//    [view2 addSubview:time1];

    self.text_Biaoti = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-110, 40)];
    [self.text_Biaoti setEnabled:NO];
    self.text_Biaoti.font = [UIFont systemFontOfSize:FONT_SIZE];
    [self.biaoti_Btn addSubview:self.text_Biaoti];
    
    _tb = [[TableViewWithBlock alloc]initWithFrame:CGRectMake(110, 70, self.view.frame.size.width-140, 0.5)];
    [_tb initTableViewDataSourceAndDelegate:^(UITableView *tableView,NSInteger section){
        return (int)self.listTeams.count;
    } setCellForIndexPathBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
        if (!cell) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"SelectionCell" owner:self options:nil]objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        

        [cell.lb setText:[NSString stringWithFormat:@"%@",[[self.listTeams objectAtIndex:indexPath.row]objectForKey:@"chname"]]];
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    } setDidSelectRowBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=(SelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
        self.text_Biaoti.text=cell.lb.text;
        [_biaoti_Btn sendActionsForControlEvents:UIControlEventTouchUpInside];
        complainType = (int)indexPath.row+1;
    }];
    
    [_tb.layer setBorderColor:[UIColor clearColor].CGColor];
    [_tb.layer setBorderWidth:1];
    [self.view addSubview:_tb];
    [self.view bringSubviewToFront:_tb];
    
    
//    UIButton *comBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    comBtn.tag = 1;
//    UIView * btnView = [[UIView alloc]initWithFrame:CGRectMake(10, self.view.frame.size.height-140, self.view.frame.size.width-20, 40)];
//    btnView.backgroundColor = [UIColor redColor];
//    [comBtn setFrame:CGRectMake(0, 0, btnView.frame.size.width, btnView.frame.size.height)];
//    [comBtn setBackgroundImage:[UIImage imageNamed:@"17"] forState:UIControlStateNormal];
//    [comBtn setTitle:@"确定" forState:UIControlStateNormal];
//    [comBtn addTarget:self action:@selector(cilick) forControlEvents:UIControlEventTouchUpInside];
//
//
//    [self.view addSubview:btnView];
//    
//    [btnView addSubview:comBtn];
    
    activity = [[ActivityView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44 - [VersionAdapter getMoreVarHead]) loadStr:NSLocalizedString(@"正在加载...", nil)];
    
    
    UIButton *comBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    comBtn.titleLabel.font =[UIFont systemFontOfSize:FONT_SIZE];
    comBtn.tag = 1;
    [comBtn setFrame:CGRectMake(30, self.view.frame.size.height-140, self.view.frame.size.width-60, 35)];
    [comBtn setBackgroundImage:[UIImage imageNamed:@"17"] forState:UIControlStateNormal];
    [comBtn setTitle:@"确定" forState:UIControlStateNormal];
    [comBtn addTarget:self action:@selector(cilick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:comBtn];
    [self createBack];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
   [textField resignFirstResponder];
    return YES;
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
//     [self.navigationController popViewControllerAnimated:NO];
}

-(void)cilick{
    BZAppDelegate *app =[UIApplication sharedApplication].delegate;
    RequestUtil *requestUtil = [[RequestUtil alloc]init];
    if (complainTitle.text.length == 0) {
        [self doAlert:@"请输入标题"];
        [complainTitle becomeFirstResponder];
        return;
        
    }
    else if (contentView.text.length == 0){
        [self doAlert:@"请输入标题"];
        [contentView becomeFirstResponder];
        return;
    }
    
    else if (complainTitle.text.length > 25){
        [self doAlert:@"标题过长"];
        [complainTitle becomeFirstResponder];
        return;
    }
    else if (contentView.text.length > 250){
        [self doAlert:@"内容过长"];
        [contentView becomeFirstResponder];
        return;
    }
    //业务数据参数组织成JSON字符串
    NSString *biz = [NSString  stringWithFormat:@"{\"userId\":\"%@\",\"title\":\"%@\",\"detail\":\"%@\",\"type\":\"%d\"}",app.userID,complainTitle.text ,contentView.text,complainType];
    NSString *sid = @"SaveHouseService";
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
        if (json[@"listInfo"]){
            self.listTeams = json[@"listInfo"];

            [_tb reloadData];
        }else{
        [SVProgressHUD showSuccessWithStatus:json[@"message"]];
        [self dismissViewControllerAnimated:NO completion:^{
        }];
        }
        
    }else{
        [SVProgressHUD showErrorWithStatus:json[@"message"]];
    }
}

-(void)doAlert:(NSString *)inMessage {
    UIAlertView *alertDialog = [[UIAlertView alloc] initWithTitle:@"提示信息" message:inMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertDialog show];
}

-(void)requestError:(ASIHTTPRequest *)request{
    NSError *error = [request error];
    if ([activity isVisible]) {
        [activity stopAcimate];
    }
    [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
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
            frame.size.height=180;
            [_tb setFrame:frame];
            [_tb.layer setBorderColor:[UIColor grayColor].CGColor];
            
        } completion:^(BOOL finished){
            isOpened=YES;
        }];
    }
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
