//
//  BuyViewController.m
//  PropertyManagement
//
//  Created by admin on 14/11/13.
//  Copyright (c) 2014年 admin. All rights reserved.
//

#import "BuyViewController.h"
#import "VersionAdapter.h"

@interface BuyViewController ()

@end

@implementation BuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"代购服务";
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    [VersionAdapter setViewLayout:self];
    UIImageView * bgIV =[[UIImageView alloc]initWithFrame:CGRectMake(0, -50, self.view.frame.size.width, self.view.frame.size.height -[VersionAdapter getMoreVarHead])];
    [bgIV setImage:[UIImage imageNamed:@"25.png"]];
    [self.view addSubview:bgIV];

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
