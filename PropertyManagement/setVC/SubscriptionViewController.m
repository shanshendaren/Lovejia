//
//  SubscriptionViewController.m
//  PropertyManagement
//
//  Created by admin on 14/11/19.
//  Copyright (c) 2014年 admin. All rights reserved.
//

#import "SubscriptionViewController.h"
#import "VersionAdapter.h"
#import "SubscripTableViewCell.h"
#import "BZAppDelegate.h"
#import "RequestUtil.h"
#import "ActivityView.h"
#import "SVProgressHUD.h"
#import "information.h"


@interface SubscriptionViewController (){
    UITableView *setTable;
    ActivityView *activity;
    NSMutableArray *newsArr;
    int clickCount;

}

@end

@implementation SubscriptionViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    BZAppDelegate* app = (BZAppDelegate *)[UIApplication sharedApplication].delegate;
    [app.tabBar customTabBarHidden:YES];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [VersionAdapter setViewLayout:self];
    // Do any additional setup after loading the view.
    [self createUI];
    [self setExtraCellLineHidden:setTable];
}


-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
-(void)createUI{
    self.title = @"订阅管理";
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];

    setTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,  self.view.frame.size.height-[VersionAdapter getMoreVarHead]-44)];
    setTable.delegate = self; setTable.dataSource = self;
    [self.view addSubview:setTable];
    
    [self createBack];
    
    activity = [[ActivityView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44 - [VersionAdapter getMoreVarHead]) loadStr:NSLocalizedString(@"正在加载...", nil)];
    newsArr = [[NSMutableArray alloc]init];
    BZAppDelegate *app =[UIApplication sharedApplication].delegate;
    RequestUtil *requestUtil = [[RequestUtil alloc]init];
    //业务数据参数组织成JSON字符串
    NSString *biz = [NSString  stringWithFormat:@"{\"tel\":\"%@\"}",app.userMobile];
    NSString *sid = @"SomeOneSubscribeList";
    [requestUtil startRequest:sid biz:biz send:self];
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
    [self.navigationController popViewControllerAnimated:NO];
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
    if ([[json objectForKey:@"SID"]isEqualToString:@"SomeOneSubscribeList"]) {
        NSArray *arr = [json objectForKey:@"subscribeList"];
        if ([json[@"status"]isEqualToString:@"success"]) {
            for (int i = 0; i <arr.count ; i++) {
                NSDictionary * rdic =[arr objectAtIndex:i];
                information *ifm =[[information alloc]init];
                ifm.informationTypeId = [rdic objectForKey:@"typeId"];
                ifm.typeName = [rdic objectForKey:@"typeName"];
                ifm.isSubscribe = [[rdic objectForKey:@"isSubscribe"] boolValue];
                ifm.typePic = [rdic objectForKey:@"type_img"];
                ifm.typeInfo = [rdic objectForKey:@"type_introduction"];
                [newsArr addObject:ifm];
            }
            [setTable reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:json[@"message"]];
        }
    }else if([[json objectForKey:@"SID"]isEqualToString:@"DoSubscribe"]){
        if ([json[@"status"]isEqualToString:@"success"]) {
            information * inf = [newsArr objectAtIndex:clickCount];
            inf.isSubscribe = YES;
            [SVProgressHUD showSuccessWithStatus:json[@"message"]];
            
            NSDictionary *dictionary = [NSDictionary dictionaryWithObject:inf forKey:@"information"];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"updateNewsList" object:dictionary];
            [setTable reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:json[@"message"]];
        }
    }
    else if([[json objectForKey:@"SID"]isEqualToString:@"Unsubscribe"]){
        if ([json[@"status"]isEqualToString:@"success"]) {
            information * inf = [newsArr objectAtIndex:clickCount];
            inf.isSubscribe = NO;
            NSDictionary *dictionary = [NSDictionary dictionaryWithObject:inf forKey:@"information"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateNewsList" object:dictionary];
            [SVProgressHUD showSuccessWithStatus:json[@"message"]];
            [setTable reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:json[@"message"]];
        }
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

-(void)doAlert:(NSString *)inMessage {
    UIAlertView *alertDialog = [[UIAlertView alloc] initWithTitle:@"提示信息" message:inMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertDialog show];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [newsArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   static NSString *CellIdentifier = @"SubscripTableViewCell";
    SubscripTableViewCell  *newcell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!newcell) {
        newcell = [[SubscripTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [newcell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [newcell.setBTN addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    newcell.setBTN.tag = indexPath.row;
    information * inf = [newsArr objectAtIndex:indexPath.row];
    newcell.infoLabel.text = [NSString stringWithFormat:@"%@",inf.typeInfo];
    newcell.nameLabel.text = [NSString stringWithFormat:@"%@",inf.typeName];
    newcell.imview.image =[UIImage imageNamed:@"minion"];
    if (inf.isSubscribe) {
        [newcell.setBTN setTitle:@"退订" forState:UIControlStateNormal];
        [newcell.setBTN setBackgroundImage:[UIImage imageNamed:@"unsubscribe_1.png"] forState:UIControlStateNormal];
    }else{
        [newcell.setBTN setTitle:@"订阅" forState:UIControlStateNormal];
        [newcell.setBTN setBackgroundImage:[UIImage imageNamed:@"subscribe_btn.png"] forState:UIControlStateNormal];
    }
    [newcell.setBTN setTintColor:[UIColor whiteColor]];
    return newcell;
}

-(void)click:(UIButton *)sender {
    information * inf = [newsArr objectAtIndex:sender.tag];
    BZAppDelegate *app =[UIApplication sharedApplication].delegate;
    clickCount = (int)sender.tag;
    if (inf.isSubscribe) {
        RequestUtil *requestUtil = [[RequestUtil alloc]init];
        //业务数据参数组织成JSON字符串
        NSString *biz = [NSString  stringWithFormat:@"{\"userId\":\"%@\",\"typeId\":\"%@\"}",app.userID,inf.informationTypeId];
        NSString *sid = @"Unsubscribe";
        [requestUtil startRequest:sid biz:biz send:self];
    }else{
        RequestUtil *requestUtil = [[RequestUtil alloc]init];
        //业务数据参数组织成JSON字符串
        NSString *biz = [NSString  stringWithFormat:@"{\"userId\":\"%@\",\"typeId\":\"%@\"}",app.userID,inf.informationTypeId];
        NSString *sid = @"DoSubscribe";
        [requestUtil startRequest:sid biz:biz send:self];
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
