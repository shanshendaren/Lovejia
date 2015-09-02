//
//  CarpoolingDiscussViewController.m
//  PropertyManagement
//
//  Created by admin on 15/3/11.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "CarpoolingDiscussViewController.h"
#import "VersionAdapter.h"
#import "BZAppDelegate.h"
#import "RequestUtil.h"
#import "ActivityView.h"
#import "SVProgressHUD.h"
#import "MJRefresh.h"
#import "Discuss.h"
#import "DisTableViewCell.h"

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f



@interface CarpoolingDiscussViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *setTable;
    ActivityView *activity;
    NSMutableArray *disArr;
    BOOL isHead;
    NSMutableArray *items;
    
    NSInteger currentTag;
}
@end

@implementation CarpoolingDiscussViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [VersionAdapter setViewLayout:self];
    [self createUI];
    [self createBack];
    // Do any additional setup after loading the view.
}

-(void)createUI{
    isHead = NO;
    self.title =@"评论";
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    setTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,  self.view.frame.size.height-[VersionAdapter getMoreVarHead]-44)];
    setTable.delegate = self; setTable.dataSource = self;
    [self.view addSubview:setTable];
    
    activity = [[ActivityView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44 - [VersionAdapter getMoreVarHead]) loadStr:NSLocalizedString(@"正在加载...", nil)];
    disArr = [[NSMutableArray alloc]init];
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
    [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark- 开始进入刷新状态
- (void)headerRereshing
{
    isHead = YES;
    RequestUtil *requestUtil = [[RequestUtil alloc]init];
    //业务数据参数组织成JSON字符串
    NSString *biz = [NSString  stringWithFormat:@"{\"neighborhordCarpoolId\":\"%@\",\"lastNum\":\"0\"}",self.car.neighborhordCarpoolInfoId];
    NSString *sid = @"QueryNeighborhordCarpoolCommonInfoList";
    [requestUtil startRequest:sid biz:biz send:self requestTag:1];
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
    Discuss * dis = [disArr lastObject];
    RequestUtil *requestUtil = [[RequestUtil alloc]init];
    //业务数据参数组织成JSON字符串
    NSString *biz = [NSString  stringWithFormat:@"{\"neighborhordCarpoolId\":\"%@\",\"lastNum\":\"%@\"}",self.car.neighborhordCarpoolInfoId,dis.barterCommentInfoId];
    NSString *sid = @"QueryNeighborhordCarpoolCommonInfoList";
    [requestUtil startRequest:sid biz:biz send:self requestTag:1];
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
    NSArray *arr = [json objectForKey:@"commonInfoList"];
    if (isHead) {
        disArr = [[NSMutableArray alloc]init];
    }
    if ([json[@"status"]isEqualToString:@"success"]) {
        if (request.tag ==1) {
            for (int i = 0; i <arr.count ; i++) {
                NSDictionary * rdic =[arr objectAtIndex:i];
                Discuss *dis =[[Discuss alloc]init];
                dis.barterCommentInfoId = [NSString stringWithFormat:@"%@",[rdic objectForKey:@"commentInfoId"]];
                dis.barterInfoId = [NSString stringWithFormat:@"%@",[rdic objectForKey:@"neighborhordCarpoolCommentInfoId"]];
                dis.barterCommentContent = [NSString stringWithFormat:@"%@",[rdic objectForKey:@"commentContent"]];
                dis.criticsDate = [NSString stringWithFormat:@"%@",[rdic objectForKey:@"criticsDate"]];
                dis.isAgree = [NSString stringWithFormat:@"%@",[rdic objectForKey:@"isAgree"]];
                dis.ownerName = [NSString stringWithFormat:@"%@",[rdic objectForKey:@"ownerName"]];
                dis.ownerTel = [NSString stringWithFormat:@"%@",[rdic objectForKey:@"ownerTel"]];
                dis.registrationId = [NSString stringWithFormat:@"%@",[rdic objectForKey:@"registrationId"]];
                dis.deviceType = [NSString stringWithFormat:@"%@",[rdic objectForKey:@"deviceType"]];
                dis.vallageName = [NSString stringWithFormat:@"%@",[rdic objectForKey:@"vallageName"]];
                [disArr addObject:dis];
            }
            [setTable reloadData];
        }
        else if(request.tag ==100){
            Discuss *dis =[disArr objectAtIndex:currentTag];
            dis.isAgree = [NSString stringWithFormat:@"0"];
            [SVProgressHUD showSuccessWithStatus:json[@"message"]];
        }
        else if(request.tag ==101){
            Discuss *dis =[disArr objectAtIndex:currentTag];
            dis.isAgree = [NSString stringWithFormat:@"1"];
            [SVProgressHUD showSuccessWithStatus:json[@"message"]];
        }
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
    return [disArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Discuss *dis= [disArr objectAtIndex:[indexPath row]];
    NSString *text =[NSString stringWithFormat:@"%@",dis.barterCommentContent];
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    CGFloat height = MAX(size.height, 20);
    return height + (CELL_CONTENT_MARGIN * 2) +50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DisTableViewCell";
    UILabel *label = nil;
    DisTableViewCell  *newcell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!newcell) {
        newcell = [[DisTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        [label setLineBreakMode:NSLineBreakByWordWrapping];
        [label setNumberOfLines:0];
        [label setFont:[UIFont systemFontOfSize:FONT_SIZE]];
        [label setTag:1];
        [[newcell contentView] addSubview:label];
    }
    [newcell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    Discuss *dis= [disArr objectAtIndex:[indexPath row]];
    newcell.nameLabel.text = [NSString stringWithFormat:@"评论人:%@",dis.ownerName];
    newcell.timeLabel.text = [NSString stringWithFormat:@"时间:%@",dis.criticsDate];
    NSString *text =[NSString stringWithFormat:@"%@",dis.barterCommentContent];
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    if (!label){
        label = (UILabel*)[newcell viewWithTag:1];
    }
    [label setText:text];
    [label setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN+20, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAX(size.height, 20.0f))];
    
    UIButton * agreeBTN =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [agreeBTN setFrame:CGRectMake(200, label.frame.size.height + 45, 50, 20)];
    [agreeBTN setTitle:@"同意" forState:UIControlStateNormal];
    agreeBTN.tag = indexPath.row;
    [agreeBTN addTarget:self action:@selector(agreeAction:) forControlEvents:UIControlEventTouchUpInside];
    [newcell.contentView addSubview:agreeBTN];
    
    UIButton * disagreeBTN =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [disagreeBTN setFrame:CGRectMake(260, label.frame.size.height + 45, 50, 20)];
    [disagreeBTN setTitle:@"拒绝" forState:UIControlStateNormal];
    disagreeBTN.tag = indexPath.row;
    [disagreeBTN addTarget:self action:@selector(disagreeAction:) forControlEvents:UIControlEventTouchUpInside];
    [newcell.contentView addSubview:disagreeBTN];
    return newcell;
}

-(void)disagreeAction:(UIButton *)sender{
    if (disArr.count >0) {
        Discuss *dis =[disArr objectAtIndex:sender.tag];
        if ([dis.isAgree isEqualToString:@"1"]||[dis.isAgree isEqualToString:@"0"]) {
            UIAlertView *aler =[[UIAlertView alloc]initWithTitle:@"提示" message:@"您已经同意或拒绝过该评论" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [aler show];
        }else {
            isHead = NO;
            currentTag = sender.tag;
            RequestUtil *requestUtil = [[RequestUtil alloc]init];
            //业务数据参数组织成JSON字符串
            NSString *biz = [NSString  stringWithFormat:@"{\"commonInfoId\":\"%@\",\"dealWithReslut\":\"0\",\"registrationId\":\"%@\",\"deviceType\":\"%@\"}",dis.barterCommentInfoId,self.car.registrationId,self.car.deviceType];
            NSString *sid = @"DealWithNeighborhordCarpoolCommonInfo";
            [requestUtil startRequest:sid biz:biz send:self requestTag:100];
        }
    }
}


-(void)agreeAction:(UIButton *)sender{
    if (disArr.count >0) {
        Discuss *dis =[disArr objectAtIndex:sender.tag];
        if ([dis.isAgree isEqualToString:@"1"]||[dis.isAgree isEqualToString:@"0"]) {
            UIAlertView *aler =[[UIAlertView alloc]initWithTitle:@"提示" message:@"您已经同意或拒绝过该评论" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [aler show];
        }else {
            isHead = NO;
            currentTag = sender.tag;
            RequestUtil *requestUtil = [[RequestUtil alloc]init];
            //业务数据参数组织成JSON字符串
            NSString *biz = [NSString  stringWithFormat:@"{\"commonInfoId\":\"%@\",\"dealWithReslut\":\"1\",\"registrationId\":\"%@\",\"deviceType\":\"%@\"}",dis.barterCommentInfoId,self.car.registrationId,self.car.deviceType];
            NSString *sid = @"DealWithNeighborhordCarpoolCommonInfo";
            [requestUtil startRequest:sid biz:biz send:self requestTag:101];
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
