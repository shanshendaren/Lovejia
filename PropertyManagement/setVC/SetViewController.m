//
//  SetViewController.m
//  PropertyManagement
//
//  Created by admin on 14/11/13.
//  Copyright (c) 2014年 admin. All rights reserved.
//

#import "SetViewController.h"
#import "BZAppDelegate.h"
#import "VersionAdapter.h"
#import "changePasswordViewController.h"
#import "SubscriptionViewController.h"
#import "PersonInfoSetViewController.h"
#import "MyComplainListViewController.h"
#import "MyFixListViewController.h"
#import "AppCenterTableViewCell.h"
#import "ContactPersonViewController.h"
#import "MyChangListViewController.h"
#import "MyCarpoolingListViewController.h"
#import "JSBadgeView.h"
#import "HousekeepingListViewController.h"
#import "PhoneNCViewController.h"

@interface SetViewController (){
    UITableView *setTable;
    UILabel *userLabel;
    BZAppDelegate* app;
    int newCount;
    UIView *recView ;
    UIView *recView1;
    JSBadgeView *badgeView;
    JSBadgeView *badgeView1;
}

@end

@implementation SetViewController

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    [super viewWillAppear:animated];
     app = (BZAppDelegate *)[UIApplication sharedApplication].delegate;
    [app.tabBar customTabBarHidden:NO];
    [setTable reloadData];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    newCount = 77;
    [setTable reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [VersionAdapter setViewLayout:self];
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.98 alpha:1.0]];
    [self createUI];
    [self initUI];
    newCount = 2;
}

-(void)initUI{
    setTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 42, self.view.frame.size.width, self.view.frame.size.height - 44)];
    setTable.delegate = self;
    setTable.dataSource = self;
    [self.view addSubview:setTable];
    setTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    setTable.scrollEnabled = NO;
    
    
}

-(void)createUI{
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    [label1 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:label1];
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0,20,self.view.frame.size.width,20)];
    label.text = @"个人中心";
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor grayColor];
    label.backgroundColor = [UIColor whiteColor];
    [label setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:label];
  
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 4;
    }else if(section == 2){
        return 2;
    }else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"AppCenterTableViewCell";
    AppCenterTableViewCell  *newcell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!newcell) {
        newcell = [[AppCenterTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    newcell.titleLabel.font = [UIFont fontWithName:@"Arial" size:FONT_SIZE];
    if (indexPath.section == 0) {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0,54,self.view.frame.size.width , 0.5)];
        view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
        [newcell.contentView addSubview:view];
        
        if (indexPath.row == 0){
            view.frame =CGRectMake(0, 69, self.view.frame.size.width, 0.5) ;
            
            UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
            imageV.image = [UIImage imageNamed:@"user_2.png"];
            UILabel  * label = [[UILabel alloc]initWithFrame:CGRectMake(70, 28, 150, 20)];
            label.text = app.userName;
            label.font = [UIFont fontWithName:@"Arial" size:14];
            [newcell.contentView addSubview:imageV];
            [newcell.contentView addSubview:label];
        }
    }
    if(indexPath.section == 1){
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(30,0,self.view.frame.size.width , 0.5)];
        view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
        [newcell.contentView addSubview:view];
        
        if (indexPath.row == 0) {
            view.frame = CGRectMake(30, 35, self.view.frame.size.width, 0.5) ;
            newcell.newsIV.image = [UIImage imageNamed:@"38"];
            newcell.titleLabel.text = [NSString stringWithFormat:@"账单"];
        }
        else if (indexPath.row ==1 ){
            newcell.newsIV.image = [UIImage imageNamed:@"33"];
            newcell.titleLabel.text = [NSString stringWithFormat:@"我的家政"];
        }
        else if (indexPath.row == 2) {
            newcell.newsIV.image = [UIImage imageNamed:@"39"];
            newcell.titleLabel.text = [NSString stringWithFormat:@"我的投诉"];
        }
        else if (indexPath.row == 3) {
            newcell.newsIV.image = [UIImage imageNamed:@"31"];
            newcell.titleLabel.text = [NSString stringWithFormat:@"我的报修"];
        }
    }
    if(indexPath.section == 2){
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(30,0,self.view.frame.size.width , 0.5)];
        view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
        [newcell.contentView addSubview:view];
        
        if (indexPath.row == 0) {
            view.frame =CGRectMake(30, 35, self.view.frame.size.width, 0.5) ;
            newcell.newsIV.image = [UIImage imageNamed:@"09999978Icon"];
                        newcell.titleLabel.text = [NSString stringWithFormat:@"亲情号码"];
        }else if(indexPath.row == 1){
            newcell.newsIV.image = [UIImage imageNamed:@"30"];
            newcell.titleLabel.text = [NSString stringWithFormat:@"订阅管理"];
        }
