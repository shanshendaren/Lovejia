//
//  ConvenientServiceViewController.m
//  PropertyManagement
//
//  Created by 杨 帅 on 15/5/8.
//  Copyright (c) 2015年 杨 帅. All rights reserved.
//

#import "ConvenientServiceViewController.h"
#import "NewsMainViewController.h"
#import "BZAppDelegate.h"

#import "WebsViewController.h"


@interface ConvenientServiceViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic ,strong)UICollectionViewFlowLayout *flowLayout;
@property (nonatomic ,strong) NSArray * imageAry;
@property (nonatomic ,strong) NSArray * labelAry;


@end

@implementation ConvenientServiceViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    BZAppDelegate* app = (BZAppDelegate *)[UIApplication sharedApplication].delegate;
    [app.tabBar customTabBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.imageAry = @[@"zixun",@"sffw",@"zh_shang",@"sh_wei",@"ji_fen",@"ping_an",@"zheng_neng",@"wei_yuan",@"shang_quan"];
    self.labelAry = @[@"生活资讯",@"缴费服务",@"中商爱家",@"生活微超",@"积分商城",@"平安社区",@"社区正能量",@"业主委员会",@"社区商圈"];
    self.view.backgroundColor = [UIColor clearColor];
    [self initUI];

}

-(void)initUI{
    
    self.title = @"便民服务";
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    self.flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [self.flowLayout setItemSize:CGSizeMake((self.view.frame.size.width-3)/4.0, 75)];
    [self.flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.flowLayout.minimumInteritemSpacing = 1.0;
    self.flowLayout.minimumLineSpacing = 1.0;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-64-49) collectionViewLayout:self.flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.contentInset = UIEdgeInsetsZero;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"BMCollectionCell"];
    [self.view addSubview:self.collectionView];
    
    //    [self.view addSubview:setTable];
}


#pragma mark- collection

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 9;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BMCollectionCell"forIndexPath:indexPath];
    
#pragma mark - lable和image的坐标，大小位置设置 -
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(7, 55, 60, 20)];
    label.textAlignment = 1;
    label.text = [self.labelAry objectAtIndex:indexPath.row];
    [label setFont:[UIFont fontWithName:nil size:11]];
    [cell.contentView addSubview:label];
    UIImageView *iv =[[UIImageView alloc]initWithFrame:CGRectMake(12, 5, 50, 50)];
    NSString * imageStr = [self.imageAry objectAtIndex:indexPath.row];
    iv.image = [UIImage imageNamed:imageStr];
    [cell.contentView addSubview:iv];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row ==0) {
        NewsMainViewController * cv = [[NewsMainViewController alloc]init];
    
        [self.navigationController pushViewController:cv animated:NO];
    }
    else if(indexPath.row ==8){
        WebsViewController *cv1 = [[WebsViewController alloc] init];
        
        [self.navigationController pushViewController:cv1 animated:NO];
    }
    else{
        
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
