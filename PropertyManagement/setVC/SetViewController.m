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
//    self.navigationController.navigationBarHidden = YES;
    [super viewWillAppear:animated];
     app = (BZAppDelegate *)[UIApplication sharedApplication].delegate;
    [app.tabBar customTabBarHidden:NO];
    [setTable reloadData];
    userLabel.text = [NSString stringWithFormat:@"欢迎您,%@",app.userName];
}
-(void)viewWillDisappear:(BOOL)animated{
//    self.navigationController.navigationBarHidden = NO;
    [super viewWillDisappear:animated];
    newCount = 77;
    [setTable reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [VersionAdapter setViewLayout:self];
//    [self createUI];
    [self initUI];
    newCount = 2;
}

-(void)initUI{
    setTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44)];
    //setTable.backgroundColor = [UIColor whiteColor];
    setTable.delegate = self;
    setTable.dataSource = self;
    [self.view addSubview:setTable];
    setTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    UIImageView *bgIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
//    [bgIV setImage:[UIImage imageNamed:@"navigation_bar_bg1"]];
//    [self.view addSubview:bgIV];
//
    self.title = @"个人中心";
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
//    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-100)/2, 24, 100, 20)];
//    label.text = @"个人中心";
//    [label setTextAlignment:NSTextAlignmentCenter];
//    [bgIV addSubview:label];

}

-(void)createUI{
    UIImageView *bgIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 125)];
    [bgIV setImage:[UIImage imageNamed:@"user_center_topbg"]];
    [self.view addSubview:bgIV];
    
    UIImageView *userIV = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-30, 40, 60, 60)];
    [userIV setImage:[UIImage imageNamed:@"user_2"]];
    [bgIV addSubview:userIV];

    userLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 105, self.view.frame.size.width, 20)];
    [userLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
    userLabel.text = [NSString stringWithFormat:@"欢迎您,%@",app.userName];
    userLabel.textAlignment = 0;
    userLabel.adjustsFontSizeToFitWidth = YES;
    [bgIV addSubview:userLabel];
    
    setTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 126, self.view.frame.size.width, self.view.frame.size.height - 49 )];
    setTable.delegate = self; setTable.dataSource = self;
    [self.view addSubview:setTable];
    setTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 8;
    }
    return 1;
//    else if (section == 2) {
//        return 4;
//    }
//    else {
//        return 1;
//    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"AppCenterTableViewCell";
    AppCenterTableViewCell  *newcell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 //   BZAppDelegate * app1 =[UIApplication sharedApplication].delegate;
    if (!newcell) {
        newcell = [[AppCenterTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    newcell.titleLabel.font = [UIFont fontWithName:@"Arial" size:15];
    if (indexPath.section == 0) {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0,54,self.view.frame.size.width , 1)];
        view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
        [newcell.contentView addSubview:view];
        
        if (indexPath.row == 0){
            view.frame =CGRectMake(0, 69, self.view.frame.size.width, 1) ;
            
            UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
            imageV.image = [UIImage imageNamed:@"user_2.png"];
            UILabel  * label = [[UILabel alloc]initWithFrame:CGRectMake(70, 28, 150, 20)];
            label.text = app.userName;
            [newcell.contentView addSubview:imageV];
            [newcell.contentView addSubview:label];
        }
        
        else if (indexPath.row == 1) {
            view.frame =CGRectMake(0, 54, self.view.frame.size.width, 1);
            newcell.newsIV.image = [UIImage imageNamed:@"18"];
            newcell.titleLabel.text = [NSString stringWithFormat:@"我的账单"];
        }
        
        else if (indexPath.row ==2 ){
            newcell.newsIV.image = [UIImage imageNamed:@"3"];
            newcell.titleLabel.text = [NSString stringWithFormat:@"我的消息"];
        }
        else if (indexPath.row == 4) {
            newcell.newsIV.image = [UIImage imageNamed:@"19"];
            newcell.titleLabel.text = [NSString stringWithFormat:@"我的投诉"];
        }
        else if (indexPath.row == 3) {
            newcell.newsIV.image = [UIImage imageNamed:@"1"];
            newcell.titleLabel.text = [NSString stringWithFormat:@"我的报修"];
        }else if (indexPath.row == 5) {
            newcell.newsIV.image = [UIImage imageNamed:@"09999978Icon"];
                        newcell.titleLabel.text = [NSString stringWithFormat:@"亲情号码"];
        }else if(indexPath.row == 6){
            newcell.newsIV.image = [UIImage imageNamed:@"genxin"];
            newcell.titleLabel.text = [NSString stringWithFormat:@"版本更新"];
        }
        else {
            newcell.newsIV.image = [UIImage imageNamed:@"20"];
            newcell.titleLabel.text = [NSString stringWithFormat:@"订阅管理"];
        }
    }
    
    else if (indexPath.section == 1){
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0,54,self.view.frame.size.width , 1)];
        view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
        [newcell.contentView addSubview:view];
        UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width , 1)];
        view1.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
        [newcell.contentView addSubview:view1];
        
        newcell.newsIV.image = [UIImage imageNamed:@"21"];
        newcell.titleLabel.text = [NSString stringWithFormat:@"设置"];
