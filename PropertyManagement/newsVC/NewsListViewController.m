//
//  NewsListViewController.m
//  PropertyManagement
//
//  Created by admin on 14/11/19.
//  Copyright (c) 2014年 admin. All rights reserved.
//

#import "NewsListViewController.h"
#import "VersionAdapter.h"
#import "BZAppDelegate.h"
#import "RequestUtil.h"
#import "ActivityView.h"
#import "SVProgressHUD.h"
#import "information.h"
#import "SubscripTableViewCell.h"
#import "MJRefresh.h"
#import "NewsInfoViewController.h"

@interface NewsListViewController (){
    UITableView *setTable;
    ActivityView *activity;
    NSMutableArray *newsArr;
    BOOL isHead;
}

@end

@implementation NewsListViewController


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
    self.title = [NSString stringWithFormat:@"%@",self.newsName];
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];

    setTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,  self.view.frame.size.height-[VersionAdapter getMoreVarHead]-44)];
    setTable.delegate = self; setTable.dataSource = self;
    [self.view addSubview:setTable];
    
    activity = [[ActivityView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44 - [VersionAdapter getMoreVarHead]) loadStr:NSLocalizedString(@"正在加载...", nil)];
    newsArr = [[NSMutableArray alloc]init];
    [self setupRefresh];
    
    [self setExtraCellLineHidden:setTable];

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
//    [self dismissViewControllerAnimated:NO completion:^{
//        
//    }];
    [self.navigationController popViewControllerAnimated:NO];
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
    isHead = YES;
    RequestUtil *requestUtil = [[RequestUtil alloc]init];
    //业务数据参数组织成JSON字符串
    NSString *biz = [NSString  stringWithFormat:@"{\"typeId\":\"%@\",\"lastNum\":\"0\"}",self.newsType];
    NSString *sid = @"FindInformationByType";
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
    isHead = NO;
    information * inf = [newsArr lastObject];
    RequestUtil *requestUtil = [[RequestUtil alloc]init];
    //业务数据参数组织成JSON字符串
    if (inf) {
        NSString *biz = [NSString  stringWithFormat:@"{\"typeId\":\"%@\",\"lastNum\":\"%@\"}",self.newsType,inf.information_id];
        NSString *sid = @"FindInformationByType";
        [requestUtil startRequest:sid biz:biz send:self];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            [setTable footerEndRefreshing];
            [setTable reloadData];
        });
    }
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
    NSArray *arr = [json objectForKey:@"informations"];
    if (isHead) {
        newsArr = [[NSMutableArray alloc]init];
    }
    if ([json[@"status"]isEqualToString:@"success"]) {
        for (int i = 0; i <arr.count ; i++) {
            NSDictionary * rdic =[arr objectAtIndex:i];
            information *ifm =[[information alloc]init];
            ifm.information_id = [rdic objectForKey:@"info_id"];
            ifm.information_title = [rdic objectForKey:@"title"];
            ifm.information_picture_s = [rdic objectForKey:@"picture_s"] ;
            ifm.information_content = [rdic objectForKey:@"introduction"];
            ifm.createTime = [rdic objectForKey:@"createTime"];
            [newsArr addObject:ifm];
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
    information * inf = [newsArr objectAtIndex:indexPath.row];
    newcell.infoLabel.text = [NSString stringWithFormat:@"%@",inf.information_content];
    newcell.nameLabel.text = [NSString stringWithFormat:@"%@",inf.information_title];
    newcell.imview.image =[UIImage imageNamed:@"minion"];
    [newcell.setBTN setHidden:YES];
    return newcell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    information *inf = [newsArr objectAtIndex:indexPath.row];
    NewsInfoViewController *nic = [[NewsInfoViewController alloc]init];
    nic.newsId = inf.information_id;
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
