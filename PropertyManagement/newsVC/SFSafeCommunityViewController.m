//
//  SFSafeCommunityViewController.m
//  PropertyManagement
//
//  Created by mac on 15/9/2.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "SFSafeCommunityViewController.h"
#import "RequestUtil.h"
#import "BZAppDelegate.h"

@interface SFSafeCommunityViewController ()

@end

@implementation SFSafeCommunityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  //  self.navigationController.navigationBarHidden = YES;
    webView = [[UIWebView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [webView setUserInteractionEnabled:YES];//是否支持交互
    //[webView setDelegate:self];
    webView.delegate=self;
    [webView setOpaque:NO];//opaque是不透明的意思
    [webView setScalesPageToFit:YES];//自动缩放以适应屏幕
    [self.view addSubview:webView];
    
    //???:   加载网页的方式
    //1.创建并加载远程网页
    NSURL *url = [NSURL URLWithString:@"http://www.whaijia.cn/lovehome/move/sc-insert2.jsp"];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];

    opaqueView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    activityIndicatorView = [[UIActivityIndicatorView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [activityIndicatorView setCenter:opaqueView.center];
    [activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [opaqueView setBackgroundColor:[UIColor blackColor]];
    [opaqueView setAlpha:0.6];
    [self.view addSubview:opaqueView];
    [opaqueView addSubview:activityIndicatorView];

}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [activityIndicatorView startAnimating];
    opaqueView.hidden = NO;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [activityIndicatorView startAnimating];
    opaqueView.hidden = YES;
}

//UIWebView如何判断 HTTP 404 等错误
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSURL *url = [NSURL URLWithString:@"http://192.168.1.104:8080/lovehome/move/sc-insert2.jsp"];
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if ((([httpResponse statusCode]/100) == 2)) {
        // self.earthquakeData = [NSMutableData data];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        [ webView loadRequest:[ NSURLRequest requestWithURL: url]];
        webView.delegate = self;
    } else {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:
                                  NSLocalizedString(@"HTTP Error",
                                                    @"Error message displayed when receving a connection error.")
                                                             forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:@"HTTP" code:[httpResponse statusCode] userInfo:userInfo];
        
        if ([error code] == 404) {
            NSLog(@"xx");
            webView.hidden = YES;
        }
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
