//
//  ChangeCommodityViewController.m
//  PropertyManagement
//
//  Created by admin on 15/1/5.
//  Copyright (c) 2015年 admin. All rights reserved.
//


#import "ChangeCommodityViewController.h"
#import "VersionAdapter.h"
#import "SetNewChangeViewController.h"

#import "RequestUtil.h"
#import "SVProgressHUD.h"
#import "BZAppDelegate.h"
#import "ActivityView.h"
#import "MJRefresh.h"
#import "Barter.h"
#import "UIImageView+WebCache.h"
#import "ValuablesDetailViewController.h"


@interface ChangeCommodityViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    ActivityView *activity;
    NSString *VallageNum;
    UITableView *setTable;
    NSMutableArray *barterArr;
    BOOL isHead;
}

@end

@implementation ChangeCommodityViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    BZAppDelegate* app = (BZAppDelegate *)[UIApplication sharedApplication].delegate;
    [app.tabBar customTabBarHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [VersionAdapter setViewLayout:self];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.title = @"物品交换";
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:FONT_SIZE],NSFontAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    [self createBack];
    // Do any additional setup after loading the view.
    setTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,  self.view.frame.size.height-[VersionAdapter getMoreVarHead]-44)style:UITableViewStyleGrouped];
    setTable.delegate = self;
    setTable.dataSource = self;
    [self.view addSubview:setTable];
    
    activity = [[ActivityView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44 - [VersionAdapter getMoreVarHead]) loadStr:NSLocalizedString(@"正在加载...", nil)];
    barterArr = [[NSMutableArray alloc]init];
    [self setupRefresh];
    //[self getListInfo];
}



-(void)getListInfo
{
    BZAppDelegate *app =[UIApplication sharedApplication].delegate;
    RequestUtil *requestUtil = [[RequestUtil alloc]init];
    //业务数据参数组织成JSON字符串
    NSString *biz = [NSString  stringWithFormat:@"{\"vallageId\":\"%@\",\"lastNum\":\"0\"}",app.vallageID];
    NSString *sid = @"QueryBarterInfoList";
    [requestUtil startRequest:sid biz:biz send:self];
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
    NSString *biz = [NSString  stringWithFormat:@"{\"vallageId\":\"%@\",\"lastNum\":\"0\"}",app.vallageID];
    NSString *sid = @"QueryBarterInfoList";
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
    Barter * barter = [barterArr lastObject];
    RequestUtil *requestUtil = [[RequestUtil alloc]init];
    if (barter) {
        //业务数据参数组织成JSON字符串
        NSString *biz = [NSString  stringWithFormat:@"{\"vallageId\":\"%@\",\"lastNum\":\"%@\"}",app.vallageID,barter.barterInfoId];
        NSString *sid = @"QueryBarterInfoList";
        [requestUtil startRequest:sid biz:biz send:self];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            [setTable footerEndRefreshing];
            [setTable reloadData];
        });
    }
}

