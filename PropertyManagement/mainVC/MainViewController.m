//
//  MainViewController.m
//  PropertyManagement
//
//  Created by admin on 14/11/13.
//  Copyright (c) 2014年 admin. All rights reserved.
//

#import "MainViewController.h"
#import "VersionAdapter.h"
#import "ComplainViewController.h"
#import "BZAppDelegate.h"
#import "FixViewController.h"
#import "NoticeListViewController.h"
#import "CallForHelpViewController.h"
#import "VallageViewController.h"
#import "ChangeCommodityViewController.h"
#import "ASIFormDataRequest.h"
#import "NoticeAllListViewController.h"
#import "RequestUtil.h"
#import "ActivityView.h"
#import "SVProgressHUD.h"
#import "JSBadgeView.h"
#import "NewsMainViewController.h"
#import "HousekeepServiceViewController.h"
#import "TourismListViewController.h"
#import "UIImageView+WebCache.h"
#import "SIAlertView.h"
#import "SetNewSecondHouseViewController.h"
#import "SetNewBuyHouseViewController.h"
#import "SaleListViewController.h"
#import "SecondHouseListViewController.h"
#import "BuyListViewController.h"
#import "ysButton.h"
#import "PhoneNCViewController.h"
#import "BZGuangGaoUrl.h"
#import "BZSheQuListViewController.h"
#import "BZFaLvListViewController.h"


@interface MainViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    NSMutableArray  *viewsArray;    //视图数组
    NSArray         *textArray;     //文本数组
    ActivityView *activity;
    int newCount;
    UILabel *countLabel;
    NSString *countStr;
    NSTimer *timer;
    UIView *dengluV;
    
    UIImageView *imageViw;
}

@property (nonatomic,strong)NSArray *listArray;
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic ,strong)UICollectionViewFlowLayout *flowLayout;
@property (nonatomic,assign)int num;
@property (nonatomic ,strong)UIButton * but1;
@property (nonatomic,strong)UIButton *but2;
@property (nonatomic,strong)UIScrollView * ScrollV;
@property (nonatomic,strong)NSArray *advertisementAry;
@property(nonatomic,strong)UIImageView *imageV;

@end

@implementation MainViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    BZAppDelegate* app = (BZAppDelegate *)[UIApplication sharedApplication].delegate;
    [app.tabBar customTabBarHidden:NO];
    BZGuangGaoUrl *GGUrl = [BZGuangGaoUrl sharedInstance];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageViw = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [imageViw sd_setImageWithURL:GGUrl.GGurl];
        NSLog(@">>>>>%@",GGUrl.GGurl);
        [app.window addSubview:imageViw];
        timer = [NSTimer scheduledTimerWithTimeInterval:5.f target:self selector:@selector(remover) userInfo:nil repeats:NO];
    });
}

-(void)remover{
    [imageViw removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1];
    [self.navigationController setNavigationBarHidden:YES];
    [self createUI];
    newCount = 0;
    BZAppDelegate* app = (BZAppDelegate *)[UIApplication sharedApplication].delegate;
    
    RequestUtil *request2 =[[RequestUtil alloc]init];
    NSString *biz2 = [NSString  stringWithFormat:@"{\"type\":\"0\"}"];
    NSString *sid2 = @"QueryRegistorNum";
    [request2 startRequest:sid2 biz:biz2 send:self];

    RequestUtil *request =[[RequestUtil alloc]init];
    NSString *biz = [NSString  stringWithFormat:@"{\"userId\":\"%@\"}",app.userID];
    NSString *sid = @"FindMessageCount";
    [request startRequest:sid biz:biz send:self];
    
    RequestUtil *request1 =[[RequestUtil alloc]init];
    NSString *biz1 = [NSString  stringWithFormat:@"{\"type\":\"0\"}"];
    NSString *sid1 = @"QueryPic";
    [request1 startRequest:sid1 biz:biz1 send:self];

    RequestUtil *request3 =[[RequestUtil alloc]init];
    NSString *biz3 = [NSString  stringWithFormat:@"{\"type\":\"1\"}"];
    NSString *sid3 = @"QueryPic";
    [request3 startRequest:sid3 biz:biz3 send:self];
}

