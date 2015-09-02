//
//  VallageViewController.m
//  PropertyManagement
//
//  Created by admin on 15/1/5.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "VallageViewController.h"
#import "MapViewController.h"
#import "VersionAdapter.h"
#import "RequestUtil.h"
#import "SVProgressHUD.h"
#import "ActivityView.h"
#import "BZAppDelegate.h"
#import "UIImageView+WebCache.h"

@interface VallageViewController (){
    ActivityView *activity;
    UIImageView *iv;
    UILabel *l4;
    UILabel *l2;
    UILabel *l6;
    UILabel *l8;
    UILabel* contentView;
    NSString *VallageNum;
    UIScrollView *sv;
    UILabel *countLabel;
}

@end

@implementation VallageViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    BZAppDelegate* app = (BZAppDelegate *)[UIApplication sharedApplication].delegate;
   [app.tabBar customTabBarHidden:YES];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [VersionAdapter setViewLayout:self];
    self.title = @"小区概况";
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    [self createBack];
    BZAppDelegate *app =[UIApplication sharedApplication].delegate;
    
    activity = [[ActivityView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44 - [VersionAdapter getMoreVarHead]) loadStr:NSLocalizedString(@"正在加载...", nil)];
    RequestUtil *requestUtil = [[RequestUtil alloc]init];
    //业务数据参数组织成JSON字符串
    NSString *biz = [NSString  stringWithFormat:@"{\"vallageId\":\"%@\"}",app.vallageID];
    NSString *sid = @"QueryVallageInfo";
    [requestUtil startRequest:sid biz:biz send:self];
    sv =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44-[VersionAdapter getMoreVarHead]-40)];
    sv.userInteractionEnabled = YES;
    [sv setBackgroundColor:[UIColor whiteColor]];
    [sv setScrollEnabled:YES];
    [self.view addSubview:sv];
    
    
    
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(20,  self.view.frame.size.height-44-[VersionAdapter getMoreVarHead]-35, (self.view.frame.size.width-40)/2-10, 30)];
    [btn setTitle:@"地图" forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed: @"17"]forState:UIControlStateNormal];
