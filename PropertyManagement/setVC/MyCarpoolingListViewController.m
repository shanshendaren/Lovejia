//
//  MyCarpoolingListViewController.m
//  PropertyManagement
//
//  Created by admin on 15/3/11.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "MyCarpoolingListViewController.h"
#import "VersionAdapter.h"
#import "MysendCarViewController.h"
#import "MyCommentCarLIstViewController.h"
#import "RequestUtil.h"
#import "SVProgressHUD.h"
#import "BZAppDelegate.h"
#import "ActivityView.h"


@interface MyCarpoolingListViewController (){

}

@end

@implementation MyCarpoolingListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"我的拼车中心";
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    [self createBack];
    [VersionAdapter setViewLayout:self];
    [self createUI];
    
    BZAppDelegate *app = [UIApplication sharedApplication].delegate;
    if (app.unReadNeigNum != 0) {
        RequestUtil *requestUtil = [[RequestUtil alloc]init];
        //业务数据参数组织成JSON字符串
        NSString *biz = [NSString  stringWithFormat:@"{\"userId\":\"%@\"}",app.userID];
        NSString *sid = @"CleanUnReadNeighborhordCarpoolNum";
        [requestUtil startRequest:sid biz:biz send:self];
    }
    // Do any additional setup after loading the view.
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
        BZAppDelegate *app =[UIApplication sharedApplication].delegate;
        app.unReadNeigNum = 0;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateTabNewCount" object:nil];
    }
    else{
        [SVProgressHUD showErrorWithStatus:json[@"message"]];
    }
}

-(void)requestError:(ASIHTTPRequest *)request{
//    NSError *error = [request error];
//    [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
}

-(void)createUI{
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"我创建的信息",@"我评论过的信息",nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    segmentedControl.tintColor = [UIColor blueColor];
    //    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentedControl.frame = CGRectMake(0, 0, self.view.frame.size.width, 40);
    segmentedControl.selectedSegmentIndex = 0;//设置默认选择项索引
    [ segmentedControl addTarget: self action: @selector(segmentChanged:)forControlEvents: UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];
    
    MysendCarViewController * nlc = [[MysendCarViewController alloc]init];
    [self addChildViewController:nlc];
    MyCommentCarLIstViewController * ntc = [[MyCommentCarLIstViewController alloc]init];
    [self addChildViewController:ntc];
    
    nlc.view.frame = CGRectMake(0,40, self.view.frame.size.width, self.view.frame.size.height-44-[VersionAdapter getMoreVarHead]);
    [self.view addSubview:nlc.view];
    
    UIViewController *stationVC = [self.childViewControllers objectAtIndex:0];
    self.currentViewController = stationVC;
    
}

-(void)segmentChanged:(UISegmentedControl *)paramSender{
    UIViewController *stationVC = [self.childViewControllers objectAtIndex:0];
    UIViewController *classifyVC = [self.childViewControllers objectAtIndex:1];
    switch (paramSender.selectedSegmentIndex) {
        case 0:
            if (self.currentViewController == stationVC)
            {
                
            }
            else
            {
                self.currentViewController = stationVC;
                stationVC.view.frame = CGRectMake(0,40, self.view.frame.size.width, self.view.frame.size.height-44-[VersionAdapter getMoreVarHead]);
                [classifyVC.view removeFromSuperview];
                [self.view addSubview:stationVC.view];
            }
            break;
        case 1:
            if (self.currentViewController == stationVC)
            {
                self.currentViewController = classifyVC;
                classifyVC.view.frame =CGRectMake(0,40, self.view.frame.size.width, self.view.frame.size.height-44-[VersionAdapter getMoreVarHead]);
                [stationVC.view removeFromSuperview];
                [self.view addSubview:classifyVC.view];
            }
            else
            {
                
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
