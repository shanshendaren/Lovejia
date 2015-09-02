//
//  Vallage1ViewController.m
//  PropertyManagement
//
//  Created by mac on 15/7/21.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "Vallage1ViewController.h"
#import "VersionAdapter.h"
#import "ActivityView.h"
#import "RequestUtil.h"
#import "SVProgressHUD.h"
#import "Vallage.h"
#import "BZProtocol.h"

@interface Vallage1ViewController ()
{
    UITableView *setTable;
    UISearchBar *search;
    ActivityView *activity;
    NSMutableArray *cityArr;
}
@end

@implementation Vallage1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置索引
    setTable.sectionIndexBackgroundColor = [UIColor clearColor];
    setTable.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
    
    setTable.sectionIndexMinimumDisplayRowCount = 1;
    
    [VersionAdapter setViewLayout:self];
    
    [self createUI];
    [self createSearchView];
    [self setVallage];
    [self createBack];
    
    // Do any additional setup after loading the view.
}

-(void)createUI{
    self.title = [NSString stringWithFormat:@"选择小区"];
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    setTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,  self.view.frame.size.height-[VersionAdapter getMoreVarHead]-44)];
    //设置数据源
    setTable.delegate = self;
    setTable.dataSource = self;
    [self.view addSubview:setTable];
}

-(void)setVallage{
//    activity = [[ActivityView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44 - [VersionAdapter getMoreVarHead]) loadStr:NSLocalizedString(@"正在加载...", nil)];
        RequestUtil *requestUtil = [[RequestUtil alloc]init];
        //业务数据参数组织成JSON字符串
        NSString *biz = [NSString  stringWithFormat:@"Protocol"];
        NSString *sid = @"Protocol";
        NSLog(@"biawqwdasOrg-->%@",biz);
        [requestUtil startRequest:sid biz:biz send:self];
    }


-(void)setJsonView {
    activity = [[ActivityView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44 - [VersionAdapter getMoreVarHead]) loadStr:NSLocalizedString(@"正在加载...", nil)];
    if(self.value != nil){
        cityArr = [[NSMutableArray alloc]init];
        if([self.type isEqualToString:@"1"] ){
            RequestUtil *requestUtil = [[RequestUtil alloc]init];
            //业务数据参数组织成JSON字符串
            NSString *biz = [NSString  stringWithFormat:@"{\"orgCode\":\"%@\",\"type\":\"%@\",\"value\":\"%@\"}",self.orgId,self.type1,self.value];
            NSString *sid = @"QueryListVallage";
            NSLog(@"biawqwdasOrg-->%@",biz);
            [requestUtil startRequest:sid biz:biz send:self];
        }
    }
}

#pragma mark- 不知道是什么 -
//-(void)setExtraCellLineHidden: (UITableView *)tableView
//{
//    UIView *view = [UIView new];
//    view.backgroundColor = [UIColor redColor];
////    UISearchBar *searchVc = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
//    [tableView setTableFooterView:view];
//}



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
    NSLog(@"returnData->%@,jsonData->%@,json-->%@",returnData,jsonData,json);
    if ([activity isVisible]) {
        [activity stopAcimate];
    }
    if ([json[@"status"]isEqualToString:@"success"]) {
        if([json objectForKey:@"protocol"]){
            NSString *str = [json objectForKey:@"protocol"];
            BZProtocol *pro = [BZProtocol sharedManager];
            pro.protocol2 = str;
            NSLog(@"protocol1->%@  str->%@",pro,str);
        }
        if ([json objectForKey:@"vallageInfo"]) {
            NSArray *arr = [json objectForKey:@"vallageInfo"];
            for ( int i = 0;i< arr.count;i++ ) {
                NSDictionary * dic =[arr objectAtIndex:i];
                Vallage* val =[[Vallage alloc]init];
                val.vallageId = dic[@"vallageId"];
                val.vallageName = dic[@"vallageName"];
                NSLog(@"%@",val);
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
#pragma mark- 创建搜索框 -
//创建搜索框
-(void)createSearchView{
    search = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    search.keyboardType = UIKeyboardTypeDefault;
    search.placeholder = @"请输入小区名";
    search.autocorrectionType = UITextAutocorrectionTypeYes;
    search.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
    search.delegate = self;
    [setTable setTableHeaderView:search];
    
}

//实现搜索框的协议
-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    return YES;
}

//实现点击事件
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    self.type1 = @"1";
    self.value = searchBar.text;
    [self setJsonView];
    
}

#pragma mark-  返回按钮 -
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

#pragma mark- 设置tableCellView的数据源和大小高与重用 -
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
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell  *newcell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!newcell) {
        newcell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if ([self.type isEqualToString:@"1"]){
        newcell.textLabel.text =[NSString stringWithFormat:@"%@",((Vallage *)[cityArr objectAtIndex:indexPath.row]).vallageName];
    }
    return newcell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.type isEqualToString:@"1"]){
        Vallage *val =[cityArr objectAtIndex:indexPath.row];
        NSDictionary *dictionary = [NSDictionary dictionaryWithObject:val forKey:@"Vallage"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateVallege" object:dictionary];
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }
}

#pragma mark- 设置setTable的索引 -
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView;{
    
    NSMutableArray *toBeReturned = [[NSMutableArray alloc]init];
    for(char c = 'A'; c<='Z' ;c++)
        
        [toBeReturned addObject:[NSString stringWithFormat:@"%c",c]];
    
    return toBeReturned;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    // 获取所点目录对应的indexPath值
    //   NSIndexPath *selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:index];
    NSLog(@"%@->%ld",title,(long)index);
    // 让table滚动到对应的indexPath位置
    //   [tableView scrollToRowAtIndexPath:selectIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    self.value = title;
    self.type1 = @"0";
    [self setJsonView];
    NSLog(@"value->%@",self.value);
    return index;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

