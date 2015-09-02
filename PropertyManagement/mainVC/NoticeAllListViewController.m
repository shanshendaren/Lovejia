//
//  NoticeAllListViewController.m
//  PropertyManagement
//
//  Created by admin on 15/1/14.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "NoticeAllListViewController.h"
#import "NoticeListViewController.h"
#import "VersionAdapter.h"
#import "NoticeSeconTypeViewController.h"
#import "NoticeThirdTypeViewController.h"
#import "BZAppDelegate.h"
#import "RequestUtil.h"
#import "ActivityView.h"
#import "SVProgressHUD.h"


@interface NoticeAllListViewController (){
    UIButton *btn1;
    UIButton *btn2;
    UIButton *btn3;
    ActivityView *activity;
}

@end

@implementation NoticeAllListViewController




-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    BZAppDelegate* app = (BZAppDelegate *)[UIApplication sharedApplication].delegate;
    [app.tabBar customTabBarHidden:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title =@"通知列表";
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    [self createBack];
    [VersionAdapter setViewLayout:self];
      [self createUI];
     if (self.newCount > 0) {
        BZAppDelegate *app =[UIApplication sharedApplication].delegate;
        RequestUtil *requestUtil = [[RequestUtil alloc]init];
        //业务数据参数组织成JSON字符串
        NSString *biz = [NSString  stringWithFormat:@"{\"userId\":\"%@\",\"vallageId\":\"%@\"}",app.userID,app.vallageID];
        NSString *sid = @"CleanUnReadMessage";
        [requestUtil startRequest:sid biz:biz send:self];
    }
    
//    UIImageView * iamgeV =[[UIImageView alloc]initWithFrame:CGRectMake(50, 100, self.view.frame.size.width-100, 200)];
//    iamgeV.backgroundColor = [UIColor redColor];
//    iamgeV.image = [UIImage imageNamed:@"小区通知-1.jpg"];
//    [self.view addSubview:iamgeV];
}

-(void)createUI{

    activity = [[ActivityView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44 - [VersionAdapter getMoreVarHead]) loadStr:NSLocalizedString(@"正在加载...", nil)];

    btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0 , 0, self.view.frame.size.width/3, 40)];
    btn1.tag = 1;
    btn1.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"tz_hover_02.png"] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(cliked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    btn2 = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/3 , 0, self.view.frame.size.width/3, 40)];
    btn2.titleLabel.font = [UIFont systemFontOfSize:15.f];
    btn2.tag =2;
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"tz_03.png"] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(cliked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    btn3 = [[UIButton alloc]initWithFrame:CGRectMake(2*self.view.frame.size.width/3 , 0, self.view.frame.size.width/3, 40)];
    btn3.titleLabel.font = [UIFont systemFontOfSize:15.f];
    btn3.tag =3;
    [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn3 setBackgroundImage:[UIImage imageNamed:@"tz_04.png"] forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(cliked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
    
    
    NoticeListViewController * nlc = [[NoticeListViewController alloc]init];
    [self addChildViewController:nlc];
    
    NoticeSeconTypeViewController * nsc = [[NoticeSeconTypeViewController alloc]init];
    [self addChildViewController:nsc];
    
    NoticeThirdTypeViewController * ntc = [[NoticeThirdTypeViewController alloc]init];
    [self addChildViewController:ntc];

    nlc.view.frame = CGRectMake(0,40, self.view.frame.size.width, self.view.frame.size.height-44-[VersionAdapter getMoreVarHead]);
    [self.view addSubview:nlc.view];
    UIViewController *stationVC = [self.childViewControllers objectAtIndex:0];
    self.currentViewController = stationVC;

}

-(void)requestStarted:(ASIHTTPRequest *)request{
    
}

-(void)requestCompleted:(ASIHTTPRequest *)request{
    NSError *error;
    //获取接口总线返回的结果
    NSString *returnData = [request responseString];
    NSData *jsonData = [returnData dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    if ([json[@"status"]isEqualToString:@"success"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateNewCounts" object:nil];
    }else{
        [SVProgressHUD showErrorWithStatus:json[@"message"]];
    }
}

-(void)requestError:(ASIHTTPRequest *)request{
    NSError *error = [request error];
    [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
}

-(void)cliked:(UIButton *)BTN{
    UIViewController *stationVC = [self.childViewControllers objectAtIndex:0];
    UIViewController *classifyVC = [self.childViewControllers objectAtIndex:1];
    UIViewController * threeVC =[self.childViewControllers objectAtIndex:2];
    switch (BTN.tag) {
        case 1:{
            if (self.currentViewController == stationVC) {
                
            }
            else{
                if (self.currentViewController == classifyVC) {
                    [classifyVC.view removeFromSuperview];
                }else if (self.currentViewController == threeVC){
                    [threeVC.view removeFromSuperview];
                }
                self.currentViewController = stationVC;
                stationVC.view.frame = CGRectMake(0,40, self.view.frame.size.width, self.view.frame.size.height-44-[VersionAdapter getMoreVarHead]);
                [self.view addSubview:stationVC.view];
            }
            [btn1 setBackgroundImage:[UIImage imageNamed:@"tz_hover_02.png"] forState:UIControlStateNormal];
            [btn2 setBackgroundImage:[UIImage imageNamed:@"tz_03.png"] forState:UIControlStateNormal];
            [btn3 setBackgroundImage:[UIImage imageNamed:@"tz_04.png"] forState:UIControlStateNormal];
        }
            break;
        case 2:{
            
            if (self.currentViewController == classifyVC) {
                
            }
            else{
                if (self.currentViewController == stationVC) {
                    [stationVC.view removeFromSuperview];
                    
                }else if (self.currentViewController == threeVC){
                    [threeVC.view removeFromSuperview];
                }
                self.currentViewController = classifyVC;
                classifyVC.view.frame = CGRectMake(0,40, self.view.frame.size.width, self.view.frame.size.height-44-[VersionAdapter getMoreVarHead]);
                [self.view addSubview:classifyVC.view];
            }
            [btn1 setBackgroundImage:[UIImage imageNamed:@"tz_02.png"] forState:UIControlStateNormal];
            [btn2 setBackgroundImage:[UIImage imageNamed:@"tz_hover_03.png"] forState:UIControlStateNormal];
            [btn3 setBackgroundImage:[UIImage imageNamed:@"tz_04.png"] forState:UIControlStateNormal];
        }
            break;
        case 3:{
            if (self.currentViewController == threeVC) {
                
            }else{
                if (self.currentViewController == stationVC) {
                    [stationVC.view removeFromSuperview];
                    
                }else if (self.currentViewController == classifyVC){
                    [classifyVC.view removeFromSuperview];
                }
                self.currentViewController = threeVC;
                threeVC.view.frame = CGRectMake(0,40, self.view.frame.size.width, self.view.frame.size.height-44-[VersionAdapter getMoreVarHead]);
                [self.view addSubview:threeVC.view];
            }
            [btn1 setBackgroundImage:[UIImage imageNamed:@"tz_02.png"] forState:UIControlStateNormal];
            [btn2 setBackgroundImage:[UIImage imageNamed:@"tz_03.png"] forState:UIControlStateNormal];
            [btn3 setBackgroundImage:[UIImage imageNamed:@"tz_hover_04.png"] forState:UIControlStateNormal];
        }
            break;
        default:
            break;
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
//     [self.navigationController popViewControllerAnimated:NO];
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
