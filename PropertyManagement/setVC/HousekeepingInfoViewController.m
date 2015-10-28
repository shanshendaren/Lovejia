//
//  HousekeepingInfoViewController.m
//  PropertyManagement
//
//  Created by admin on 15/3/17.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "HousekeepingInfoViewController.h"
#import "VersionAdapter.h"
#import "RequestUtil.h"
#import "ActivityView.h"
#import "SVProgressHUD.h"


@interface HousekeepingInfoViewController (){
    ActivityView *activity;
    UILabel *titleLabelInfo;
    UILabel * timeLabel;
    UITextView * contentView;
    UILabel * isdone;
    CGFloat Y;
    UIButton * wBtn1;
    UIButton * wBtn2;
    UIButton * wBtn3;
    UITextView * contentView1;
    int isFeedback;
    
}

@end

@implementation HousekeepingInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    // Do any additional setup after loading the view.
}

-(void)createUI{
    [VersionAdapter setViewLayout:self];
    [self createBack];
    isFeedback = 0;
    [self.view setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0  blue:238.0/255.0  alpha:1.0]];
    self.title = @"家政详情";
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:FONT_SIZE],NSFontAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    UIScrollView * sv =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height -44-[VersionAdapter getMoreVarHead])];
    [sv setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0  blue:238.0/255.0  alpha:1.0]];
    [sv setUserInteractionEnabled:YES];
    [self.view addSubview:sv];
    
    activity = [[ActivityView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44 - [VersionAdapter getMoreVarHead]) loadStr:NSLocalizedString(@"正在加载...", nil)];
    
    UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, Y, self.view.frame.size.width, 35)];
    [view1 setBackgroundColor:[UIColor whiteColor]];
    [sv addSubview:view1];
    
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(75, 5, 1, 25)];
    [line1 setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0  blue:238.0/255.0  alpha:1.0]];
    [view1 addSubview:line1];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 60, 35)];
    titleLabel.text = @"标题";
    [titleLabel setFont:[UIFont fontWithName:@"Arial" size:FONT_SIZE]];
    [view1 addSubview:titleLabel];
    
    titleLabelInfo = [[UILabel alloc]initWithFrame:CGRectMake(85, 3, self.view.frame.size.width-120, 30)];
    titleLabelInfo.font = [UIFont fontWithName:@"Arial" size:FONT_SIZE];
    
    titleLabelInfo.text = [NSString stringWithFormat:@"%@",self.houseK.hsName];
    [view1 addSubview:titleLabelInfo];
    
    Y = view1.frame.size.height + view1.frame.origin.y+ 1;
    
    UIView * view2 = [[UIView alloc]initWithFrame:CGRectMake(0, Y, self.view.frame.size.width, 35)];
    [view2 setBackgroundColor:[UIColor whiteColor]];
    [sv addSubview:view2];
    
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(75, 5, 1, 25)];
    [line2 setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0  blue:238.0/255.0  alpha:1.0]];
    [view2 addSubview:line2];
    
    UILabel *complainLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 60, 40)];
    complainLabel.text = @"创建时间";
    [complainLabel setFont:[UIFont fontWithName:@"Arial" size:FONT_SIZE]];
    [view2 addSubview:complainLabel];
    
    timeLabel =  [[UILabel alloc]initWithFrame:CGRectMake(85, 3,self.view.frame.size.width-120,30)];
    timeLabel.font = [UIFont fontWithName:@"Arial" size:FONT_SIZE];
    timeLabel.text = [NSString stringWithFormat:@"%@",self.houseK.hsTime];

    [view2 addSubview:timeLabel];
    
    Y = view2.frame.size.height + view2.frame.origin.y+ 1;
    
    UIView * view3 = [[UIView alloc]initWithFrame:CGRectMake(0,Y, self.view.frame.size.width, 170)];
    [view3 setBackgroundColor:[UIColor whiteColor]];
    [sv addSubview:view3];
    
    UILabel *infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 65, 60, 40)];
    infoLabel.text = @"服务内容";
    [infoLabel setFont:[UIFont fontWithName:@"Arial" size:FONT_SIZE]];
    [view3 addSubview:infoLabel];
    
    UIView * line3 = [[UIView alloc]initWithFrame:CGRectMake(75, 5, 1, 160)];
    [line3 setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0  blue:238.0/255.0  alpha:1.0]];
    [view3 addSubview:line3];
    
    contentView= [[UITextView  alloc] initWithFrame:CGRectMake(75, 0, self.view.frame.size.width-110, 170)] ; //初始化大小
    contentView.tag = 2;
    [contentView setBackgroundColor:[UIColor clearColor]];
    contentView.font = [UIFont fontWithName:@"Arial" size:FONT_SIZE];//设置字体名字和字体大小
    contentView.delegate = self;//设置它的委托方法
    contentView.returnKeyType = UIReturnKeyDefault;//返回键的类型
    contentView.keyboardType = UIKeyboardTypeDefault;//键盘类型
    [contentView setEditable:YES];
    contentView.scrollEnabled = YES;//是否可以拖动
    [contentView setEditable:NO];
    contentView.textColor = [UIColor blackColor];
    contentView.text = [NSString stringWithFormat:@"%@",self.houseK.hsDetail];
    [view3 addSubview: contentView];
    
    Y = view3.frame.size.height + view3.frame.origin.y+ 1;
    
    UIView * view4 = [[UIView alloc]initWithFrame:CGRectMake(0, Y, self.view.frame.size.width, 35)];
    [view4 setBackgroundColor:[UIColor whiteColor]];
    [sv addSubview:view4];
    
    UIView * line4 = [[UIView alloc]initWithFrame:CGRectMake(75, 5, 1, 25)];
    [line4 setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0  blue:238.0/255.0  alpha:1.0]];
    [view4 addSubview:line4];
    
    UILabel *doLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 60, 35)];
    doLabel.text = @"受理时间";
    [doLabel setFont:[UIFont fontWithName:@"Arial" size:FONT_SIZE]];
    [view4 addSubview:doLabel];
    
    isdone = [[UILabel alloc]initWithFrame:CGRectMake(85, 3, self.view.frame.size.width-120, 30)];
    isdone.font = [UIFont fontWithName:@"Arial" size:FONT_SIZE];
    if (self.houseK.acceptTime.length >0) {
        isdone.text =[NSString stringWithFormat:@"%@",self.houseK.acceptTime];
    }else{
        isdone.text = @"还未受理";
    }
    [view4 addSubview:isdone];
    
    Y = view4.frame.size.height + view4.frame.origin.y+ 1;
    
    
    UIView * view6 = [[UIView alloc]initWithFrame:CGRectMake(0,Y, self.view.frame.size.width, 80)];
    [view6 setBackgroundColor:[UIColor whiteColor]];
    [sv addSubview:view6];
    
    UILabel *infoLabel6 = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 60, 40)];
    infoLabel6.text = @"受理方案";
    [infoLabel6 setFont:[UIFont fontWithName:@"Arial" size:FONT_SIZE]];
    [view6 addSubview:infoLabel6];
    
    UIView * line6 = [[UIView alloc]initWithFrame:CGRectMake(75, 5, 1, 70)];
    [line6 setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0  blue:238.0/255.0  alpha:1.0]];
    [view6 addSubview:line6];
    
    contentView1= [[UITextView  alloc] initWithFrame:CGRectMake(85, 0, self.view.frame.size.width-85, 80)] ; //初始化大小
    [contentView1 setBackgroundColor:[UIColor clearColor]];
    contentView1.font = [UIFont fontWithName:@"Arial" size:FONT_SIZE];//设置字体名字和字体大小
    contentView1.delegate = self;//设置它的委托方法
    contentView1.returnKeyType = UIReturnKeyDefault;//返回键的类型
    contentView1.keyboardType = UIKeyboardTypeDefault;//键盘类型
    [contentView1 setEditable:YES];
    contentView1.scrollEnabled = YES;//是否可以拖动
    [contentView1 setEditable:NO];
    contentView1.textColor = [UIColor blackColor];
    if (self.houseK.acceptRemark.length > 0) {
        contentView1.text = [NSString stringWithFormat:@"%@",self.houseK.acceptRemark];
    }else{
        contentView1.text = @"您的需求还未被任何商家受理";
    }
    [view6 addSubview: contentView1];
    Y = view6.frame.size.height + view6.frame.origin.y+ 1;
    
    if ([self.houseK.acceptStatus isEqualToString:@"1"]) {
        UIView * view7 = [[UIView alloc]initWithFrame:CGRectMake(0, Y, self.view.frame.size.width, 81)];
        [view7 setBackgroundColor:[UIColor whiteColor]];
        [sv addSubview:view7];
        
        UILabel *ll1 =[[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-60, 20)];
        ll1.text = @"商家信息";
        [ll1 setFont:[UIFont fontWithName:@"Arial" size:FONT_SIZE]];
        [ll1 setTextColor:[UIColor colorWithRed:158.0/255.0 green:219.0/255.0 blue:0.0/255.0 alpha:1]];
        [view7 addSubview:ll1];
        
        UIView *llview =[[UIView alloc]initWithFrame:CGRectMake(10, 21, self.view.frame.size.width-10, 0.5)];
        [llview setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0  blue:238.0/255.0  alpha:1.0]];
        [view7 addSubview:llview];
        
        UILabel *ll2 =[[UILabel alloc]initWithFrame:CGRectMake(10, 21, self.view.frame.size.width-60, 20)];
        ll2.text = [NSString stringWithFormat:@"%@",self.houseK.acceptCompany];
        [view7 addSubview:ll2];
        
        UILabel *ll3 =[[UILabel alloc]initWithFrame:CGRectMake(10, 41, self.view.frame.size.width-60, 20)];
        ll3.text = [NSString stringWithFormat:@"联系人:%@",self.houseK.acceptBusinner];
        ll3.font = [UIFont fontWithName:@"Arial" size:FONT_SIZE];
        ll3.textColor = [UIColor lightGrayColor];
        [view7 addSubview:ll3];
        
        UILabel *ll4 =[[UILabel alloc]initWithFrame:CGRectMake(10, 61, self.view.frame.size.width-60, 20)];
        ll4.text = [NSString stringWithFormat:@"联系电话:%@",self.houseK.acceptBusinnerMobile];
        ll4.font = [UIFont fontWithName:@"Arial" size:FONT_SIZE];
        ll4.textColor = [UIColor lightGrayColor];
        [view7 addSubview:ll4];
        
        UIButton *telBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        [telBTN setFrame:CGRectMake(self.view.frame.size.width-55, 26, 50, 50)];
        [telBTN setBackgroundImage:[UIImage imageNamed:@"telcompany.png"] forState:UIControlStateNormal];
        [telBTN addTarget:self action:@selector(telAction:) forControlEvents:UIControlEventTouchUpInside];
        [view7 addSubview:telBTN];
        
        Y = view7.frame.size.height + view7.frame.origin.y+ 1;
    }
    
    UIView * view5 = [[UIView alloc]initWithFrame:CGRectMake(0, Y, self.view.frame.size.width, 40)];
    [view5 setBackgroundColor:[UIColor whiteColor]];
    [sv addSubview:view5];
    
    UIView * line5 = [[UIView alloc]initWithFrame:CGRectMake(75, 5, 1, 30)];
    [line5 setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0  blue:238.0/255.0  alpha:1.0]];
    [view5 addSubview:line5];
    
    UILabel *doLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 60, 40)];
    doLabel1.text = @"评价";
    [doLabel1 setFont:[UIFont fontWithName:@"Arial" size:FONT_SIZE]];
    [view5 addSubview:doLabel1];
    
    wBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [wBtn1 setFrame:CGRectMake(100, 5, 50, 30)];
    wBtn1.tag = 3;
    [wBtn1 setBackgroundImage:[UIImage imageNamed:@"evolution_07.png"] forState:UIControlStateNormal];
    [wBtn1 addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [view5 addSubview:wBtn1];
    
    wBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [wBtn2 setFrame:CGRectMake(175, 5, 50, 30)];
    wBtn2.tag = 2;
    [wBtn2 addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [wBtn2 setBackgroundImage:[UIImage imageNamed:@"evolution_09.png"] forState:UIControlStateNormal];
    [view5 addSubview:wBtn2];
    
    wBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [wBtn3 setFrame:CGRectMake(250, 5, 50, 30)];
    [wBtn3 setBackgroundImage:[UIImage imageNamed:@"evolution_11.png"] forState:UIControlStateNormal];
    wBtn3.tag = 1;
    [wBtn3 addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [view5 addSubview:wBtn3];
   
    [sv setContentSize:CGSizeMake(self.view.frame.size.width, Y+45)];
    
    if (self.houseK.feedbackStatus == 1) {
        [wBtn3 setBackgroundImage:[UIImage imageNamed:@"evolution_hover_11.png"] forState:UIControlStateNormal];
    }else if (self.houseK.feedbackStatus == 2){
        [wBtn2 setBackgroundImage:[UIImage imageNamed:@"evolution_hover_09.png"] forState:UIControlStateNormal];
    }
    else if (self.houseK.feedbackStatus == 3 ){
        [wBtn1 setBackgroundImage:[UIImage imageNamed:@"evolution_hover_07.png"] forState:UIControlStateNormal];
    }
}

-(void)telAction:(UIButton *)btn{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.houseK.acceptBusinnerMobile]]];
}

