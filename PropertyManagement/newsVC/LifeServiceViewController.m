//
//  LifeServiceViewController.m
//  PropertyManagement
//
//  Created by admin on 15/1/27.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "LifeServiceViewController.h"
#import "VersionAdapter.h"

@interface LifeServiceViewController (){
    UIWebView *webView;
}

@end

@implementation LifeServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    self.title = @"生活服务";
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height - 44 - [VersionAdapter getMoreVarHead])];
    [webView setBackgroundColor:[UIColor whiteColor]];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://wap.boc.cn/"]];
    [self.view addSubview: webView];
    [webView loadRequest:request];
    // Do any additional setup after loading the view.
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
