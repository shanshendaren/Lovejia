//
//  HousekeepingListViewController.m
//  PropertyManagement
//
//  Created by admin on 15/3/17.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "HousekeepingListViewController.h"
#import "VersionAdapter.h"
#import "BZAppDelegate.h"
#import "RequestUtil.h"
#import "ActivityView.h"
#import "SVProgressHUD.h"
#import "MJRefresh.h"
#import "Housekeeping.h"
#import "ComplainTableViewCell.h"
#import "HousekeepingInfoViewController.h"

@interface HousekeepingListViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *setTable;
    ActivityView *activity;
    NSMutableArray *houseKeepingArr;
    BOOL isHead;
    Housekeeping *house;
}

@end

@implementation HousekeepingListViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    BZAppDelegate* app = (BZAppDelegate *)[UIApplication sharedApplication].delegate;
    [app.tabBar customTabBarHidden:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [VersionAdapter setViewLayout:self];
    [self createUI];
    [self createBack];
    // Do any additional setup after loading the view.
}
-(void)createUI{
    isHead = NO;
    self.title =@"家政服务列表";
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatehouseKeeping:) name:@"updatehouseKeeping" object:nil];

    
    setTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,  self.view.frame.size.height-[VersionAdapter getMoreVarHead]-44)];
    setTable.delegate = self; setTable.dataSource = self;
    [self.view addSubview:setTable];
    
    activity = [[ActivityView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44 - [VersionAdapter getMoreVarHead]) loadStr:NSLocalizedString(@"正在加载...", nil)];
    houseKeepingArr = [[NSMutableArray alloc]init];
    [self setupRefresh];
    [self setExtraCellLineHidden:setTable];
}

- (void) updatehouseKeeping: (NSNotification *) notification{
    NSDictionary * dic =[notification object];
    Housekeeping * inf = [dic objectForKey:@"information"];
    house.feedbackStatus =inf.feedbackStatus;
//    for (int i = 0 ; i < newsArr.count; i++) {
//        information * infself = [newsArr objectAtIndex:i];
//        if ([inf.typeName isEqualToString:infself.typeName]) {
//            infself.isSubscribe = inf.isSubscribe;
//            [setTable reloadData];
//        }
//    }
}



-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
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
    //    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}



- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [setTable addHeaderWithTarget:self action:@selector(headerRereshing)];
    [setTable headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [setTable addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    setTable.headerPullToRefreshText = @"下拉可以刷新了";
    setTable.headerReleaseToRefreshText = @"松开马上刷新了";
    setTable.headerRefreshingText = @"正在帮你刷新中";
    
    setTable.footerPullToRefreshText = @"上拉可以加载更多数据了";
    setTable.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    setTable.footerRefreshingText = @"正在帮你加载中";
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    BZAppDelegate *app = [UIApplication sharedApplication].delegate;
    isHead = YES;
    RequestUtil *requestUtil = [[RequestUtil alloc]init];
    //业务数据参数组织成JSON字符串
    NSString *biz = [NSString  stringWithFormat:@"{\"userId\":\"%@\",\"lastNum\":\"0\"}",app.userID];
    NSString *sid = @"QueryHouseServiceList";
    [requestUtil startRequest:sid biz:biz send:self];
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [setTable headerEndRefreshing];
        [setTable reloadData];
        
    });
}

- (void)footerRereshing
{
    BZAppDelegate *app = [UIApplication sharedApplication].delegate;
    isHead = NO;
    Housekeeping * houseK = [houseKeepingArr lastObject];
    RequestUtil *requestUtil = [[RequestUtil alloc]init];
    //业务数据参数组织成JSON字符串
    NSString *biz = [NSString  stringWithFormat:@"{\"userId\":\"%@\",\"lastNum\":\"%@\"}",app.userID,houseK.hsId];
    NSString *sid = @"QueryHouseServiceList";
    [requestUtil startRequest:sid biz:biz send:self];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [setTable footerEndRefreshing];
        [setTable reloadData];
    });
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
    NSArray *arr = [json objectForKey:@"houseService"];
    if (isHead) {
        houseKeepingArr = [[NSMutableArray alloc]init];
    }
    if ([json[@"status"]isEqualToString:@"success"]) {
        for (int i = 0; i <arr.count ; i++) {
            NSDictionary * rdic =[arr objectAtIndex:i];
            Housekeeping *houseK =[[Housekeeping alloc]init];
            houseK.hsId = [NSString stringWithFormat:@"%@",[rdic objectForKey:@"hsId"]];
            houseK.hsName = [NSString stringWithFormat:@"%@",[rdic objectForKey:@"hsName"]];
            houseK.typeName = [NSString stringWithFormat:@"%@",[rdic objectForKey:@"typeName"]];
            houseK.hsDetail = [NSString stringWithFormat:@"%@",[rdic objectForKey:@"hsDetail"]];
            houseK.hsTime = [NSString stringWithFormat:@"%@",[rdic objectForKey:@"hsTime"]];
            houseK.acceptTime = [NSString stringWithFormat:@"%@",[rdic objectForKey:@"acceptTime"]];
            houseK.acceptStatus = [NSString stringWithFormat:@"%@",[rdic objectForKey:@"acceptStatus"]];
            houseK.acceptRemark = [NSString stringWithFormat:@"%@",[rdic objectForKey:@"acceptRemark"]];
            houseK.acceptCompany = [NSString stringWithFormat:@"%@",[rdic objectForKey:@"acceptCompany"]];
            houseK.acceptBusinner = [NSString stringWithFormat:@"%@",[rdic objectForKey:@"acceptBusinner"]];
            houseK.acceptBusinnerMobile = [NSString stringWithFormat:@"%@",[rdic objectForKey:@"acceptBusinnerMobile"]];
            houseK.feedback = [NSString stringWithFormat:@"%@",[rdic objectForKey:@"feedback"]];
            houseK.feedbackDate = [NSString stringWithFormat:@"%@",[rdic objectForKey:@"feedbackDate"]];
            houseK.feedbackStatus = [[rdic objectForKey:@"feedbackStatus"] intValue];
            [houseKeepingArr addObject:houseK];
        }
        [setTable reloadData];
    }else{
        [SVProgressHUD showErrorWithStatus:json[@"message"]];
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [houseKeepingArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ComplainTableViewCell";
    ComplainTableViewCell  *newcell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!newcell) {
        newcell = [[ComplainTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [newcell setSelectionStyle:UITableViewCellSelectionStyleNone];
    Housekeeping * houseK = [houseKeepingArr objectAtIndex:indexPath.row];
    newcell.infoLabel.text = [NSString stringWithFormat:@"%@",houseK.hsTime];
    newcell.nameLabel.text = [NSString stringWithFormat:@"%@",houseK.hsName];
    return newcell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    house = [houseKeepingArr objectAtIndex:indexPath.row];
    HousekeepingInfoViewController *nic = [[HousekeepingInfoViewController alloc]init];
    nic.houseK = house;
    [self.navigationController pushViewController:nic animated:YES];
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