-(void)clickAction:(UIButton *)btn{
    
    if (self.houseK.feedbackStatus ==1 ||self.houseK.feedbackStatus ==2||self.houseK.feedbackStatus ==3) {
        UIAlertView *alertDialog = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"已经评价过，不能再评价" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertDialog show];
    }else{
        isFeedback =(int)btn.tag;
        RequestUtil *requestUtil = [[RequestUtil alloc]init];
        //业务数据参数组织成JSON字符串
        NSString *biz = [NSString  stringWithFormat:@"{\"hsId\":\"%@\",\"feedStatus\":\"%d\"}",self.houseK.hsId,(int)btn.tag];
        NSString *sid = @"EvaluationHouseService";
        [requestUtil startRequest:sid biz:biz send:self];
    }
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
    if ([json[@"status"]isEqualToString:@"success"]) {
        if (isFeedback==1) {
            [wBtn3 setBackgroundImage:[UIImage imageNamed:@"evolution_hover_11.png"] forState:UIControlStateNormal];
        }else if (isFeedback==2){
            [wBtn2 setBackgroundImage:[UIImage imageNamed:@"evolution_hover_09.png"] forState:UIControlStateNormal];
        }
        else if (isFeedback==3){
            [wBtn1 setBackgroundImage:[UIImage imageNamed:@"evolution_hover_07.png"] forState:UIControlStateNormal];
        }
        self.houseK.feedbackStatus = isFeedback;
        NSDictionary *dictionary = [NSDictionary dictionaryWithObject:self.houseK forKey:@"information"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updatehouseKeeping" object:dictionary];
    }
    else{
        [SVProgressHUD showErrorWithStatus:json[@"message"]];
    }
    if ([activity isVisible]) {
        [activity stopAcimate];
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
