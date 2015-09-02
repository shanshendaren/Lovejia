//
//  SaleHouseInfoViewController.m
//  PropertyManagement
//
//  Created by admin on 15/2/27.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "SaleHouseInfoViewController.h"
#import "BrowseViewController.h"
#import "VersionAdapter.h"
#import "UIImageView+WebCache.h"

@interface SaleHouseInfoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    CGFloat Y;
    
}
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)UIScrollView *scrollView;

@end

@implementation SaleHouseInfoViewController

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
    self.navigationItem.title = @"卖房详情";
    UIScrollView *sv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height-44-[VersionAdapter getMoreVarHead] - 50)];
    [sv setUserInteractionEnabled:YES];
    [self.view addSubview:sv];
    //[self.view setBackgroundColor:[UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.0]];
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 15, 15);
    backButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    
    if (self.house.photos.count == 0) {
        Y = 5;
    }else{
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        self.collectionView.backgroundColor = [UIColor clearColor];
        [flowLayout setItemSize:CGSizeMake(90, 90)];
        flowLayout.minimumLineSpacing = 2.0;
        [flowLayout setSectionInset:UIEdgeInsetsMake(5, 5, 5, 5)];
        if (self.house.photos.count>3) {
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

//    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
//    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
//    self.collectionView.backgroundColor = [UIColor clearColor];
//    [flowLayout setItemSize:CGSizeMake(90, 90)];
//    flowLayout.minimumLineSpacing = 2.0;
//    [flowLayout setSectionInset:UIEdgeInsetsMake(5, 5, 5, 5)];
//    
//    if (self.house.photos.count>3) {
//        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 180) collectionViewLayout:flowLayout];
//    }
//    else
//    {
//        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 90) collectionViewLayout:flowLayout];
//    }
//    UIView *vi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, self.collectionView.frame.size.height)];
//    [vi setBackgroundColor:[UIColor whiteColor]];
//    [self.collectionView setBackgroundView:vi];
//    self.collectionView.scrollEnabled = NO;
//    self.collectionView.dataSource = self;
//    self.collectionView.delegate = self;
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CollectionCell"];
//    [sv addSubview:self.collectionView];
//    
//    Y = self.collectionView.frame.size.height + self.collectionView.frame.origin.y+ 5;
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, Y, self.view.frame.size.width, 40)];
    [titleLabel setBackgroundColor:[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0]];
    titleLabel.numberOfLines = 0;
    titleLabel.text = self.house.secondarysaleInfoTitle;
    titleLabel.font = [UIFont systemFontOfSize:16.f];
    titleLabel.textColor = [UIColor blackColor];
    [sv addSubview:titleLabel];
    Y = titleLabel.frame.size.height + titleLabel.frame.origin.y+5;
    
    UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, Y, self.view.frame.size.width, 40)];
    [typeLabel setBackgroundColor:[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0]];
    typeLabel.numberOfLines = 0;
    typeLabel.text = [NSString stringWithFormat:@"发布房型: %@",self.house.houseType];
    typeLabel.font = [UIFont systemFontOfSize:14.f];
    typeLabel.textColor = [UIColor blackColor];
    [sv addSubview:typeLabel];

    Y = typeLabel.frame.size.height + typeLabel.frame.origin.y +5;
    
    UILabel *addLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, Y, self.view.frame.size.width, 40)];
    [addLabel setBackgroundColor:[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0]];
    addLabel.numberOfLines = 0;
    addLabel.text = [NSString stringWithFormat:@"房屋地址: %@",self.house.houseAddress];
    addLabel.font = [UIFont systemFontOfSize:14.f];
    addLabel.textColor = [UIColor blackColor];
    [sv addSubview:addLabel];
    
    Y = addLabel.frame.size.height + addLabel.frame.origin.y +5;

    UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, Y, self.view.frame.size.width, 40)];
    [priceLabel setBackgroundColor:[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0]];
    priceLabel.numberOfLines = 0;
    priceLabel.text = [NSString stringWithFormat:@"房屋价格: %@",self.house.housePrice];
    priceLabel.font = [UIFont systemFontOfSize:14.f];
    priceLabel.textColor = [UIColor blackColor];
    [sv addSubview:priceLabel];
    
    Y = priceLabel.frame.size.height + priceLabel.frame.origin.y +5;

    UILabel *jianjieLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, Y, self.view.frame.size.width, 30)];
    jianjieLabel.text = [NSString stringWithFormat:@"发布时间 %@",self.house.repaeaseDate];
    [jianjieLabel setBackgroundColor:[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0]];
    jianjieLabel.textColor = [UIColor grayColor];
    jianjieLabel.font = [UIFont systemFontOfSize:14.f];
    [sv addSubview:jianjieLabel];
    Y = jianjieLabel.frame.size.height + jianjieLabel.frame.origin.y + 5;
    
    UITextView *contentLabel = [[UITextView alloc]initWithFrame:CGRectMake(0, Y, self.view.frame.size.width, 80)];
    contentLabel.editable = NO;
    contentLabel.text = [NSString stringWithFormat:@"%@",self.house.secondarysaleContent];
    contentLabel.textColor = [UIColor grayColor];
    contentLabel.font = [UIFont systemFontOfSize:14.f];
    [sv addSubview:contentLabel];
    [sv setContentSize:CGSizeMake(self.view.frame.size.width, Y+85)];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-44-[VersionAdapter getMoreVarHead] - 50, self.view.frame.size.width, 50)];
    [backView setBackgroundColor:[UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.0]];
    [self.view addSubview:backView];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 120, 15)];
    nameLabel.text = self.house.repaeaseName;
    nameLabel.textColor = [UIColor blackColor];
    [backView addSubview:nameLabel];
    
    UILabel *telLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 25, 120, 15)];
    telLabel.text = self.house.repaeaseTel;
    telLabel.font = [UIFont systemFontOfSize:12.f];
    telLabel.textColor = [UIColor grayColor];
    [backView addSubview:telLabel];
    
    UIButton *callBtn = [[UIButton alloc]initWithFrame:CGRectMake(124, 5, 180, 40)];
    [callBtn setBackgroundImage:[UIImage imageNamed:@"next_button_bg.png"] forState:UIControlStateNormal];
    [callBtn setTitle:@"联系发布人" forState:UIControlStateNormal];
    [callBtn addTarget:self action:@selector(callTo:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:callBtn];
}

-(void)callTo:(UIButton *)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.house.repaeaseTel]]];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.house.photos count];
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    //    for (UIView *v in cell.contentView.subviews) {
    //        [v removeFromSuperview];
    //    }
    
    NSString *string = [self.house.photos objectAtIndex:indexPath.row][@"paths"];
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
    view.photoArray = self.house.photos;
    [self.navigationController pushViewController:view animated:YES];
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
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