//       添加栏目
//        else if(indexPath.row == 2) {
//        }
    }
    
    else if (indexPath.section == 3){
//        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width , 1)];
//        view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
//        [newcell.contentView addSubview:view];
//        
//        UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width , 1)];
//        view1.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
//        [newcell.contentView addSubview:view1];
        
        newcell.newsIV.image = [UIImage imageNamed:@"32"];
        newcell.titleLabel.text = [NSString stringWithFormat:@"设置"];
     }
    else if (indexPath.section == 4) {
        UILabel  * label = [[UILabel alloc]initWithFrame:CGRectMake(120, 4, 200, 20)];
        label.text = [NSString stringWithFormat:@"退出登录"];
        label.font = [UIFont fontWithName:@"Arial" size:FONT_SIZE];
        label.textColor = [UIColor grayColor];
        [newcell.contentView addSubview:label];

        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0,54,self.view.frame.size.width , 1)];
        view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
        [newcell.contentView addSubview:view];
        UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0,35,self.view.frame.size.width , 1)];
        view1.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
        [newcell.contentView addSubview:view1];
    }
    newcell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    newcell.accessoryType = UITableViewCellAccessoryNone;
    return newcell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row ==0 ) {
        return 70;
    }
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    if (section ==4) {
        return 140;
    }
    return 10.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0){
        UIAlertView * av = [[UIAlertView alloc]initWithTitle:@"提示" message:@"下个版本敬请期待" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
         [av show];
        }
        else if (indexPath.row == 1){
            HousekeepingListViewController *hcv = [[HousekeepingListViewController alloc]init];
            PhoneNCViewController *navigationController = [[PhoneNCViewController alloc] initWithRootViewController:hcv];
            [self presentViewController:navigationController animated:NO completion:^{
            }];
       }
       else if(indexPath.row == 2){
           MyComplainListViewController *mcv = [[MyComplainListViewController alloc]init];
           PhoneNCViewController *navigationController = [[PhoneNCViewController alloc] initWithRootViewController:mcv];
           [self presentViewController:navigationController animated:NO completion:^{
           }];
        }
        else if (indexPath.row ==3){
            MyFixListViewController *mcv = [[MyFixListViewController alloc]init];
            PhoneNCViewController *navigationController = [[PhoneNCViewController alloc] initWithRootViewController:mcv];
            [self presentViewController:navigationController animated:NO completion:^{
            }];
        }
}
    if (indexPath.section == 2) {
        if (indexPath.row == 0){
            ContactPersonViewController * svc = [[ContactPersonViewController alloc]init];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:svc];
            [self presentViewController:navigationController animated:NO completion:^{
            }];
        }
        else if(indexPath.row == 1){
            SubscriptionViewController * svc = [[SubscriptionViewController alloc]init];
            [self.navigationController pushViewController:svc animated:YES];

//            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:svc];
//            [self presentViewController:navigationController animated:NO completion:^{
//            }];
        }
//添加更多
//        else if(indexPath.row == 2){
//          
//        }
    }
    if (indexPath.section == 3) {
        if (indexPath.row == 0){
            PersonInfoSetViewController *mcv = [[PersonInfoSetViewController alloc]init];
            PhoneNCViewController *navigationController = [[PhoneNCViewController alloc] initWithRootViewController:mcv];
            [self presentViewController:navigationController animated:NO completion:^{
            }];
    }
}
    if (indexPath.section == 4) {
        if(indexPath.row == 0){
        [app bootLoginViewController];
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
