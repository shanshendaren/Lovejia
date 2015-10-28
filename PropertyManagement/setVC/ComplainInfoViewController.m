//
//  ComplainInfoViewController.m
//  PropertyManagement
//
//  Created by admin on 14/11/22.
//  Copyright (c) 2014年 admin. All rights reserved.
//

#import "ComplainInfoViewController.h"
#import "VersionAdapter.h"
#import "RequestUtil.h"
#import "ActivityView.h"
#import "SVProgressHUD.h"
#import "BrowseViewController.h"
#import "UIImageView+WebCache.h"


@interface ComplainInfoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    ActivityView *activity;
    UILabel *titleLabelInfo;
    UILabel * timeLabel;
    UITextView * contentView;
    UILabel * isdone;
    CGFloat Y;
    UIButton * wBtn1;
    UIButton * wBtn2;
    UIButton * wBtn3;
    UITextView * contentView1;
    int isFeedback;
    Complain * com;

}
@property (nonatomic,strong)UICollectionView *collectionView;

@end

@implementation ComplainInfoViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [VersionAdapter setViewLayout:self];
    [self createUI];
    
    // Do any additional setup after loading the view.
}

-(void)createUI{
    [self createBack];
    isFeedback = 0;
    [self.view setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0  blue:238.0/255.0  alpha:1.0]];
    self.title = @"投诉详情";
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:FONT_SIZE],NSFontAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];

    UIScrollView * sv =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height -44-[VersionAdapter getMoreVarHead])];
    [sv setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0  blue:238.0/255.0  alpha:1.0]];
    [sv setUserInteractionEnabled:YES];
    [self.view addSubview:sv];
    
    activity = [[ActivityView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44 - [VersionAdapter getMoreVarHead]) loadStr:NSLocalizedString(@"正在加载...", nil)];
    
    RequestUtil *requestUtil = [[RequestUtil alloc]init];
    //业务数据参数组织成JSON字符串
    NSString *biz = [NSString  stringWithFormat:@"{\"cpId\":\"%@\"}",self.comId];
    NSString *sid = @"FindComplaintById";
    [requestUtil startRequest:sid biz:biz send:self];
    
    
    if (self.complain.photos.count == 0) {
        Y = 0;
    }else{
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        self.collectionView.backgroundColor = [UIColor clearColor];
        [flowLayout setItemSize:CGSizeMake(90, 90)];
        flowLayout.minimumLineSpacing = 2.0;
        [flowLayout setSectionInset:UIEdgeInsetsMake(5, 5, 5, 5)];
        if (self.complain.photos.count>3) {
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
        Y = self.collectionView.frame.size.height + self.collectionView.frame.origin.y+ 1;
    }

    
    UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, Y, self.view.frame.size.width, 35)];
    [view1 setBackgroundColor:[UIColor whiteColor]];
    [sv addSubview:view1];
    
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(75, 5, 1, 25)];
    [line1 setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0  blue:238.0/255.0  alpha:1.0]];
    [view1 addSubview:line1];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 60, 35)];
    titleLabel.text = @"投诉标题";
    [titleLabel setFont:[UIFont fontWithName:@"Arial" size:FONT_SIZE]];
    [view1 addSubview:titleLabel];
    
    titleLabelInfo = [[UILabel alloc]initWithFrame:CGRectMake(85, 3, self.view.frame.size.width-120, 30)];
    titleLabelInfo.font = [UIFont fontWithName:@"Arial" size:FONT_SIZE];
    [view1 addSubview:titleLabelInfo];
    
    Y = view1.frame.size.height + view1.frame.origin.y+ 1;

    UIView * view2 = [[UIView alloc]initWithFrame:CGRectMake(0, Y, self.view.frame.size.width, 35)];
    [view2 setBackgroundColor:[UIColor whiteColor]];
    [sv addSubview:view2];
    
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(75, 5, 1, 25)];
    [line2 setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0  blue:238.0/255.0  alpha:1.0]];
    [view2 addSubview:line2];
    
    UILabel *complainLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 60, 35)];
    complainLabel.text = @"创建时间";
    [complainLabel setFont:[UIFont fontWithName:@"Arial" size:FONT_SIZE]];
    [view2 addSubview:complainLabel];
    
    timeLabel =  [[UILabel alloc]initWithFrame:CGRectMake(85, 3,self.view.frame.size.width-120,30)];
    timeLabel.font = [UIFont fontWithName:@"Arial" size:FONT_SIZE];
    [view2 addSubview:timeLabel];
    
    Y = view2.frame.size.height + view2.frame.origin.y+ 1;

    UIView * view3 = [[UIView alloc]initWithFrame:CGRectMake(0,Y, self.view.frame.size.width, 170)];
    [view3 setBackgroundColor:[UIColor whiteColor]];
    [sv addSubview:view3];
    
    UILabel *infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 65, 60, 40)];
    infoLabel.text = @"投诉内容";
    [infoLabel setFont:[UIFont fontWithName:@"Arial" size:FONT_SIZE]];
    [view3 addSubview:infoLabel];
    
    UIView * line3 = [[UIView alloc]initWithFrame:CGRectMake(75, 10, 1, 150)];
    [line3 setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0  blue:238.0/255.0  alpha:1.0]];
    [view3 addSubview:line3];
    
    contentView= [[UITextView  alloc] initWithFrame:CGRectMake(85, 0, self.view.frame.size.width-110, 170)] ; //初始化大小
    contentView.tag = 2;
    [contentView setBackgroundColor:[UIColor clearColor]];
    contentView.font = [UIFont fontWithName:@"Arial" size:FONT_SIZE];//设置字体名字和字体大小
    contentView.delegate = self;//设置它的委托方法
    contentView.returnKeyType = UIReturnKeyDefault;//返回键的类型
    contentView.keyboardType = UIKeyboardTypeDefault;//键盘类型
    [contentView setEditable:YES];
    contentView.scrollEnabled = YES;//是否可以拖动
    [contentView setEditable:NO];
    contentView.textColor = [UIColor blackColor];
    [view3 addSubview: contentView];
    
    Y = view3.frame.size.height + view3.frame.origin.y+ 1;

    UIView * view4 = [[UIView alloc]initWithFrame:CGRectMake(0, Y, self.view.frame.size.width, 35)];
    [view4 setBackgroundColor:[UIColor whiteColor]];
    [sv addSubview:view4];
    
    UIView * line4 = [[UIView alloc]initWithFrame:CGRectMake(75, 5, 1, 25)];
    [line4 setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0  blue:238.0/255.0  alpha:1.0]];
    [view4 addSubview:line4];
    
    UILabel *doLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 60, 35)];
    doLabel.text = @"是否受理";
    [doLabel setFont:[UIFont fontWithName:@"Arial" size:FONT_SIZE]];
    [view4 addSubview:doLabel];
    
    isdone = [[UILabel alloc]initWithFrame:CGRectMake(85, 3, self.view.frame.size.width-120, 30)];
    isdone.font = [UIFont fontWithName:@"Arial" size:FONT_SIZE];
    [view4 addSubview:isdone];
    
    Y = view4.frame.size.height + view4.frame.origin.y+ 1;
    
    UIView * view6 = [[UIView alloc]initWithFrame:CGRectMake(0,Y, self.view.frame.size.width, 80)];
    [view6 setBackgroundColor:[UIColor whiteColor]];
    [sv addSubview:view6];
    
    UILabel *infoLabel6 = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 60, 40)];
    infoLabel6.text = @"受理方案";
    [infoLabel6 setFont:[UIFont fontWithName:@"Arial" size:FONT_SIZE]];
    [view6 addSubview:infoLabel6];
    
    UIView * line6 = [[UIView alloc]initWithFrame:CGRectMake(75, 5, 1, 70)];
    [line6 setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0  blue:238.0/255.0  alpha:1.0]];
    [view6 addSubview:line6];
    
    contentView1= [[UITextView  alloc] initWithFrame:CGRectMake(85, 0, self.view.frame.size.width-110, 80)] ; //初始化大小
    [contentView1 setBackgroundColor:[UIColor clearColor]];
    contentView1.font = [UIFont fontWithName:@"Arial" size:FONT_SIZE];//设置字体名字和字体大小
    contentView1.delegate = self;//设置它的委托方法
    contentView1.returnKeyType = UIReturnKeyDefault;//返回键的类型
    contentView1.keyboardType = UIKeyboardTypeDefault;//键盘类型
    [contentView1 setEditable:YES];
    contentView1.scrollEnabled = YES;//是否可以拖动
    [contentView1 setEditable:NO];
    contentView1.textColor = [UIColor blackColor];
    [view6 addSubview: contentView1];

    Y = view6.frame.size.height + view6.frame.origin.y+ 1;

    UIView * view5 = [[UIView alloc]initWithFrame:CGRectMake(0, Y, self.view.frame.size.width, 40)];
    [view5 setBackgroundColor:[UIColor whiteColor]];
    [sv addSubview:view5];
    
    UIView * line5 = [[UIView alloc]initWithFrame:CGRectMake(75, 5, 1, 30)];
    [line5 setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0  blue:238.0/255.0  alpha:1.0]];
    [view5 addSubview:line5];
    
    UILabel *doLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 60, 40)];
    doLabel1.text = @"评价";
    [doLabel1 setFont:[UIFont fontWithName:@"Arial" size:FONT_SIZE]];
    [view5 addSubview:doLabel1];
    
    wBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [wBtn1 setFrame:CGRectMake(100, 5, 50, 30)];
    wBtn1.tag = 3;
    [wBtn1 setBackgroundImage:[UIImage imageNamed:@"evolution_07.png"] forState:UIControlStateNormal];
    [wBtn1 addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [view5 addSubview:wBtn1];
     wBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [wBtn2 setFrame:CGRectMake(175, 5, 50, 30)];
    wBtn2.tag = 2;
    [wBtn2 addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [wBtn2 setBackgroundImage:[UIImage imageNamed:@"evolution_09.png"] forState:UIControlStateNormal];
    [view5 addSubview:wBtn2];
    
     wBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [wBtn3 setFrame:CGRectMake(250, 5, 50, 30)];
    [wBtn3 setBackgroundImage:[UIImage imageNamed:@"evolution_11.png"] forState:UIControlStateNormal];
    wBtn3.tag = 1;
    [wBtn3 addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [view5 addSubview:wBtn3];
    [sv setContentSize:CGSizeMake(self.view.frame.size.width, Y+45)];
    
}

-(void)clickAction:(UIButton *)btn{
      if (isFeedback ==0) {
        RequestUtil *requestUtil = [[RequestUtil alloc]init];
        //业务数据参数组织成JSON字符串
        NSString *biz = [NSString  stringWithFormat:@"{\"cpId\":\"%@\",\"feedbackStatus\":\"%d\"}",self.comId,(int)btn.tag];
        NSString *sid = @"ComplaintFeedback";
        [requestUtil startRequest:sid biz:biz send:self];
    }else{
        UIAlertView *alertDialog = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"已经评价过，不能再评价" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertDialog show];
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
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
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
    if ([json[@"SID"]isEqualToString:@"FindComplaintById"]) {
        NSDictionary *dic = json[@"complaint"];
        if (dic) {
            com =[[Complain alloc]init];
            com.cpTitle =[dic objectForKey:@"cpTitle"];
            com.cpMess =[dic objectForKey:@"cpMess"];
            com.cpTime =[dic objectForKey:@"cpTime"];
            com.cpAcceptRemark =[dic objectForKey:@"cpAcceptRemark"];
            if ([dic objectForKey:@"isAccept"]) {
                com.cp_isAccept =[[dic objectForKey:@"isAccept"] intValue];
            }
            if ([dic objectForKey:@"cpAcceptTime"]) {
                com.cpAcceptTime =[dic objectForKey:@"cpAcceptTime"];
            }
            if([dic objectForKey:@"cpFeedbackStatus"]){
                com.cpFeedbackStatus = [dic objectForKey:@"cpFeedbackStatus"];
            }
        }
        if ([json[@"status"]isEqualToString:@"success"]) {
            titleLabelInfo.text = [NSString stringWithFormat:@"%@",com.cpTitle];
            timeLabel.text = [NSString stringWithFormat:@"%@",com.cpTime];
            contentView.text = [NSString stringWithFormat:@"%@",com.cpMess];
            contentView1.text = [NSString stringWithFormat:@"%@",com.cpAcceptRemark];
            if (com.cp_isAccept == 1) {
                isdone.text = [NSString stringWithFormat:@"物业已受理"];
            }else{
                isdone.text = [NSString stringWithFormat:@"物业还未受理"];
            }
            if (com.cpFeedbackStatus) {
                int a =[com.cpFeedbackStatus intValue];
                if (a ==1) {
                    [wBtn3 setBackgroundImage:[UIImage imageNamed:@"evolution_hover_11.png"] forState:UIControlStateNormal];
                }else if (a==2){
                    [wBtn2 setBackgroundImage:[UIImage imageNamed:@"evolution_hover_09.png"] forState:UIControlStateNormal];
                }
                else if (a==3){
                    [wBtn1 setBackgroundImage:[UIImage imageNamed:@"evolution_hover_07.png"] forState:UIControlStateNormal];
                }
                isFeedback = a;
            }
        }else{
            [SVProgressHUD showErrorWithStatus:json[@"message"]];
        }
    }
    else if ([json[@"SID"]isEqualToString:@"ComplaintFeedback"]){
        if ([json[@"status"]isEqualToString:@"success"]) {
            int a =[json[@"feedbackStatus"]intValue];
            if (a ==1) {
                [wBtn3 setBackgroundImage:[UIImage imageNamed:@"evolution_hover_11.png"] forState:UIControlStateNormal];
            }else if (a==2){
                [wBtn2 setBackgroundImage:[UIImage imageNamed:@"evolution_hover_09.png"] forState:UIControlStateNormal];
            }
            else if (a==3){
                [wBtn1 setBackgroundImage:[UIImage imageNamed:@"evolution_hover_07.png"] forState:UIControlStateNormal];
            }
            isFeedback = a;
        }else{
            [SVProgressHUD showErrorWithStatus:json[@"message"]];
        }
    }
    if ([activity isVisible]) {
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

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.complain.photos count];
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    //    for (UIView *v in cell.contentView.subviews) {
    //        [v removeFromSuperview];
    //    }
    
    NSString *string = [self.complain.photos objectAtIndex:indexPath.row][@"paths"];
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
    view.photoArray = self.complain.photos;
    [self.navigationController pushViewController:view animated:YES];
}


- (void)didReceiveMemoryWarning {
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