-(void)requestCompleted:(ASIHTTPRequest *)request{
    NSError *error;
    //获取接口总线返回的结果
    NSString *returnData = [request responseString];
    NSData *jsonData = [returnData dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    NSArray *arr = [json objectForKey:@"barterInfo"];
    NSLog(@"------arr----%@",arr);
    if (isHead) {
        barterArr = [[NSMutableArray alloc]init];
    }
    if ([json[@"status"]isEqualToString:@"success"]) {
        if ([json[@"isComplete"]isEqualToString:@"yes"]) {
            [SVProgressHUD showSuccessWithStatus:@"数据加载完毕"];
        }
        else{
            for (int i = 0; i <arr.count ; i++) {
                NSDictionary * rdic =[arr objectAtIndex:i];
                Barter *barter =[[Barter alloc]init];
                barter.barterInfoId = [rdic objectForKey:@"barterInfoId"];
                barter.barterInfoTitle = [NSString stringWithFormat:@"%@",[rdic objectForKey:@"barterInfoTitle"]];
                barter.barterInfoContent = [NSString stringWithFormat:@"%@",[rdic objectForKey:@"barterInfoContent"] ];
                barter.repaeaseDate =[NSString stringWithFormat:@"%@",rdic[@"repaeaseDate"]];
                barter.repaeaseName = [NSString stringWithFormat:@"%@",rdic[@"repaeaseName"]];
                
                barter.repaeaseTel = [NSString stringWithFormat:@"%@",rdic[@"repaeaseTel"]];
                barter.isOpen = [NSString stringWithFormat:@"%@",rdic[@"isOpen"]];
                barter.status = [NSString stringWithFormat:@"%@",rdic[@"status"]];
                barter.registrationId = [NSString stringWithFormat:@"%@",rdic[@"registrationId"]];
                barter.deviceType = [NSString stringWithFormat:@"%@",rdic[@"deviceType"]];
                barter.photos = [[NSArray alloc]initWithArray:[rdic objectForKey:@"photos"]];
                [barterArr addObject:barter];
            }
            [setTable reloadData];
        }
    }else{
        [SVProgressHUD showErrorWithStatus:json[@"message"]];
    }
    if ([activity isVisible]) {
        [activity stopAcimate];
    }
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [barterArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ComplainTableViewCell";
    UITableViewCell  *newcell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!newcell) {
        newcell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 30)];
        titleLabel.tag = 101;
        titleLabel.font= [UIFont systemFontOfSize:FONT_SIZE];
        [newcell.contentView addSubview:titleLabel];
        
        
        UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, 200, 20)];
        contentLabel.tag = 102;
        contentLabel.textColor = [UIColor grayColor];
        contentLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
        [newcell.contentView addSubview:contentLabel];
        
        UILabel *jianjieLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 200, 20)];
        jianjieLabel.tag = 103;
        jianjieLabel.textColor = [UIColor grayColor];
        jianjieLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
        [newcell.contentView addSubview:jianjieLabel];
        
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(240, 10, 70, 50)];
        image.tag = 104;
        [newcell.contentView addSubview:image];
        
        
    }
    [newcell setSelectionStyle:UITableViewCellSelectionStyleNone];
    Barter * barter = [barterArr objectAtIndex:indexPath.section];
    NSLog(@"%@",barter.photos);
    //NSArray *aa = barter.photos[0];
    NSString *paths;
    if (barter.photos.count == 0) {
        paths = nil;
    }
    else
    {
        NSDictionary *dic = [[NSDictionary alloc]initWithDictionary:barter.photos[0]];
        paths = [NSString stringWithFormat:@"%@",dic[@"paths"]];
    }
    
    for (UIView *v in newcell.contentView.subviews) {
        switch (v.tag) {
            case 101:
            {
                ((UILabel *)v).text = [NSString stringWithFormat:@"%@",barter.barterInfoTitle];
            }
                break;
            case 102:
            {
                ((UILabel *)v).text = [[NSString stringWithFormat:@"%@",barter.barterInfoContent]stringByReplacingOccurrencesOfString:@"\\n" withString:@"\r\n"];
            }
                break;
            case 103:
            {
                ((UILabel *)v).text = [NSString stringWithFormat:@"%@  %@",barter.repaeaseName,barter.repaeaseDate];
            }
                break;
            case 104:
            {
                [(UIImageView *)v sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",paths]] placeholderImage:nil];
            }
                break;
                
            default:
                break;
        }
    }
    return newcell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Barter * barter = [barterArr objectAtIndex:indexPath.section];
    ValuablesDetailViewController *view = [[ValuablesDetailViewController alloc]init];
    view.valuablesInfo = barter;
    view.selfType = @"1001";
    [self.navigationController pushViewController:view animated:YES];
    
}

-(void)requestError:(ASIHTTPRequest *)request{
    NSError *error = [request error];
    if ([activity isVisible]) {
        [activity stopAcimate];
    }
    [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
}




-(void)createBack{
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 15, 15);
    backButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    
    UIButton *newBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [newBtn setFrame:CGRectMake(self.view.frame.size.width-60, 0, 60, 30)];
    UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    lable1.textAlignment = NSTextAlignmentRight;
    lable1.text = @"新建";
    lable1.font = [UIFont systemFontOfSize:FONT_SIZE];
    [newBtn addSubview:lable1];
    [newBtn addTarget:self action:@selector(pushAction) forControlEvents:UIControlEventTouchUpInside];
    [newBtn setTintColor:[UIColor lightGrayColor]];
//    [newBtn setBackgroundImage:[UIImage imageNamed:@"save.png"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:newBtn];
    
}

-(void)backAction{
    [self dismissViewControllerAnimated:NO completion:^{
    }];
//     [self.navigationController popViewControllerAnimated:NO];
}


-(void)pushAction{
    SetNewChangeViewController *svc =[[SetNewChangeViewController alloc]init];
    [self.navigationController pushViewController:svc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