//        if (indexPath.row == 0) {
//            newcell.newsIV.image = [UIImage imageNamed:@"jzfw.png"];
//            newcell.titleLabel.text = [NSString stringWithFormat:@"家政服务消息"];
//        }
//        else if (indexPath.row == 1) {
//           
//            newcell.newsIV.image = [UIImage imageNamed:@"things.png"];
//            newcell.titleLabel.text = [NSString stringWithFormat:@"物品交换消息"];
//            if (!recView) {
//                recView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-75, 20, 50, 30)];
//                badgeView = [[JSBadgeView alloc] initWithParentView:recView alignment:JSBadgeViewAlignmentTopRight];
//            }
//            badgeView.badgeText = [NSString stringWithFormat:@"%d",app1.unReadBarterNum];
//            if (app1.unReadBarterNum == 0) {
//                [recView setHidden:YES];
//            }else{
//                [recView setHidden:NO];
//            }
//            [newcell.contentView addSubview:recView];
//        }
//        else if (indexPath.row == 2) {
//            newcell.newsIV.image = [UIImage imageNamed:@"car.png"];
//            newcell.titleLabel.text = [NSString stringWithFormat:@"邻里拼车消息"];
//            if (!recView1) {
//                recView1 = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-75, 20, 50, 30)];
//                badgeView1 = [[JSBadgeView alloc] initWithParentView:recView1 alignment:JSBadgeViewAlignmentTopRight];
//            }
//            badgeView1.badgeText = [NSString stringWithFormat:@"%d",app1.unReadNeigNum];
//            if (app1.unReadNeigNum == 0) {
//                [recView1 setHidden:YES];
//            }else{
//                [recView1 setHidden:NO];
//            }
//            [newcell.contentView addSubview:recView1];
//        }
    }
    else if (indexPath.section == 2) {
        newcell.newsIV.image = [UIImage imageNamed:@"22"];
        newcell.titleLabel.text = [NSString stringWithFormat:@"退出当前账号"];
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0,54,self.view.frame.size.width , 1)];
        view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
        [newcell.contentView addSubview:view];
        UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width , 1)];
        view1.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
        [newcell.contentView addSubview:view1];
//        if (indexPath.row == 0) {
//            newcell.newsIV.image = [UIImage imageNamed:@"changePassword.png"];
//            newcell.titleLabel.text = [NSString stringWithFormat:@"修改密码"];
//        }
//        else if (indexPath.row == 1) {
//            newcell.newsIV.image = [UIImage imageNamed:@"subscribe_news.png"];
//            newcell.titleLabel.text = [NSString stringWithFormat:@"订阅管理"];
//        }
//        else if (indexPath.row == 2) {
//            newcell.newsIV.image = [UIImage imageNamed:@"qq.png"];
//            newcell.titleLabel.text = [NSString stringWithFormat:@"亲情号码"];
//        }
//        else if (indexPath.row == 3) {
//            newcell.newsIV.image = [UIImage imageNamed:@"set.png"];
//            newcell.titleLabel.text = [NSString stringWithFormat:@"个人信息设置"];
//        }
//    }
//    else if (indexPath.section == 3) {
//        if (indexPath.row == 0) {
//            newcell.newsIV.image = [UIImage imageNamed:@"relogin.png"];
//            newcell.titleLabel.text = [NSString stringWithFormat:@"退出当前账号"];
//        }
    }
    newcell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
     return newcell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row ==0 ) {
        return 70;
    }
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    if (section ==2) {
        return 100;
    }
    return 10.0;
}