-(void)createUI{
     [VersionAdapter setViewLayout:self];

    //TODO: 标题栏
    UILabel *biaoTiLable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    [biaoTiLable1 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:biaoTiLable1];
    
    UILabel *biaoTiLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 20)];
    [biaoTiLable setBackgroundColor:[UIColor whiteColor]];
    biaoTiLable.textColor = [UIColor grayColor];
    biaoTiLable.text = @"武汉爱家";
    [biaoTiLable setFont:[UIFont systemFontOfSize:12]];
    biaoTiLable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:biaoTiLable];
    
    self.flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [self.flowLayout setItemSize:CGSizeMake((self.view.frame.size.width-3)/4.0, 75)];
    [self.flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.flowLayout.minimumInteritemSpacing = 0.2;
    self.flowLayout.minimumLineSpacing = 0.5;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 190, 320, self.view.frame.size.height-150) collectionViewLayout:self.flowLayout];

    UIView *vi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, self.collectionView.frame.size.height)];
    [vi setBackgroundColor:[UIColor colorWithRed:204.0f/255.f green:204.0f/255.f blue:204.0f/255.f alpha:1.0]];
    
    [self.collectionView setBackgroundView:vi];
    self.collectionView.maximumZoomScale = 1.f;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.contentInset = UIEdgeInsetsZero;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CollectionCell"];
    [self.view addSubview:self.collectionView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNewCounts) name:@"updateNewCounts" object:nil];
//    [self createBack];
}

//-(void)createBack{
//    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
//    backButton.frame = CGRectMake(0, 0, 110, 20);
//    backButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//    countLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 110, 20)];
//    countLabel.textAlignment = NSTextAlignmentRight;
//    countLabel.font =[UIFont fontWithName:nil size:13];
//    countLabel.textColor =[UIColor blackColor];
//    [backButton addSubview:countLabel];
//    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:backButton];
//}



-(void)requestStarted:(ASIHTTPRequest *)request{
    if ([activity isVisible] == NO) {
        [activity startAnimate:self];
    }
}

-(void)requestCompleted:(ASIHTTPRequest *)request{
    NSError *error;
    //获取接口总线返回的结果,
    NSString *returnData = [request responseString];
    NSData *jsonData = [returnData dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
//    NSLog(@"json>>%@",json);
    if ([activity isVisible]) {
        [activity stopAcimate];
    }
    if ([json[@"status"]isEqualToString:@"success"]) {
        if([json objectForKey:@"unreadCount"]){
            newCount =[json[@"unreadCount"]intValue];
            [self.collectionView reloadData];
        }
        if (((NSArray *)[json objectForKey:@"picInfo"]).count >0){
            
            if([[json objectForKey:@"type"]  isEqual: @1])
            {
                self.advertisementAry = [json objectForKey:@"picInfo"];
            }
            else if([[json objectForKey:@"type"]  isEqual: @0])
            {
            //视图数组
            NSArray * arr =[json objectForKey:@"picInfo"];
            viewsArray = [@[] mutableCopy];
            //遍历视图
            for (int i = 0; i < arr.count; ++i) {
                NSDictionary *dic =[arr objectAtIndex:i];
                NSURL *url =[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"picPath"]]];
                UIImageView *bgIV= [[UIImageView alloc]initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, 125)];
                [bgIV sd_setImageWithURL:url placeholderImage:nil];
                [viewsArray addObject:bgIV];
            }
            //创建一个自动滚动的ScrollView
            PFAutomaticScrollView *scrollView = [[PFAutomaticScrollView alloc] initWithFrame:CGRectMake(0, 41, 320, 150) animationDuration:5.5 delegate:self];
            //ScrollView的背景
            scrollView.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1];
            [self.view addSubview:scrollView];
            }
        }}
    if([json objectForKey:@"registorNum"]){
            countStr =[NSString stringWithFormat:@"  在线人数:%@",[json objectForKey:@"registorNum"]];
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

#pragma mark - PFAutomaticScrollViewDelegate
//设置页数
- (NSInteger)numberOfPagesInAutomaticScrollView:(PFAutomaticScrollView *)automaticScrollView
{
    return viewsArray.count;
}

//设置视图
- (UIView *)automaticScrollView:(PFAutomaticScrollView *)automaticScrollView contentViewAtIndex:(NSInteger)index
{
    return [viewsArray objectAtIndex:index];
}

//设置文本
- (void)automaticScrollView:(PFAutomaticScrollView *)automaticScrollView textLabel:(UILabel *)textLabel atIndex:(NSInteger)index
{
    if (countStr) {
        textLabel.text =[NSString stringWithFormat:@"%@",countStr];
    }
}

//设置点击事件
- (void)automaticScrollView:(PFAutomaticScrollView *)automaticScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"点击了第%ld个", (long)index);
}

#pragma mark - CollectionViewDelegate

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (section ==0 ||section ==1) {
        return CGSizeMake(self.view.frame.size.width, 1);
    }
    else if (section ==2){
   return CGSizeMake(self.view.frame.size.width, 1);
    }
    return CGSizeZero;
}

