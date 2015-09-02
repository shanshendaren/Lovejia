//
//  ValuablesDetailViewController.m
//  PropertyManagement
//
//  Created by iosMac on 15-1-12.
//  Copyright (c) 2015年 iosMac. All rights reserved.
//

#import "ValuablesDetailViewController.h"
#import "BrowseViewController.h"
#import "VersionAdapter.h"
#import "UIImageView+WebCache.h"
#import "RequestUtil.h"
#import "KxMenu.h"
#import "BZAppDelegate.h"
#import "ActivityView.h"
#import "SVProgressHUD.h"
#import "SIAlertView.h"
#import "SendMessageViewController.h"
#import "DiscussViewController.h"


@interface ValuablesDetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    CGFloat Y;
    ActivityView *activity;

   
}
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)UIScrollView *scrollView;

@end

@implementation ValuablesDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [VersionAdapter setViewLayout:self];
    self.navigationItem.title = @"交换详情";
    //[self.view setBackgroundColor:[UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.0]];
    UIScrollView *sv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height-44-[VersionAdapter getMoreVarHead] - 50)];
    [sv setUserInteractionEnabled:YES];
    [self.view addSubview:sv];

    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 15, 15);
    backButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    activity = [[ActivityView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44 - [VersionAdapter getMoreVarHead]) loadStr:NSLocalizedString(@"正在加载...", nil)];
    
    UIButton *newBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [newBtn setFrame:CGRectMake(self.view.frame.size.width-50, 0, 30, 30)];
    [newBtn addTarget:self action:@selector(pushAction:) forControlEvents:UIControlEventTouchUpInside];
    [newBtn setTintColor:[UIColor lightGrayColor]];
    [newBtn setBackgroundImage:[UIImage imageNamed:@"top_more_.png"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:newBtn];
    
    if ([self.selfType isEqualToString:@"22"]) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    if (self.valuablesInfo.photos.count == 0) {
        Y = 5;
    }else{
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        self.collectionView.backgroundColor = [UIColor clearColor];
        [flowLayout setItemSize:CGSizeMake(90, 90)];
        flowLayout.minimumLineSpacing = 2.0;
        [flowLayout setSectionInset:UIEdgeInsetsMake(5, 5, 5, 5)];
        if (self.valuablesInfo.photos.count>3) {
            self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 180) collectionViewLayout:flowLayout];
        }
        else
        {
            self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 90) collectionViewLayout:flowLayout];
        }
        UIView *vi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, self.collectionView.frame.size.height)];
        [vi setBackgroundColor:[UIColor whiteColor]];
        [self.collectionView setBackgroundView:vi];
        self.collectionView.scrollEnabled = NO;
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CollectionCell"];
        [sv addSubview:self.collectionView];
        
        Y = self.collectionView.frame.size.height + self.collectionView.frame.origin.y+ 5;
    }
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, Y, self.view.frame.size.width, 40)];
    [titleLabel setBackgroundColor:[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0]];
    titleLabel.numberOfLines = 0;
    titleLabel.text = self.valuablesInfo.barterInfoTitle;
    titleLabel.font = [UIFont systemFontOfSize:20.f];
    titleLabel.textColor = [UIColor blackColor];
    [sv addSubview:titleLabel];
    Y = titleLabel.frame.size.height + titleLabel.frame.origin.y;
    
    UILabel *jianjieLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, Y, self.view.frame.size.width, 20)];
    jianjieLabel.text = [NSString stringWithFormat:@"发布时间 %@",self.valuablesInfo.repaeaseDate];
    [jianjieLabel setBackgroundColor:[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0]];
    jianjieLabel.textColor = [UIColor grayColor];
    jianjieLabel.font = [UIFont systemFontOfSize:12.f];
    [sv addSubview:jianjieLabel];
    Y = jianjieLabel.frame.size.height + jianjieLabel.frame.origin.y + 5;
    
    
    if([self.selfType isEqualToString:@"22"]){
        UITextView *contentLabel = [[UITextView alloc]initWithFrame:CGRectMake(0, Y, self.view.frame.size.width, 150)];
        contentLabel.editable = NO;
        contentLabel.text = [NSString stringWithFormat:@"%@",self.valuablesInfo.barterInfoContent];
        contentLabel.textColor = [UIColor grayColor];
        contentLabel.font = [UIFont systemFontOfSize:14.f];
        [sv addSubview:contentLabel];
        
        Y = contentLabel.frame.size.height + contentLabel.frame.origin.y;
        
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, Y, self.view.frame.size.width, 20)];
        label1.text = [NSString stringWithFormat:@"评论"];
        [label1 setBackgroundColor:[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0]];
        label1.textColor = [UIColor grayColor];
        label1.font = [UIFont systemFontOfSize:12.f];
        [sv addSubview:label1];
        Y = label1.frame.size.height + label1.frame.origin.y;
        
        UITextView *contentLabel1 = [[UITextView alloc]initWithFrame:CGRectMake(0, Y, self.view.frame.size.width, 60)];
        contentLabel1.editable = NO;
        contentLabel1.text = [NSString stringWithFormat:@"%@",self.valuablesInfo.barterCommentContent];
        contentLabel1.textColor = [UIColor grayColor];
        contentLabel1.font = [UIFont systemFontOfSize:14.f];
        [sv addSubview:contentLabel1];
        Y =contentLabel1.frame.size.height + contentLabel1.frame.origin.y;
        [sv setContentSize:CGSizeMake(self.view.frame.size.width, Y)];

    }else{
        UITextView *contentLabel = [[UITextView alloc]initWithFrame:CGRectMake(0, Y, self.view.frame.size.width, self.view.frame.size.height-44-[VersionAdapter getMoreVarHead] - 50 - Y)];
        contentLabel.editable = NO;
        contentLabel.text = [NSString stringWithFormat:@"%@",self.valuablesInfo.barterInfoContent];
        contentLabel.textColor = [UIColor grayColor];
        contentLabel.font = [UIFont systemFontOfSize:14.f];
        [sv addSubview:contentLabel];
        Y = contentLabel.frame.size.height + contentLabel.frame.origin.y;
        [sv setContentSize:CGSizeMake(self.view.frame.size.width, Y)];
    }
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-44-[VersionAdapter getMoreVarHead] - 50, self.view.frame.size.width, 50)];
    [backView setBackgroundColor:[UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.0]];
    [self.view addSubview:backView];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 120, 15)];
    nameLabel.text = self.valuablesInfo.repaeaseName;
    nameLabel.textColor = [UIColor blackColor];
    [backView addSubview:nameLabel];
    
    UILabel *telLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 25, 120, 15)];
    telLabel.text = self.valuablesInfo.repaeaseTel;
    telLabel.font = [UIFont systemFontOfSize:12.f];
    telLabel.textColor = [UIColor grayColor];
    [backView addSubview:telLabel];
    
    UIButton *callBtn = [[UIButton alloc]initWithFrame:CGRectMake(124, 5, 180, 40)];
    [callBtn setBackgroundImage:[UIImage imageNamed:@"17"] forState:UIControlStateNormal];
    [callBtn setTitle:@"联系发布人" forState:UIControlStateNormal];
    [callBtn addTarget:self action:@selector(callTo:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:callBtn];
    
    if (![self.valuablesInfo.isOpen isEqualToString:@"1"] && ![self.valuablesInfo.isAgree isEqualToString:@"1"]) {
        telLabel.text =@"该用户隐藏了号码";
    }
    if ([self.selfType isEqualToString:@"12"]) {
        [backView setHidden:YES];
    }
}

