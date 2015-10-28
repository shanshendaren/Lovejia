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
#import"SFSafeCommunityViewController.h"
#import "MapViewController.h"


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
    [self.navigationController.navigationBar setHidden:YES];
    [app.tabBar customTabBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageAry = @[@"zixun",@"sffw",@"sh_wei",@"ji_fen",@"ping_an",@"zheng_neng",@"wei_yuan",@"shang_quan"];
    self.labelAry = @[@"生活资讯",@"缴费服务",@"生活微超",@"积分商城",@"平安社区",@"社区正能量",@"业主委员会",@"社区商圈"];
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.98 alpha:1]];
    [self initUI];
}

-(void)initUI{
    
    //TODO: 标题
    UILabel *biaoTiLable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    biaoTiLable1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:biaoTiLable1];
    UILabel *biaoTiLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 20)];
    biaoTiLable.backgroundColor = [UIColor whiteColor];
    biaoTiLable.font = [UIFont systemFontOfSize:12.f];
    biaoTiLable.textAlignment = NSTextAlignmentCenter;
    biaoTiLable.textColor = [UIColor grayColor];
    biaoTiLable.text = @"便民服务";
    [self.view addSubview:biaoTiLable];
    
    self.flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [self.flowLayout setItemSize:CGSizeMake((self.view.frame.size.width-3)/4.0, 75)];
    [self.flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.flowLayout.minimumInteritemSpacing = 1.0;
    self.flowLayout.minimumLineSpacing = 1.0;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 42, self.view.frame.size.width, 170) collectionViewLayout:self.flowLayout];
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
    return 8;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BMCollectionCell"forIndexPath:indexPath];
    
#pragma mark - lable和image的坐标，大小位置设置 -
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(7, 45, 60, 20)];
    label.textAlignment = 1;
    label.text = [self.labelAry objectAtIndex:indexPath.row];
    label.textColor = RGBACOLOR(147.f, 147.f, 147.f, 1.f);
    [label setFont:[UIFont fontWithName:@"Arial" size:9.f]];
    [cell.contentView addSubview:label];
    UIImageView *iv =[[UIImageView alloc]initWithFrame:CGRectMake(20, 7, 35, 34)];
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
    else if(indexPath.row ==4){
        SFSafeCommunityViewController *safeCommunityVc = [[SFSafeCommunityViewController alloc] init];
        
        [self.navigationController pushViewController:safeCommunityVc animated:NO];
    }
    else if(indexPath.row ==7){
//        WebsViewController *cv1 = [[WebsViewController alloc] init];
//        [self.navigationController pushViewController:cv1 animated:NO];
      
        MapViewController *mv =[[MapViewController alloc]init];
        [self.navigationController pushViewController:mv animated:NO];
    }else{
        
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