//设置头尾部
//-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//    UICollectionReusableView  * headView;
//    if ([kind isEqual:UICollectionElementKindSectionHeader]||indexPath.section ==2) {
//        UICollectionReusableView  * headView =[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"hxwHeader" forIndexPath:indexPath];
//        UILabel * lable = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, 59, 20)];
//        lable.text = @"缴费服务";
//        [headView addSubview:lable];
//
//    }
//    return headView;
//}

//每组的cell的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 || indexPath.section == 3) {
        return CGSizeMake((self.view.frame.size.width-2.0)/4.0, 80);
    }
    else{
        return CGSizeMake(self.view.frame.size.width, 100) ;
    }
}

//返回多少组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

//每组多少个
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 12;
    }
    else if (section ==1 || section ==2)
    {
         return 1;
    }
    else {
        return 8;
    }
   
}

//cell
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(7, 45, 60, 20)];
    label.textAlignment = 1;
    [label setFont:[UIFont fontWithName:@"Arial" size:9]];
    label.textColor = RGBACOLOR(102.f, 102.f, 102.f, 1);
 //   label.textColor = [UIColor colorWithRed:102.0f/255.f green:102.0f/255.f blue:102.0f/255.f alpha:1.0];
    [cell.contentView addSubview:label];
    
    UIImageView *iv =[[UIImageView alloc]initWithFrame:CGRectMake(25, 18, 25, 25)];
    [cell.contentView addSubview:iv];

    
  if (indexPath.section ==0) {
    
    if (indexPath.row == 0) {
        label.text = [NSString stringWithFormat:@"小区详情"];
        [iv setImage:[UIImage imageNamed:@"1"]];
    }
    else if (indexPath.row == 1) {
        if (newCount > 0) {
            UIView *recView = [[UIView alloc]initWithFrame:CGRectMake(0, 13, 50, 30)];
            JSBadgeView *badgeView = [[JSBadgeView alloc] initWithParentView:recView alignment:JSBadgeViewAlignmentTopRight];
            badgeView.badgeText = [NSString stringWithFormat:@"%d",newCount];
            [cell.contentView addSubview:recView];
        }
        label.text = [NSString stringWithFormat:@"小区通知"];
        [iv setImage:[UIImage imageNamed:@"2"]];
    }
    else if (indexPath.row == 2) {
        label.text = [NSString stringWithFormat:@"网上投诉"];
        [iv setImage:[UIImage imageNamed:@"3"]];
    }
    else if (indexPath.row == 3) {
        label.text = [NSString stringWithFormat:@"家政服务"];
        [iv setImage:[UIImage imageNamed:@"4"]];
    }
    else if (indexPath.row == 4) {
        label.text = [NSString stringWithFormat:@"社区拼车"];
        [iv setImage:[UIImage imageNamed:@"5"]];
    }
    else if (indexPath.row == 5) {
        label.text = [NSString stringWithFormat:@"以物换物"];
        [iv setImage:[UIImage imageNamed:@"6"]];
    }
    else if (indexPath.row == 6) {
        label.text = [NSString stringWithFormat:@"在线维护"];
        [iv setImage:[UIImage imageNamed:@"7"]];
    }
    else if (indexPath.row == 7) {
        label.text = [NSString stringWithFormat:@"二手房"];
        [iv setImage:[UIImage imageNamed:@"8"]];
    }
    else if (indexPath.row == 8) {
        label.text = [NSString stringWithFormat:@"紧急呼救"];
        [iv setImage:[UIImage imageNamed:@"9"]];
    }
    else if (indexPath.row == 9) {
                label.text = [NSString stringWithFormat:@"社区资源"];
                [iv setImage:[UIImage imageNamed:@"shequziyuan"]];
    }else if(indexPath.row ==10){
        label.text = [NSString stringWithFormat:@"法律援助"];
        [iv setImage:[UIImage imageNamed:@"jiufentiaojie"]];
    }

    else{
        
    }
}
#pragma mark- 首页下边广告展示 -
  else if (indexPath.section ==1){
      UIScrollView * scrollview = [[UIScrollView alloc]init];
      scrollview.frame = cell.bounds;
      scrollview.delegate = self;
      [cell.contentView addSubview:scrollview];
      
      CGFloat imageW = scrollview.frame.size.width;
      CGFloat imageH = scrollview.frame.size.height;

      for (int index = 0; index < self.advertisementAry.count; index++) {
          UIImageView * imageView = [[UIImageView alloc]init];
          //设置图片
          NSURL *url =[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[self.advertisementAry objectAtIndex:index]objectForKey:@"picPath"]]];
          [imageView sd_setImageWithURL:url placeholderImage:nil];

          //设置frame
          CGFloat imageX = index * imageW;
          imageView.frame = CGRectMake(imageX, 0, imageW, imageH);
          
          [scrollview addSubview:imageView];
          
     }
         scrollview.contentSize = CGSizeMake(imageW * 2, 0);
         scrollview.bounces = NO;
         scrollview.showsHorizontalScrollIndicator = NO;
