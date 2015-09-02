//
//  SaleListViewController.m
//  PropertyManagement
//
//  Created by admin on 15/2/27.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "SaleListViewController.h"
#import "VersionAdapter.h"
#import "RequestUtil.h"
#import "SVProgressHUD.h"
#import "BZAppDelegate.h"
#import "ActivityView.h"
#import "MJRefresh.h"
#import "House.h"
#import "NoticeTableViewCell.h"
#import "BuyHoseInfoViewController.h"


@interface SaleListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *setTable;
    ActivityView *activity;
    NSMutableArray *houseArr;
    BOOL isHead;
}



@end

@implementation SaleListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [VersionAdapter setViewLayout:self];
    [self createUI];
    // Do any additional setup after loading the view.
}

-(void)createUI{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    isHead = NO;
    setTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,  self.view.frame.size.height-[VersionAdapter getMoreVarHead]-44-40)];
    setTable.delegate = self; setTable.dataSource = self;
    [self.view addSubview:setTable];
    
    activity = [[ActivityView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44 - [VersionAdapter getMoreVarHead]) loadStr:NSLocalizedString(@"正在加载...", nil)];
    houseArr = [[NSMutableArray alloc]init];
    [self setupRefresh];
    [self setExtraCellLineHidden:setTable];
}
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
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
    NSString *biz = [NSString  stringWithFormat:@"{\"vallageId\":\"%@\",\"lastNum\":\"0\",\"saleType\":\"1\"}",app.vallageID];
    NSString *sid = @"QuerySecondarysaleInfoList";
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
    House * house = [houseArr lastObject];
    RequestUtil *requestUtil = [[RequestUtil alloc]init];
    if (house) {
        //业务数据参数组织成JSON字符串
        NSString *biz = [NSString  stringWithFormat:@"{\"vallageId\":\"%@\",\"lastNum\":\"%@\",\"saleType\":\"0\"}",app.vallageID,house.secondarysaleInfoId];
        NSString *sid = @"QuerySecondarysaleInfoList";
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
    NSArray *arr = [json objectForKey:@"secondarysaleInfo"];
    if (isHead) {
        houseArr = [[NSMutableArray alloc]init];
    }
    if ([json[@"status"]isEqualToString:@"success"]) {
        for (int i = 0; i <arr.count ; i++) {
            NSDictionary * rdic =[arr objectAtIndex:i];
            House *house =[[House alloc]init];
            house.secondarysaleInfoId = [rdic objectForKey:@"secondarysaleInfoId"];
            house.secondarysaleInfoTitle = [rdic objectForKey:@"secondarysaleInfoTitle"];
            house.secondarysaleContent = [rdic objectForKey:@"secondarysaleContent"];
            house.houseType = [rdic objectForKey:@"houseType"];
            house.houseAddress = [rdic objectForKey:@"houseAddress"];
            house.housePrice = [rdic objectForKey:@"housePrice"];
            house.repaeaseDate = [rdic objectForKey:@"repaeaseDate"];
            house.repaeaseName = [rdic objectForKey:@"repaeaseName"];
            house.repaeaseTel = [rdic objectForKey:@"repaeaseTel"];
            house.saleType = [rdic objectForKey:@"saleType"];
            house.photos = [[NSArray alloc]initWithArray:[rdic objectForKey:@"photos"]];
            [houseArr addObject:house];
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
    return [houseArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NoticeTableViewCell";
    NoticeTableViewCell  *newcell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!newcell) {
        newcell = [[NoticeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [newcell setSelectionStyle:UITableViewCellSelectionStyleNone];
    House * house = [houseArr objectAtIndex:indexPath.row];
    newcell.timeLabel.text = [NSString stringWithFormat:@"%@",house.repaeaseDate];
    newcell.nameLabel.text = [NSString stringWithFormat:@"%@",house.secondarysaleInfoTitle];
    newcell.infoLabel.text =[NSString stringWithFormat:@"%@",house.secondarysaleContent];
    return newcell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    House *house = [houseArr objectAtIndex:indexPath.row];
    BuyHoseInfoViewController *nic = [[BuyHoseInfoViewController alloc]init];
    nic.house = house;
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
