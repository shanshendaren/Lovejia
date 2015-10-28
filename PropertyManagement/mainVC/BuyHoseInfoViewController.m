//
//  BuyHoseInfoViewController.m
//  PropertyManagement
//
//  Created by admin on 15/2/27.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "BuyHoseInfoViewController.h"
#import "BrowseViewController.h"
#import "VersionAdapter.h"
#import "UIImageView+WebCache.h"


@interface BuyHoseInfoViewController ()
{
    CGFloat Y;
    
}
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)UIScrollView *scrollView;

@end

@implementation BuyHoseInfoViewController


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
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.97f alpha:1.0f]];
    [VersionAdapter setViewLayout:self];
    self.navigationItem.title = @"买房详情";
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
    
    Y = 5;
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, Y, self.view.frame.size.width, 35)];
    [titleLabel setBackgroundColor:[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0]];
    titleLabel.numberOfLines = 0;
     titleLabel.text = [NSString stringWithFormat:@"   %@",self.house.secondarysaleInfoTitle];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor blackColor];
    [sv addSubview:titleLabel];
    Y = titleLabel.frame.size.height + titleLabel.frame.origin.y+5;
    
    UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, Y, self.view.frame.size.width, 35)];
    [typeLabel setBackgroundColor:[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0]];
    typeLabel.numberOfLines = 0;
    typeLabel.text = [NSString stringWithFormat:@"   发布房型: %@",self.house.houseType];
    typeLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    typeLabel.textColor = [UIColor blackColor];
    [sv addSubview:typeLabel];
    
    Y = typeLabel.frame.size.height + typeLabel.frame.origin.y +5;
    
    UILabel *addLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, Y, self.view.frame.size.width, 35)];
    [addLabel setBackgroundColor:[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0]];
    addLabel.numberOfLines = 0;
    addLabel.text = [NSString stringWithFormat:@"   房屋地址: %@",self.house.houseAddress];
    addLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    addLabel.textColor = [UIColor blackColor];
    [sv addSubview:addLabel];
    
    Y = addLabel.frame.size.height + addLabel.frame.origin.y +5;
    
    UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, Y, self.view.frame.size.width, 35)];
    [priceLabel setBackgroundColor:[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0]];
    priceLabel.numberOfLines = 0;
    priceLabel.text = [NSString stringWithFormat:@"   房屋价格: %@",self.house.housePrice];
    priceLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    priceLabel.textColor = [UIColor blackColor];
    [sv addSubview:priceLabel];
    
    Y = priceLabel.frame.size.height + priceLabel.frame.origin.y +5;
    
    UILabel *jianjieLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, Y, self.view.frame.size.width, 30)];
    jianjieLabel.text = [NSString stringWithFormat:@"   发布时间 %@",self.house.repaeaseDate];
    [jianjieLabel setBackgroundColor:[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0]];
    jianjieLabel.textColor = [UIColor grayColor];
    jianjieLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    [sv addSubview:jianjieLabel];
    Y = jianjieLabel.frame.size.height + jianjieLabel.frame.origin.y + 5;
    
    UITextView *contentLabel = [[UITextView alloc]initWithFrame:CGRectMake(0, Y, self.view.frame.size.width, 150)];
    contentLabel.editable = NO;
    contentLabel.text = [NSString stringWithFormat:@"%@",self.house.secondarysaleContent];
    contentLabel.textColor = [UIColor grayColor];
    contentLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    [sv addSubview:contentLabel];
    [sv setContentSize:CGSizeMake(self.view.frame.size.width, Y+85)];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-44-[VersionAdapter getMoreVarHead] - 50, self.view.frame.size.width, 50)];
    [backView setBackgroundColor:[UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.0]];
    [self.view addSubview:backView];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 120, 15)];
    nameLabel.text = self.house.repaeaseName;
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    [backView addSubview:nameLabel];
    
    UILabel *telLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 25, 120, 15)];
    telLabel.text = self.house.repaeaseTel;
    telLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    telLabel.textColor = [UIColor blackColor];
    [backView addSubview:telLabel];
    
    UIButton *callBtn = [[UIButton alloc]initWithFrame:CGRectMake(124, 7, 180, 35)];
    callBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    [callBtn setBackgroundImage:[UIImage imageNamed:@"17"] forState:UIControlStateNormal];
    [callBtn setTitle:@"联系发布人" forState:UIControlStateNormal];
    [callBtn addTarget:self action:@selector(callTo:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:callBtn];
}

-(void)callTo:(UIButton *)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.house.repaeaseTel]]];
}

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
