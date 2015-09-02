//
//  MysendCarViewController.m
//  PropertyManagement
//
//  Created by admin on 15/3/11.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "MysendCarViewController.h"
#import "VersionAdapter.h"
#import "RequestUtil.h"
#import "SVProgressHUD.h"
#import "BZAppDelegate.h"
#import "ActivityView.h"
#import "MJRefresh.h"
#import "Carpooling.h"
#import "UIImageView+WebCache.h"
#import "CarpoolingInfoViewController.h"


@interface MysendCarViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    ActivityView *activity;
    NSString *VallageNum;
    UITableView *setTable;
    NSMutableArray *carArr;
    BOOL isHead;
    
    NSInteger currentIndex;
}


@end

@implementation MysendCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [VersionAdapter setViewLayout:self];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self createBack];
    // Do any additional setup after loading the view.
    setTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,  self.view.frame.size.height-[VersionAdapter getMoreVarHead]-44-40)style:UITableViewStyleGrouped];
    setTable.delegate = self;
    setTable.dataSource = self;
    [self.view addSubview:setTable];
    
    activity = [[ActivityView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44 - [VersionAdapter getMoreVarHead]) loadStr:NSLocalizedString(@"正在加载...", nil)];
    carArr = [[NSMutableArray alloc]init];
    [self setupRefresh];

    // Do any additional setup after loading the view.
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
    NSString *sid = @"QueryPageNeighborhordCarpoolListByself";
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
    Carpooling * car = [carArr lastObject];
    RequestUtil *requestUtil = [[RequestUtil alloc]init];
    if (car) {
        //业务数据参数组织成JSON字符串
        NSString *biz = [NSString  stringWithFormat:@"{\"userId\":\"%@\",\"lastNum\":\"%@\"}",app.userID,car.neighborhordCarpoolInfoId];
        NSString *sid = @"QueryPageNeighborhordCarpoolListByself";
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
    NSArray *arr = [json objectForKey:@"neighborhordCarpoolInfoList"];
    if (isHead) {
        carArr = [[NSMutableArray alloc]init];
    }
    if ([json[@"status"]isEqualToString:@"success"]) {
        if (request.tag !=100) {
            if ([json[@"isComplete"]isEqualToString:@"yes"]) {
                [SVProgressHUD showSuccessWithStatus:@"数据加载完毕"];
            }
            else{
                for (int i = 0; i <arr.count ; i++) {
                    NSDictionary * rdic =[arr objectAtIndex:i];
                    Carpooling *car =[[Carpooling alloc]init];
                    car.neighborhordCarpoolInfoId = [rdic objectForKey:@"neighborhordCarpoolInfoId"];
                    car.neighborhordCarpoolInfoTitle = [NSString stringWithFormat:@"%@",[rdic objectForKey:@"neighborhordCarpoolInfoTitle"]];
                    car.neighborhordCarpoolInfoContent = [NSString stringWithFormat:@"%@",[rdic objectForKey:@"neighborhordCarpoolInfoContent"] ];
                    car.repaeaseDate =[NSString stringWithFormat:@"%@",rdic[@"repaeaseDate"]];
                    car.repaeaseName = [NSString stringWithFormat:@"%@",rdic[@"repaeaseName"]];
                    car.repaeaseTel = [NSString stringWithFormat:@"%@",rdic[@"repaeaseTel"]];
                    car.registrationId = [NSString stringWithFormat:@"%@",rdic[@"registrationId"]];
                    car.deviceType = [NSString stringWithFormat:@"%@",rdic[@"deviceType"]];
                    car.isOpen = [NSString stringWithFormat:@"%@",rdic[@"isOpen"]];
                    car.status = [NSString stringWithFormat:@"%@",rdic[@"status"]];
                    car.startPlace = [NSString stringWithFormat:@"%@",rdic[@"startPlace"]];
                    car.endPlace = [NSString stringWithFormat:@"%@",rdic[@"endPlace"]];
                    car.isAgree = [NSString stringWithFormat:@"%@",rdic[@"isAgree"]];
                    car.commentContent = [NSString stringWithFormat:@"%@",rdic[@"commentContent"]];
                    
                    car.line = [NSString stringWithFormat:@"%@",rdic[@"line"]];
                    car.type = [NSString stringWithFormat:@"%@",rdic[@"type"]];
                    car.photos = [[NSArray alloc]initWithArray:[rdic objectForKey:@"photos"]];
                    [carArr addObject:car];
                }
                [setTable reloadData];
            }
        }
        else if (request.tag ==100){
            [setTable beginUpdates];
            [setTable deleteSections:[NSIndexSet indexSetWithIndex:currentIndex] withRowAnimation:UITableViewRowAnimationFade];
            [carArr removeObjectAtIndex:currentIndex];
            [setTable endUpdates];
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
    return [carArr count];
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
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ComplainTableViewCell";
    UITableViewCell  *newcell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!newcell) {
        newcell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UIImageView *backView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ip5_03.png"]];
        [newcell setBackgroundView:backView];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 30)];
        titleLabel.tag = 101;
        titleLabel.font= [UIFont systemFontOfSize:16.f];
        [newcell.contentView addSubview:titleLabel];
        
        
        UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, 200, 20)];
        contentLabel.tag = 102;
        contentLabel.textColor = [UIColor grayColor];
        contentLabel.font = [UIFont systemFontOfSize:12.f];
        [newcell.contentView addSubview:contentLabel];
        
        UILabel *jianjieLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 200, 20)];
        jianjieLabel.tag = 103;
        jianjieLabel.textColor = [UIColor grayColor];
        jianjieLabel.font = [UIFont systemFontOfSize:12.f];
        [newcell.contentView addSubview:jianjieLabel];
        
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(240, 10, 70, 50)];
        image.tag = 104;
        [newcell.contentView addSubview:image];
        
        
    }
