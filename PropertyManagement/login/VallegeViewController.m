//
//  VallegeViewController.m
//  PropertyManagement
//
//  Created by admin on 15/1/28.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "VallegeViewController.h"
#import "VersionAdapter.h"
#import "ActivityView.h"
#import "RequestUtil.h"
#import "SVProgressHUD.h"
#import "Vallage.h"

@interface VallegeViewController (){
    UITableView *setTable;
    ActivityView *activity;
    NSMutableArray *cityArr;
}

@end

@implementation VallegeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [VersionAdapter setViewLayout:self];
    [self createUI];
    [self createBack];
    
    // Do any additional setup after loading the view.
}

-(void)createUI{
    self.title = [NSString stringWithFormat:@"选择地区"];
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    setTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,  self.view.frame.size.height-[VersionAdapter getMoreVarHead]-44)];
    setTable.delegate = self;
    setTable.dataSource = self;
    [self.view addSubview:setTable];
    activity = [[ActivityView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44 - [VersionAdapter getMoreVarHead]) loadStr:NSLocalizedString(@"正在加载...", nil)];
    [self setExtraCellLineHidden:setTable];
    cityArr = [[NSMutableArray alloc]init];
    if([self.type isEqualToString:@"1"] ){
        RequestUtil *requestUtil = [[RequestUtil alloc]init];
        //业务数据参数组织成JSON字符串
        NSString *biz = [NSString  stringWithFormat:@"{\"orgCode\":\"001001\",\"orgLevel\":\"2\"}"];
        NSString *sid = @"QueryListOrg";
//        NSLog(@"biaOrg-->%@",biz);
        [requestUtil startRequest:sid biz:biz send:self];
    }
}


-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
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
      NSLog(@"VreturnData->%@,VjsonData->%@,Vjson-->%@",returnData,jsonData,json);
    if ([activity isVisible]) {
        [activity stopAcimate];
    }
    
    if ([json[@"status"]isEqualToString:@"success"]) {
        if ([json objectForKey:@"orgInfo"]) {
            NSArray *arr = [json objectForKey:@"orgInfo"];
            for ( int i = 0;i< arr.count;i++ ) {
                NSDictionary * dic =[arr objectAtIndex:i];
                Vallage* val =[[Vallage alloc]init];
                val.orgId = dic[@"orgCode"];
                val.orgName = dic[@"orgName"];
                [cityArr addObject:val];
            }
            [setTable reloadData];
        }
    }else{
        [SVProgressHUD showErrorWithStatus:json[@"message"]];
    }
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
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return cityArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell  *newcell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!newcell) {
        newcell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if ([self.type isEqualToString:@"1"]) {
        newcell.textLabel.text =[NSString stringWithFormat:@"%@",((Vallage *)[cityArr objectAtIndex:indexPath.row]).orgName];
    }
    return newcell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.type isEqualToString:@"1"]) {
        Vallage *val =[cityArr objectAtIndex:indexPath.row];
        NSDictionary *dictionary = [NSDictionary dictionaryWithObject:val forKey:@"Vallage"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateOrg" object:dictionary];
        [self dismissViewControllerAnimated:YES completion:^{
        }];
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
