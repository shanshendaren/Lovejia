//
//  PhoneNCViewController.m
//  PropertyManagement
//
//  Created by 杨 帅 on 15/5/9.
//  Copyright (c) 2015年 杨 帅. All rights reserved.
//

#import "PhoneNCViewController.h"

@interface PhoneNCViewController ()

@end

@implementation PhoneNCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:250.0/255.0 green:250.0/255 blue:250.0/255 alpha:1.0];
    

//    UIImage * image  = [UIImage imageNamed:@"navigation_bar_bg1"];
//    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation_bar_bg1"] forBarMetrics:UIBarMetricsDefault];
//        self.navigationBar.shadowImage =[[UIImage alloc]init];
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    
//    self.navigationBar.alpha = 0.2;
       self.navigationController.navigationBar.backgroundColor =[UIColor clearColor];
    
    
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
