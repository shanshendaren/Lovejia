//
//  NewsInfoViewController.m
//  PropertyManagement
//
//  Created by admin on 14/11/20.
//  Copyright (c) 2014年 admin. All rights reserved.
//

#import "NewsInfoViewController.h"
#import "VersionAdapter.h"
#import "RequestUtil.h"
#import "ActivityView.h"
#import "SVProgressHUD.h"
#import "information.h"


@interface NewsInfoViewController (){
    ActivityView *activity;
    information *inf;
    UILabel *titleLabel;
    UILabel * timeLabel;
    UITextView * contentView;
}
@end

@implementation NewsInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [VersionAdapter setViewLayout:self];
    [self createUI];
    // Do any additional setup after loading the view.
}

-(void)createUI{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title = @"资讯信息";
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:FONT_SIZE],NSFontAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];

    activity = [[ActivityView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44 - [VersionAdapter getMoreVarHead]) loadStr:NSLocalizedString(@"正在加载...", nil)];
    RequestUtil *requestUtil = [[RequestUtil alloc]init];
    //业务数据参数组织成JSON字符串
    NSString *biz = [NSString  stringWithFormat:@"{\"infoId\":\"%@\"}",self.newsId];
    NSString *sid = @"FindInformationById";
    [requestUtil startRequest:sid biz:biz send:self];
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, self.view.frame.size.width, 30)];
    titleLabel.textAlignment = 1;
    [self.view addSubview:titleLabel];
    
    timeLabel =  [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-120, 40,120,20)];
    timeLabel.font = [UIFont fontWithName:@"Arial" size:FONT_SIZE];
    [self.view addSubview:timeLabel];
    
    contentView= [[UITextView  alloc] initWithFrame:CGRectMake(20, 60, self.view.frame.size.width-40, self.view.frame.size.height-[VersionAdapter getMoreVarHead])] ; //初始化大小
    contentView.textColor = [UIColor blackColor];//设置textview里面的字体颜色
    contentView.font = [UIFont fontWithName:@"Arial" size:FONT_SIZE];//设置字体名字和字体大小
    contentView.delegate = self;//设置它的委托方法
    contentView.backgroundColor = [UIColor whiteColor];//设置它的背景颜色
    contentView.returnKeyType = UIReturnKeyDefault;//返回键的类型
    contentView.keyboardType = UIKeyboardTypeDefault;//键盘类型
    [contentView setEditable:NO];
    contentView.scrollEnabled = YES;//是否可以拖动
    contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    [self.view addSubview: contentView];
    
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

-(void)backAction{
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
    NSDictionary *dic = json[@"info"];
    if (dic) {
        inf =[[information alloc]init];
        inf.information_title =[dic objectForKey:@"informationTitle"];
        inf.information_content =[dic objectForKey:@"informationContent"];
        inf.createTime =[dic objectForKey:@"createTime"];
        inf.information_picture_b =[dic objectForKey:@"informationPictureB"];
    }
    if ([[json objectForKey:@"SID"]isEqualToString:@"FindInformationById"]) {
        if ([json[@"status"]isEqualToString:@"success"]) {
            
            titleLabel.text = [NSString stringWithFormat:@"%@",inf.information_title];
            titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            titleLabel.numberOfLines = 0;
            UIFont* font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:FONT_SIZE];
            CGSize titleSize = [ titleLabel.text sizeWithFont:font constrainedToSize:CGSizeMake(self.view.frame.size.width-20, 40) lineBreakMode:NSLineBreakByWordWrapping];
            [titleLabel setFrame:CGRectMake(10, 10, titleSize.width, titleSize.height)];
            titleLabel.font =[UIFont fontWithName:@"TrebuchetMS-Bold" size:FONT_SIZE];
            
            timeLabel.text = [NSString stringWithFormat:@"%@",inf.createTime];
            [timeLabel setFrame:CGRectMake(self.view.frame.size.width-120, 15+titleLabel.frame.size.height,120,20)];
            contentView.text =[NSString stringWithFormat:@"%@",inf.information_content];
            [contentView setFrame:CGRectMake(10, 40+titleLabel.frame.size.height, self.view.frame.size.width-20, self.view.frame.size.height-40-titleLabel.frame.size.height-[VersionAdapter getMoreVarHead])];
        }else{
            [SVProgressHUD showErrorWithStatus:json[@"message"]];
        }
    }    if ([activity isVisible]) {
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