-(void)pushAction:(UIButton *)sender{
    
    if ([self.selfType isEqualToString:@"12"]) {
        
        if([KxMenu isMenuShow])
        {
            [KxMenu dismissMenu];
            [KxMenu setMenuShow:NO];
        }
        else{
            NSMutableArray *menuItems =[[NSMutableArray alloc] initWithArray:
                                        @[[KxMenuItem menuItem:@"跟帖" image:[UIImage imageNamed:nil] target:self action:@selector(pushDisAction)],[KxMenuItem menuItem:@"封帖" image:[UIImage imageNamed:nil] target:self action:@selector(turnOffDis)]
                                          ]];
            CGRect rect = CGRectMake(sender.frame.origin.x, sender.frame.origin.y/2+sender.frame.origin.y-55, sender.frame.size.width, sender.frame.size.height/2+sender.frame.size.height);
            [KxMenu showMenuInView:self.view fromRect:rect menuItems:menuItems];
        }
    }else{
        if([KxMenu isMenuShow])
        {
            [KxMenu dismissMenu];
            [KxMenu setMenuShow:NO];
        }
        else{
            NSMutableArray *menuItems =[[NSMutableArray alloc] initWithArray:
                                        @[[KxMenuItem menuItem:@"回复消息" image:[UIImage imageNamed:nil] target:self action:@selector(sendMessage)],[KxMenuItem menuItem:@"在线举报" image:[UIImage imageNamed:nil] target:self action:@selector(addPolice)]
                                          ]];
            CGRect rect = CGRectMake(sender.frame.origin.x, sender.frame.origin.y/2+sender.frame.origin.y-55, sender.frame.size.width, sender.frame.size.height/2+sender.frame.size.height);
            [KxMenu showMenuInView:self.view fromRect:rect menuItems:menuItems];
        }
 
    }
}
-(void)pushDisAction{
    DiscussViewController *dvc =[[DiscussViewController alloc]init];
    dvc.valuablesInfo = self.valuablesInfo;
    [self.navigationController pushViewController:dvc animated:YES];
    
}-(void)turnOffDis{
    RequestUtil *requestUtil = [[RequestUtil alloc]init];
    //业务数据参数组织成JSON字符串
    NSString *biz = [NSString  stringWithFormat:@"{\"status\":\"2\",\"barterInfoId\":\"%@\"}",self.valuablesInfo.barterInfoId];
    NSString *sid = @"ManagementBarterInfo";
    [requestUtil startRequest:sid biz:biz send:self requestTag:100];
}