//    [btn setBackgroundColor:[UIColor redColor]];
    [btn addTarget:self action:@selector(pushAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btn1 =[UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setFrame:CGRectMake((self.view.frame.size.width-40)/2+20,  self.view.frame.size.height-44-[VersionAdapter getMoreVarHead]-35, (self.view.frame.size.width-20)/2-10, 30)];
    [btn1 setTitle:@"呼叫物业" forState:UIControlStateNormal];
    [btn1 setBackgroundImage:[UIImage imageNamed: @"17"]forState:UIControlStateNormal];
//    [btn1 setBackgroundColor:[UIColor redColor]];
    [btn1 addTarget:self action:@selector(phoneAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    
    iv =[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-20, 190)];
    [sv addSubview:iv];
    
    UIView *view1 =[[UIView alloc]initWithFrame:CGRectMake(0, 201, self.view.frame.size.width, 13)];
    [view1 setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0  blue:238.0/255.0  alpha:1.0]];
    [sv addSubview:view1];
    
    UILabel * l1 =[[UILabel alloc]initWithFrame:CGRectMake(10, 215, 60, 30)];
    [l1 setFont:[UIFont fontWithName:nil size:14]];
    l1.text = @"小区名:";
    [sv addSubview:l1];
    
    l2 =[[UILabel alloc]initWithFrame:CGRectMake(70, 215, self.view.frame.size.width-80, 30)];
    [l2 setFont:[UIFont fontWithName:nil size:14]];
    [sv addSubview:l2];
    
    UIView *line1 =[[UIView alloc]initWithFrame:CGRectMake(0, 245, self.view.frame.size.width, 1)];
    [line1 setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0  blue:238.0/255.0  alpha:1.0]];
    [sv addSubview:line1];
    
    UILabel * l3 =[[UILabel alloc]initWithFrame:CGRectMake(10, 246, 60, 30)];
    l3.text = [NSString stringWithFormat:@"%@",@"地    址:" ];
    [l3 setFont:[UIFont fontWithName:nil size:14]];
    [sv addSubview:l3];
    
    l4 =[[UILabel alloc]initWithFrame:CGRectMake(70, 246, self.view.frame.size.width-80, 30)];
    [l4 setFont:[UIFont fontWithName:nil size:14]];
    [sv addSubview:l4];
    
    
    UIView *view2 =[[UIView alloc]initWithFrame:CGRectMake(0, 276, self.view.frame.size.width, 13)];
    [view2 setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0  blue:238.0/255.0  alpha:1.0]];
    [sv addSubview:view2];
    
    
    UILabel * l5 =[[UILabel alloc]initWithFrame:CGRectMake(10, 290, 60, 30)];
    l5.text = [NSString stringWithFormat:@"%@",@"物    管:" ];
    [l5 setFont:[UIFont fontWithName:nil size:14]];
    [sv addSubview:l5];
    
    l6 =[[UILabel alloc]initWithFrame:CGRectMake(70, 290, self.view.frame.size.width-80, 30)];
    [l6 setFont:[UIFont fontWithName:nil size:14]];
    [sv addSubview:l6];
    
    UIView *line2 =[[UIView alloc]initWithFrame:CGRectMake(0, 320, self.view.frame.size.width, 1)];
    [line2 setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0  blue:238.0/255.0  alpha:1.0]];
    [sv addSubview:line2];
    
    
    UILabel * l7 =[[UILabel alloc]initWithFrame:CGRectMake(10, 320, 60, 30)];
    l7.text = @"居委会:";
    [l7 setFont:[UIFont fontWithName:nil size:14]];
    [sv addSubview:l7];
    
    l8 =[[UILabel alloc]initWithFrame:CGRectMake(70, 320, self.view.frame.size.width-80, 30)];
    [l8 setFont:[UIFont fontWithName:nil size:14]];
    [sv addSubview:l8];
    
    UIView *view3 =[[UIView alloc]initWithFrame:CGRectMake(0, 351, self.view.frame.size.width, 13)];
    [view3 setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0  blue:238.0/255.0  alpha:1.0]];
    [sv addSubview:view3];
    
    
    UILabel * l9 =[[UILabel alloc]initWithFrame:CGRectMake(10, 370, 80, 30)];
    l9.text = @"小区详情";
    [l9 setFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:14]];
    [sv addSubview:l9];
    
    UIView *line3 =[[UIView alloc]initWithFrame:CGRectMake(0, 400, self.view.frame.size.width, 1)];
    [line3 setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0  blue:238.0/255.0  alpha:1.0]];
    [sv addSubview:line3];
    
    
    contentView =[[UILabel alloc]initWithFrame:CGRectMake(10, 410, self.view.frame.size.width-20, 100)];
    [contentView setBackgroundColor:[UIColor clearColor]];
    contentView.textAlignment =1;
    [sv addSubview:contentView];
    
   NSLog(@"%@",self.view.subviews);
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
    NSDictionary *biz = json[@"vallageInfo"];
    if ([json[@"status"]isEqualToString:@"success"]) {
        [iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[biz objectForKey:@"picturePath"]]] placeholderImage:nil];
        l2.text =[NSString stringWithFormat:@"%@",[biz objectForKey:@"vallageName"]];
        l4.text =[NSString stringWithFormat:@"%@",[biz objectForKey:@"vallageAddress"]];
        l6.text=[NSString stringWithFormat:@"%@",[biz     objectForKey:@"propertyName"]];
        l8.text=[NSString stringWithFormat:@"%@",[biz objectForKey:@"neighborhoodName"]];
        countLabel.text =[NSString stringWithFormat:@"人数:%@",[biz objectForKey:@"registorNum"]];
        VallageNum = [NSString stringWithFormat:@"%@",[biz objectForKey:@"vallageTel"]];
        
        contentView.text = [NSString stringWithFormat:@"%@",[biz objectForKey:@"vallageDetail"]];
        contentView.lineBreakMode = NSLineBreakByWordWrapping;
        contentView.numberOfLines = 0;
        UIFont* font = [UIFont fontWithName:nil size:14];
        CGSize titleSize = [ contentView.text sizeWithFont:font constrainedToSize:CGSizeMake(self.view.frame.size.width-20, 2000) lineBreakMode:NSLineBreakByWordWrapping];
        [contentView setFrame:CGRectMake(10, 410, titleSize.width, titleSize.height)];
        contentView.font =[UIFont fontWithName:nil size:14];
        [sv setContentSize:CGSizeMake(self.view.frame.size.width, 410+contentView.frame.size.height)];
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

-(void)phoneAction{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",VallageNum]]];
}

-(void)pushAction{
    
    MapViewController *mv =[[MapViewController alloc]init];
    [self.navigationController pushViewController:mv animated:YES];
}

-(void)createBack{
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 15, 15);
    backButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    
    
    UIButton *backButton1=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton1.frame = CGRectMake(0, 0, 110, 20);
    backButton1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    backButton1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    countLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 110, 20)];
    countLabel.textAlignment = NSTextAlignmentRight;
    countLabel.font =[UIFont fontWithName:nil size:13];
    countLabel.textColor =[UIColor whiteColor];
    [backButton1 addSubview:countLabel];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:backButton1];
    
}

-(void)backAction{
    [self dismissViewControllerAnimated:NO completion:^{
    }];
//    [self.navigationController popViewControllerAnimated:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    //Dispose of any resources that can be recreated.
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
