//
//  PayForViewController.m
//  PropertyManagement
//
//  Created by admin on 15/1/29.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "PayForViewController.h"
#import "VersionAdapter.h"

@interface PayForViewController ()

@end

@implementation PayForViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"缴费服务";
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];

    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.bounds.size.height - 44 - [VersionAdapter getMoreVarHead])];
    [webView setBackgroundColor:[UIColor whiteColor]];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://113.106.48.182:8080/property/jf/jf.htm"]];
    [self.view addSubview: webView];
    [webView loadRequest:request];
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
