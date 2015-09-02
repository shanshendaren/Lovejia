//
//  SecondHouseListViewController.m
//  PropertyManagement
//
//  Created by admin on 15/2/11.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "SecondHouseListViewController.h"
#import "SaleListViewController.h"
#import "BuyListViewController.h"
#import "VersionAdapter.h"
#import "SetNewBuyHouseViewController.h"
#import "SetNewSecondHouseViewController.h"
#import "BZAppDelegate.h"



@interface SecondHouseListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    int currentType;
}

@property (nonatomic,strong) UITableView * table ;

@end

@implementation SecondHouseListViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    BZAppDelegate* app = (BZAppDelegate *)[UIApplication sharedApplication].delegate;
    [app.tabBar customTabBarHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title =@"二手房";
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    [self createBack];
    [VersionAdapter setViewLayout:self];
    [self createUI];
//    [self initUI ];
}

-(void)initUI{
    self.table = [[UITableView alloc]initWithFrame:self.view.bounds
        style:UITableViewStylePlain];
    self.table.delegate = self;
    self.table.dataSource = self;
    
    [self.view addSubview:self.table];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"scCell";
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UILabel * lable = [[UILabel alloc]initWithFrame:CGRectMake(10, 7,100, 30)];
       lable .text = @"二手房名";
        [cell addSubview:lable];
        
        UILabel * lable1 = [[UILabel alloc]initWithFrame:CGRectMake(210, 7,100, 30)];
       lable1.text = @"价格";
        
         [cell addSubview:lable1];

    }

    return cell;
}


-(void)createUI{
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"买房信息",@"卖房信息",nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    currentType = 1;
    segmentedControl.tintColor = [UIColor colorWithRed:61/255.0 green:160/255.0 blue:40/255.0 alpha:1.0];
//    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentedControl.frame = CGRectMake(0, 0, self.view.frame.size.width, 40);
    segmentedControl.selectedSegmentIndex = 0;//设置默认选择项索引
    [ segmentedControl addTarget: self action: @selector(segmentChanged:)forControlEvents: UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];
    
    SaleListViewController * nlc = [[SaleListViewController alloc]init];
    [self addChildViewController:nlc];
    BuyListViewController * ntc = [[BuyListViewController alloc]init];
    [self addChildViewController:ntc];
    
    nlc.view.frame = CGRectMake(0,40, self.view.frame.size.width, self.view.frame.size.height-44-[VersionAdapter getMoreVarHead]);
    [self.view addSubview:nlc.view];
    
    UIViewController *stationVC = [self.childViewControllers objectAtIndex:0];
    self.currentViewController = stationVC;
    
}

-(void)segmentChanged:(UISegmentedControl *)paramSender{
    UIViewController *stationVC = [self.childViewControllers objectAtIndex:0];
    UIViewController *classifyVC = [self.childViewControllers objectAtIndex:1];
    switch (paramSender.selectedSegmentIndex) {
        case 0:
            if (self.currentViewController == stationVC)
            {
                
            }
            else
            {
                self.currentViewController = stationVC;
                stationVC.view.frame = CGRectMake(0,40, self.view.frame.size.width, self.view.frame.size.height-44-[VersionAdapter getMoreVarHead]);
                [classifyVC.view removeFromSuperview];
                [self.view addSubview:stationVC.view];
            }
            currentType = 1;
            break;
        case 1:
            if (self.currentViewController == stationVC)
            {
                self.currentViewController = classifyVC;
                classifyVC.view.frame =CGRectMake(0,40, self.view.frame.size.width, self.view.frame.size.height-44-[VersionAdapter getMoreVarHead]);
                [stationVC.view removeFromSuperview];
                [self.view addSubview:classifyVC.view];
            }
            else
            {
                
            }
            currentType = 2;
            break;
            
        default:
            break;
    }
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
    [newBtn setTitle:@"新建" forState:UIControlStateNormal];
    [newBtn setTitleEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 10)];
    [newBtn addTarget:self action:@selector(pushAction) forControlEvents:UIControlEventTouchUpInside];
//    [newBtn setTintColor:[UIColor lightGrayColor]];
//    [newBtn setBackgroundImage:[UIImage imageNamed:@"save.png"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:newBtn];

}

-(void)backAction{
    [self dismissViewControllerAnimated:NO completion:^{
    }];
//     [self.navigationController popViewControllerAnimated:NO];
}


-(void)pushAction{
    if (currentType == 1) {
        SetNewBuyHouseViewController *sbvc =[[SetNewBuyHouseViewController alloc]init];
        [self.navigationController pushViewController:sbvc animated:YES];
    }else if (currentType == 2){
        SetNewSecondHouseViewController *ssvc =[[SetNewSecondHouseViewController alloc]init];
        [self.navigationController pushViewController:ssvc animated:YES];}

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.s
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