-(void)sendMessage{
    if([self.valuablesInfo.status isEqualToString:@"2"]){
        UIAlertView *aler =[[UIAlertView alloc]initWithTitle:@"提示" message:@"该帖子已被封帖无法回复" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [aler show];
        return;
    }
    SendMessageViewController *svc =[[SendMessageViewController alloc]init];
    svc.valuablesInfo = self.valuablesInfo;
    [self.navigationController pushViewController:svc animated:YES]
    ;
}

-(void)addPolice{
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"举报" andMessage:nil];
    [alertView addButtonWithTitle:@"虚假信息"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alertView) {
                              BZAppDelegate *app =[UIApplication sharedApplication].delegate;
                              RequestUtil *requestUtil = [[RequestUtil alloc]init];
                              //业务数据参数组织成JSON字符串
                              NSString *biz = [NSString  stringWithFormat:@"{\"userId\":\"%@\",\"barterInfoId\":\"%@\",\"content\":\"\",\"tipType\":\"1\"}",app.userID,self.valuablesInfo.barterInfoId];
                              NSString *sid = @"TipBarterInfo";
                              [requestUtil startRequest:sid biz:biz send:self];
                          }];
    [alertView addButtonWithTitle:@"广告信息"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alertView) {
                              BZAppDelegate *app =[UIApplication sharedApplication].delegate;
                              RequestUtil *requestUtil = [[RequestUtil alloc]init];
                              //业务数据参数组织成JSON字符串
                              NSString *biz = [NSString  stringWithFormat:@"{\"userId\":\"%@\",\"barterInfoId\":\"%@\",\"content\":\"\",\"tipType\":\"2\"}",app.userID,self.valuablesInfo.barterInfoId];
                              NSString *sid = @"TipBarterInfo";
                              [requestUtil startRequest:sid biz:biz send:self];                          }];
    [alertView addButtonWithTitle:@"淫秽色情"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alertView) {
                              BZAppDelegate *app =[UIApplication sharedApplication].delegate;
                              RequestUtil *requestUtil = [[RequestUtil alloc]init];
                              //业务数据参数组织成JSON字符串
                              NSString *biz = [NSString  stringWithFormat:@"{\"userId\":\"%@\",\"barterInfoId\":\"%@\",\"content\":\"\",\"tipType\":\"3\"}",app.userID,self.valuablesInfo.barterInfoId];
                              NSString *sid = @"TipBarterInfo";
                              [requestUtil startRequest:sid biz:biz send:self];                          }];
    [alertView addButtonWithTitle:@"敏感信息"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alertView) {
                              BZAppDelegate *app =[UIApplication sharedApplication].delegate;
                              RequestUtil *requestUtil = [[RequestUtil alloc]init];
                              //业务数据参数组织成JSON字符串
                              NSString *biz = [NSString  stringWithFormat:@"{\"userId\":\"%@\",\"barterInfoId\":\"%@\",\"content\":\"\",\"tipType\":\"4\"}",app.userID,self.valuablesInfo.barterInfoId];
                              NSString *sid = @"TipBarterInfo";
                              [requestUtil startRequest:sid biz:biz send:self];                          }];
    [alertView addButtonWithTitle:@"其他"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alertView) {
                              BZAppDelegate *app =[UIApplication sharedApplication].delegate;
                              RequestUtil *requestUtil = [[RequestUtil alloc]init];
                              //业务数据参数组织成JSON字符串
                              NSString *biz = [NSString  stringWithFormat:@"{\"userId\":\"%@\",\"barterInfoId\":\"%@\",\"content\":\"\",\"tipType\":\"5\"}",app.userID,self.valuablesInfo.barterInfoId];
                              NSString *sid = @"TipBarterInfo";
                              [requestUtil startRequest:sid biz:biz send:self];                          }];
    [alertView addButtonWithTitle:@"取消"
                             type:SIAlertViewButtonTypeDestructive
                          handler:^(SIAlertView *alertView) {
                          }];
    
    [alertView show];
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
    if ([activity isVisible]) {
        [activity stopAcimate];
    }
    if ([json[@"status"]isEqualToString:@"success"]) {
        if (request.tag ==100) {
            [SVProgressHUD showSuccessWithStatus:@"封帖成功"];

        }else{
            [SVProgressHUD showSuccessWithStatus:@"举报成功"];
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

-(void)callTo:(UIButton *)sender
{
    if ([self.selfType isEqualToString:@"1001"]) {
        if ([self.valuablesInfo.isOpen isEqualToString:@"1"]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.valuablesInfo.repaeaseTel]]];
        }else{
            UIAlertView *aler =[[UIAlertView alloc]initWithTitle:@"提示" message:@"该用户没有公开个人信息,请去回帖" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [aler show];
        }
    }
    else if ([self.selfType isEqualToString:@"22"]) {
        if([self.valuablesInfo.isOpen isEqualToString:@"1"]||[self.valuablesInfo.isAgree isEqualToString:@"1"]){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.valuablesInfo.repaeaseTel]]];
        }
        else if([self.valuablesInfo.isOpen isEqualToString:@"0"]&&[self.valuablesInfo.isAgree isEqualToString:@""]){
            UIAlertView *aler =[[UIAlertView alloc]initWithTitle:@"提示" message:@"该用户还没有同意您的请,请耐心等待" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [aler show];
        }
        else if([self.valuablesInfo.isOpen isEqualToString:@"0"]&&[self.valuablesInfo.isAgree isEqualToString:@"0"]){
            UIAlertView *aler =[[UIAlertView alloc]initWithTitle:@"提示" message:@"该用户拒绝了您的交易" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [aler show];
        }
    }
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.valuablesInfo.photos count];
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
//    for (UIView *v in cell.contentView.subviews) {
//        [v removeFromSuperview];
//    }
    NSString *string = [self.valuablesInfo.photos objectAtIndex:indexPath.row][@"paths"];
    UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    [backImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",string]] placeholderImage:nil];
    [cell.contentView addSubview:backImage];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BrowseViewController *view = [[BrowseViewController alloc]init];
    if (indexPath.section == 0) {
        view.page = indexPath.row;
    }
    else
    {
        view.page = indexPath.row + 4;
    }
    view.photoArray = self.valuablesInfo.photos;
    [self.navigationController pushViewController:view animated:YES];
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
