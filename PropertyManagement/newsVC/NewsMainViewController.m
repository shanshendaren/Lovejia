
//
//  NewsMainViewController.m
//  PropertyManagement
//
//  Created by admin on 14/11/13.
//  Copyright (c) 2014年 admin. All rights reserved.
//

#import "NewsMainViewController.h"
#import "VersionAdapter.h"
#import "BZAppDelegate.h"
#import "RequestUtil.h"
#import "ActivityView.h"
#import "SVProgressHUD.h"
#import "information.h"
#import "SubscripTableViewCell.h"
#import "NewsListViewController.h"
#import "iToast.h"
#import "UIImageView+WebCache.h"

@interface NewsMainViewController ()

{
    UITableView *setTable;
    ActivityView *activity;
    NSMutableArray *newsArr;
    NSMutableArray * isArr;

}



@end

@implementation NewsMainViewController




-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    BZAppDelegate* app = (BZAppDelegate *)[UIApplication sharedApplication].delegate;
    [app.tabBar customTabBarHidden:YES];
    [self.navigationController.navigationBar setHidden:NO];
    [setTable reloadData];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [VersionAdapter setViewLayout:self];
  
    [self createUI];
    [self createBack];
    [self setExtraCellLineHidden:setTable];
    // Do any additional setup after loading the view.
}


-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    
    setTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,  self.view.frame.size.height-[VersionAdapter getMoreVarHead]-44)];
    setTable.delegate = self; setTable.dataSource = self;
    [self.view addSubview:setTable];
    setTable.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)createUI{
    self.title = @"生活资讯";
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:FONT_SIZE],NSFontAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNewsList:) name:@"updateNewsList" object:nil];
    setTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,  self.view.frame.size.height-[VersionAdapter getMoreVarHead]-44)];
    setTable.delegate = self; setTable.dataSource = self;
    [self.view addSubview:setTable];
    
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

- (void) updateNewsList: (NSNotification *) notification{
    NSDictionary * dic =[notification object];
    information * inf = [dic objectForKey:@"information"];
    for (int i = 0 ; i < newsArr.count; i++) {
        information * infself = [newsArr objectAtIndex:i];
        if ([inf.typeName isEqualToString:infself.typeName]) {
            infself.isSubscribe = inf.isSubscribe;
            [setTable reloadData];
        }
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
    if ([[json objectForKey:@"SID"]isEqualToString:@"SomeOneSubscribeList"]) {
        NSArray *arr = [json objectForKey:@"subscribeList"];
        if ([json[@"status"]isEqualToString:@"success"]) {
            for (int i = 0; i <arr.count ; i++) {
                NSDictionary * rdic =[arr objectAtIndex:i];
                information *ifm =[[information alloc]init];
                ifm.informationTypeId = [rdic objectForKey:@"typeId"];
                ifm.typeName = [rdic objectForKey:@"typeName"];
                ifm.isSubscribe = [[rdic objectForKey:@"isSubscribe"] boolValue];
                ifm.typePic = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[rdic objectForKey:@"type_img"]]];
                ifm.typeInfo = [rdic objectForKey:@"type_introduction"];
                [newsArr addObject:ifm];
            }
            [setTable reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:json[@"message"]];
        }
    }    if ([activity isVisible]) {
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

//-(void)doAlert:(NSString *)inMessage {
//    UIAlertView *alertDialog = [[UIAlertView alloc] initWithTitle:@"提示信息" message:inMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alertDialog show];
//}



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
    }
}





- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    isArr = [[NSMutableArray alloc]init];
    for (information * inf in newsArr) {
        if (inf.isSubscribe) {
            [isArr addObject:inf];
        }
    }
   return [isArr count];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SubscripTableViewCell";
    SubscripTableViewCell  *newcell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    
    if (!newcell) {
        newcell = [[SubscripTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

    }
    newcell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    information * inf = [isArr objectAtIndex:indexPath.row];
//    newcell.infoLabel.text = [NSString stringWithFormat:@"%@",inf.typeInfo];
    newcell.nameLabel.text = [NSString stringWithFormat:@"%@",inf.typeName];
    [newcell.imview sd_setImageWithURL:inf.typePic placeholderImage:[UIImage imageNamed:@"minion"]];
    [newcell.setBTN setHidden:YES];
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(40, 39, self.view.frame.size.width, 0.5)];
    view.backgroundColor = [UIColor colorWithWhite:0.95f alpha:1.0f];
    [newcell.contentView addSubview:view];
    return newcell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    information *inf = [isArr objectAtIndex:indexPath.row];
    NewsListViewController *nlc = [[NewsListViewController alloc]init];
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:nlc];
    nlc.newsType = inf.informationTypeId;
    nlc.newsName = inf.typeName;
    [self.navigationController pushViewController:nlc animated:NO];
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