//      scrollview.userInteractionEnabled = NO;
      scrollview.scrollEnabled = NO;
      self.ScrollV = scrollview;
      
      UIButton * button1 =[[UIButton alloc]initWithFrame:CGRectMake(5, 38, 15, 30)];
      [button1 setImage:[UIImage imageNamed:@"14"] forState:UIControlStateNormal];
      [button1 addTarget:self action:@selector(onScrollview) forControlEvents:UIControlEventTouchUpInside];
      button1.enabled = NO;
      self.num = 1;
      [cell.contentView addSubview:button1];
      self.but1 = button1;
      
      UIButton * button2 =[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 25, 38, 15, 30)];
      [button2 setImage:[UIImage imageNamed:@"14a"] forState:UIControlStateNormal];
      [button2 addTarget:self action:@selector(nextScrollview) forControlEvents:UIControlEventTouchUpInside];

      [cell.contentView addSubview:button2];
      self.but2 = button2;
      
//      UIImageView * imageV= [[UIImageView alloc]initWithFrame:CGRectMake(25, 10, 100, 80)];
//      imageV.image = [UIImage imageNamed:@"13"];
//      [cell.contentView addSubview:imageV];
//      
//      UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(140, 20, 150, 30)];
//      label1.text = @"海农便利店";
//      label1.textColor = [UIColor redColor];
//      [cell.contentView addSubview:label1];
//      
//      UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(140, 50, 150, 20)];
//      label2.text = @"地址：武昌和平大道";
//      label2.font = [UIFont systemFontOfSize:10];
//      [cell.contentView addSubview:label2];
//      
//      UILabel * label3 = [[UILabel alloc]initWithFrame:CGRectMake(140, 70, 150, 20)];
//      label3.text = @"电话：027-888888";
//      label3.font = [UIFont systemFontOfSize:10];
//      [cell.contentView addSubview:label3];
//      
//      UIButton * button3 = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/4*3+10, -3, 20, 30)];
//      [button3 setBackgroundImage:[UIImage imageNamed:@"11"]  forState:UIControlStateNormal];

//       [cell.contentView addSubview:button3];

      
//      UIButton * button4 = [[UIButton alloc]initWithFrame:CGRectMake(button3.frame.size.width+button3.frame.origin.x+10, button3.frame.origin.y, button3.frame.size.width, button3.frame.size.height)];
//      [button4 setBackgroundImage:[UIImage imageNamed:@"12"]  forState:UIControlStateNormal];
//      [cell.contentView addSubview:button4];
//  

  }
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

-(void)onScrollview{
    self.num -= 1;
    if (self.num == 1) {
        self.but1.enabled = NO;
        self.but2.enabled = YES;

    }
    if (self.num ==2) {
        self.but1.enabled = YES;
        self.but2.enabled = NO;
    }
    [self.ScrollV setContentOffset:CGPointMake(self.ScrollV.bounds.size.width*(self.num-1),0) animated:YES];
    
}

-(void)nextScrollview{
    self.num += 1;
    if (self.num == 1) {
        self.but1.enabled = NO;
        self.but2.enabled = YES;
        
    }
    if (self.num ==2) {
        self.but1.enabled = YES;
        self.but2.enabled = NO;
        
    }
  [self.ScrollV setContentOffset:CGPointMake(self.ScrollV.bounds.size.width*(self.num-1),0) animated:YES];
}