//    [newcell setSelectionStyle:UITableViewCellSelectionStyleNone];
    Carpooling * car = [carArr objectAtIndex:indexPath.section];
    //NSArray *aa = barter.photos[0];
    NSString *paths;
    if (car.photos.count == 0) {
        paths = nil;
    }
    
    else
    {
        
        NSDictionary *dic = [[NSDictionary alloc]initWithDictionary:car.photos[0]];
        paths = [NSString stringWithFormat:@"%@",dic[@"paths"]];
    }
    
    for (UIView *v in newcell.contentView.subviews) {
        switch (v.tag) {
            case 101:
            {
                ((UILabel *)v).text = [NSString stringWithFormat:@"%@",car.neighborhordCarpoolInfoTitle];
            }
                break;
            case 102:
            {
                ((UILabel *)v).text = [[NSString stringWithFormat:@"%@",car.neighborhordCarpoolInfoContent]stringByReplacingOccurrencesOfString:@"\\n" withString:@"\r\n"];
            }
                break;
            case 103:
            {
                ((UILabel *)v).text = [NSString stringWithFormat:@"%@  %@",car.repaeaseName,car.repaeaseDate];
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


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    Carpooling * car = [carArr objectAtIndex:indexPath.section];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        isHead = NO;
        currentIndex =indexPath.section;
        RequestUtil *requestUtil = [[RequestUtil alloc]init];
        //业务数据参数组织成JSON字符串
        NSString *biz = [NSString  stringWithFormat:@"{\"status\":\"-1\",\"neighborhordCarpoolId\":\"%@\"}",car.neighborhordCarpoolInfoId];
        NSString *sid = @"ManagementNeighborhordCarpoolInfo";
        [requestUtil startRequest:sid biz:biz send:self requestTag:100];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}


- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [setTable deselectRowAtIndexPath:indexPath animated:YES];
    
    Carpooling * car = [carArr objectAtIndex:indexPath.section];
    CarpoolingInfoViewController *view = [[CarpoolingInfoViewController alloc]init];
    view.car = car;
    view.selfType = @"12";
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
}

-(void)backAction{
    [self dismissViewControllerAnimated:NO completion:^{
    }];
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