//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *retView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10.0)];
//    UIView *sepLineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0.5)];
//    sepLineView1.backgroundColor = [UIColor blackColor];
//    [retView addSubview:sepLineView1];
//    if (section != 3){
//        retView.backgroundColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
//        UIView *sepLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 320, 0.5)];
//        sepLineView.backgroundColor = [UIColor blackColor];
//        [retView addSubview:sepLineView];
//    }else {
//        retView.backgroundColor = [UIColor whiteColor];
//    }
//    return retView;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
//            UIAlertView * av = [[UIAlertView alloc]initWithTitle:@"提示" message:@"下个版本敬请期待" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [av show];
        }
        else if (indexPath.row == 1){
        UIAlertView * av = [[UIAlertView alloc]initWithTitle:@"提示" message:@"下个版本敬请期待" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [av show];
        }
        else if (indexPath.row == 4){
            MyComplainListViewController *mcv = [[MyComplainListViewController alloc]init];
            PhoneNCViewController *navigationController = [[PhoneNCViewController alloc] initWithRootViewController:mcv];
            [self presentViewController:navigationController animated:NO completion:^{
            }];
//            [self.navigationController pushViewController:mcv animated:YES];
                   }
        else if (indexPath.row == 3){
            MyFixListViewController *mcv = [[MyFixListViewController alloc]init];
            PhoneNCViewController *navigationController = [[PhoneNCViewController alloc] initWithRootViewController:mcv];
            [self presentViewController:navigationController animated:NO completion:^{
            }];
//            [self.navigationController pushViewController:mcv animated:YES];
        }
        else if (indexPath.row == 7){
            SubscriptionViewController * svc = [[SubscriptionViewController alloc]init];
            [self.navigationController pushViewController:svc animated:YES];
        }else if(indexPath.row == 6){
            BZAppDelegate *app = [[BZAppDelegate alloc] init];
            [app onCheckVersion];
        }
        else if (indexPath.row ==5){
            ContactPersonViewController * svc = [[ContactPersonViewController alloc]init];
                        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:svc];
                        [self presentViewController:navigationController animated:NO completion:^{
                        }];
        }
        

    }
    if (indexPath.section == 1) {
         if (indexPath.row == 0){
            PersonInfoSetViewController *mcv = [[PersonInfoSetViewController alloc]init];
                         PhoneNCViewController *navigationController = [[PhoneNCViewController alloc] initWithRootViewController:mcv];
                         [self presentViewController:navigationController animated:NO completion:^{
                         }];
//    [self.navigationController pushViewController:mcv animated:YES];

//            HousekeepingListViewController *mcv = [[HousekeepingListViewController alloc]init];
//            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mcv];
//            [self presentViewController:navigationController animated:NO completion:^{
//            }];
        }
//        else if (indexPath.row == 1){
//            MyChangListViewController *mcv = [[MyChangListViewController alloc]init];
//            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mcv];
//            [self presentViewController:navigationController animated:NO completion:^{
//            }];
//        }
//        else if (indexPath.row == 2){
//            MyCarpoolingListViewController *mcv = [[MyCarpoolingListViewController alloc]init];
//            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mcv];
//            [self presentViewController:navigationController animated:NO completion:^{
//            }];
//        }
    }
    if (indexPath.section == 2) {
        if (indexPath.row ==0){
            [app bootLoginViewController];
                   }
//        else if (indexPath.row ==1){
//            
//        }
//        else if (indexPath.row ==2){
//            ContactPersonViewController * svc = [[ContactPersonViewController alloc]init];
//            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:svc];
//            [self presentViewController:navigationController animated:NO completion:^{
//            }];
//        }
//        else if (indexPath.row == 3) {
//            PersonInfoSetViewController *mcv = [[PersonInfoSetViewController alloc]init];
//            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mcv];
//            [self presentViewController:navigationController animated:NO completion:^{
//            }];
//        }
    }
//    if (indexPath.section == 3) {
//        [app bootLoginViewController];
//    }
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