- (void) updateNewCounts{
    newCount = 0;
    [self.collectionView reloadData];
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
 if(indexPath.section ==0){
    if (indexPath.row == 0)//小区详情
    {
        VallageViewController *cv = [[VallageViewController alloc]init];
        PhoneNCViewController *navigationController = [[PhoneNCViewController alloc] initWithRootViewController:cv];
        [self presentViewController:navigationController animated:NO completion:^{
        }];
//       [self.navigationController pushViewController:cv animated:NO];
    }
    else if (indexPath.row == 1) {//小区通知
        NoticeAllListViewController *ncv = [[NoticeAllListViewController alloc]init];
        ncv.newCount = newCount;
        PhoneNCViewController *navigationController = [[PhoneNCViewController alloc] initWithRootViewController:ncv];
        [self presentViewController:navigationController animated:NO completion:^{
        }];
       
//       [self.navigationController pushViewController:ncv animated:NO];
    }
    else if (indexPath.row == 6)//报修
    {
        FixViewController *fc = [[FixViewController alloc]init];
        PhoneNCViewController *navigationController = [[PhoneNCViewController alloc] initWithRootViewController:fc];
        [self presentViewController:navigationController animated:NO completion:^{
        }];
//        [self.navigationController pushViewController:fc animated:NO];
    }
    else if (indexPath.row == 2)//投诉
    {
        
        
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"提示" andMessage:@"请选择投诉类型"];
        
        [alertView addButtonWithTitle:@"物业类"
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alertView) {
                                  ComplainViewController *cv = [[ComplainViewController alloc]init];
                                  cv.selfType = 1;
                                  PhoneNCViewController *navigationController = [[PhoneNCViewController alloc] initWithRootViewController:cv];
                                  [self presentViewController:navigationController animated:NO completion:^{
                                  }];
//                                   [self.navigationController pushViewController:cv animated:NO];
  
                              }];
        [alertView addButtonWithTitle:@"非物业类"
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alertView) {
                                  ComplainViewController *cv = [[ComplainViewController alloc]init];
                                  cv.selfType = 2;
                                  PhoneNCViewController *navigationController = [[PhoneNCViewController alloc] initWithRootViewController:cv];
                                  [self presentViewController:navigationController animated:NO completion:^{
                                  }];
//                                   [self.navigationController pushViewController:cv animated:NO];
                                  
                              }];
        [alertView addButtonWithTitle:@"取消"
                                 type:SIAlertViewButtonTypeDestructive
                              handler:^(SIAlertView *alertView) {
                              }];
        
        [alertView show];



    }
    else if (indexPath.row == 3)//家政服务
    {
        HousekeepServiceViewController *cv = [[HousekeepServiceViewController alloc]init];
        PhoneNCViewController *navigationController = [[PhoneNCViewController alloc] initWithRootViewController:cv];
        [self presentViewController:navigationController animated:NO completion:^{
        }];
//        [self.navigationController pushViewController:cv animated:NO];
    }

    else if (indexPath.row == 4)//拼车
    {
        TourismListViewController *cv = [[TourismListViewController alloc]init];
        PhoneNCViewController *navigationController = [[PhoneNCViewController alloc] initWithRootViewController:cv];
        [self presentViewController:navigationController animated:NO completion:^{
        }];
//         [self.navigationController pushViewController:cv animated:NO];
    }
    else if (indexPath.row == 5)//物品交换
    {
        ChangeCommodityViewController *cv = [[ChangeCommodityViewController alloc]init];
        PhoneNCViewController *navigationController = [[PhoneNCViewController alloc] initWithRootViewController:cv];
        [self presentViewController:navigationController animated:NO completion:^{
        }];
//         [self.navigationController pushViewController:cv animated:NO];
    }
     else if (indexPath.row == 8)//一键呼救
    {
        CallForHelpViewController *cv = [[CallForHelpViewController alloc]init];
        [cv clickAction];
//        PhoneNCViewController *navigationController = [[PhoneNCViewController alloc] initWithRootViewController:cv];
//        [self presentViewController:navigationController animated:NO completion:^{
//        }];
//         [self.navigationController pushViewController:cv animated:NO];
    }
    else if (indexPath.row == 7)//二手房
    {
        SecondHouseListViewController *cv = [[SecondHouseListViewController alloc]init];
        PhoneNCViewController *navigationController = [[PhoneNCViewController alloc] initWithRootViewController:cv];
        [self presentViewController:navigationController animated:NO completion:^{
        }];
//        [self.navigationController pushViewController:cv animated:NO];
    }
    else if (indexPath.row == 9)//社区资源
    {
        BZSheQuListViewController *cv = [[BZSheQuListViewController alloc]init];
        PhoneNCViewController *navigationController = [[PhoneNCViewController alloc] initWithRootViewController:cv];
        [self presentViewController:navigationController animated:NO completion:^{
        }];
    }
     else if(indexPath.row == 10)//法律援助
     {
         BZFaLvListViewController *fv = [[BZFaLvListViewController alloc] init];
         PhoneNCViewController *navigationController = [[PhoneNCViewController alloc] initWithRootViewController:fv];
         [self presentViewController:navigationController animated:NO completion:^{
         }];
     }
 }
    //更多服务
    else if(indexPath.section == 1)
    {
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
