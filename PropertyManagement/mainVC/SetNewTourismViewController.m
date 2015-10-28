//
//  SetNewTourismViewController.m
//  PropertyManagement
//
//  Created by admin on 15/2/3.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "SetNewTourismViewController.h"
#import "VersionAdapter.h"
#import "CommonUtil.h"
#import "RequestUtil.h"
#import "BZAppDelegate.h"
#import "SVProgressHUD.h"
#import "ActivityView.h"
#import "TableViewWithBlock.h"
#import "SelectionCell.h"
#import <QuartzCore/QuartzCore.h>
#import "DatePickViewCon.h"

@interface SetNewTourismViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UITextFieldDelegate,UITextViewDelegate,DatePickDelegate>
{
    UIImageView *iv;
    NSString *picPath;
    ActivityView *activity;
    int tourisType;
    CGFloat Y;
    BOOL isOpened;
    int mobileType;
    UILabel *timeLabel;
    UIButton *timeBTN;
}

@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray *photoArray;
@property (nonatomic,strong)UITextField *titleTextField;
@property (nonatomic,strong)UITextView *describeTextField;
@property (nonatomic,strong)UITextView *text_neirong;
@property (nonatomic,strong)UITextField *text_chufa;
@property (nonatomic,strong)UITextField *text_mudi;
@property (nonatomic,strong)UITextField *text_luxian;
@property (nonatomic,strong)UITextField *text_shijian;
@property (nonatomic,strong)UITapGestureRecognizer *tap;//单击手势
@property (nonatomic,strong)UITextField *text_type;
@property (nonatomic,strong)TableViewWithBlock *tb;
@property (nonatomic,strong)UIButton *type_btn;
@property (nonatomic,strong)NSArray *listTeams;

@property (nonatomic,strong) UITextView * tV;
@property (nonatomic,strong) UITextField * tF;



@end

@implementation SetNewTourismViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [VersionAdapter setViewLayout:self];
    
    RequestUtil *request =[[RequestUtil alloc]init];
    NSString * str =@"PCLX";
    NSString *biz = [NSString  stringWithFormat:@"{\"type\":\"%@\"}",str];
    NSString *sid = @"Sysdiclist";
    [request startRequest:sid biz:biz send:self];

    
    UIScrollView *sv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height-44-[VersionAdapter getMoreVarHead])];
    [sv setBackgroundColor:[UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.0]];
    [sv setUserInteractionEnabled:YES];
    [self.view addSubview:sv];
    self.view.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.0];
    self.title = @"社区拼车";
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:FONT_SIZE],NSFontAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    [self createBack];
    
    mobileType = 0;
    tourisType = 1;
    activity = [[ActivityView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44 - [VersionAdapter getMoreVarHead]) loadStr:NSLocalizedString(@"正在加载...", nil)];

    self.photoArray = [[NSMutableArray alloc]initWithObjects:@"null", nil];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [flowLayout setItemSize:CGSizeMake(60, 60)];
    flowLayout.minimumLineSpacing = 5.0;
    [flowLayout setSectionInset:UIEdgeInsetsMake(10, 10, 10, 10)];
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80) collectionViewLayout:flowLayout];
    UIView *vi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, self.collectionView.frame.size.height)];
    
    [vi setBackgroundColor:[UIColor whiteColor]];
    [self.collectionView setBackgroundView:vi];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CollectionCell"];
    [sv addSubview:self.collectionView];
    
    Y = self.collectionView.frame.size.height + self.collectionView.frame.origin.y;
    
    UIView *back_one = [[UIView alloc]initWithFrame:CGRectMake(0, Y+1, self.view.frame.size.width, 35)];
    [back_one setBackgroundColor:[UIColor whiteColor]];
    [sv addSubview:back_one];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 75, 35)];
    titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    titleLabel.text = @"标题";
    titleLabel.textAlignment = 1;
    titleLabel.backgroundColor = [UIColor whiteColor];
    [back_one addSubview:titleLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(75, 2, 1, 30)];
    lineView.backgroundColor = LINECOLOR;
    [back_one addSubview:lineView];
    
    self.titleTextField = [[UITextField alloc]initWithFrame:CGRectMake(82, 0, self.view.frame.size.width - 62, 35)];
    self.titleTextField.font = [UIFont systemFontOfSize:FONT_SIZE];
    [self.titleTextField setBackgroundColor:[UIColor whiteColor]];
    self.titleTextField.placeholder = @"请输入标题";
    [back_one addSubview:self.titleTextField];
    
    Y = back_one.frame.size.height + back_one.frame.origin.y + 1;
    
    //类型
    UIView *back_two = [[UIView alloc]initWithFrame:CGRectMake(0, Y, self.view.frame.size.width, 35)];
    [back_two setBackgroundColor:[UIColor whiteColor]];
    [sv addSubview:back_two];
    
    UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,75, 35)];
    typeLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    typeLabel.text = @"类型";
    typeLabel.textAlignment = 1;
    typeLabel.backgroundColor = [UIColor whiteColor];
    [back_two addSubview:typeLabel];
    
    UIView *lView = [[UIView alloc]initWithFrame:CGRectMake(75, 2, 1, 30)];
    lView.backgroundColor = LINECOLOR;
    [back_two addSubview:lView];
    
    _type_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_type_btn setFrame:CGRectMake(82, 2,  self.view.frame.size.width-150, 35)];
    [back_two addSubview:_type_btn];
    
    UIImageView *iv11 =[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-64, 20, 10, 10)];
    [iv11 setImage:[UIImage imageNamed:@"select"]];
    [_type_btn addSubview:iv11];
    
    self.text_type = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 150, 35)];
    self.text_type.font = [UIFont systemFontOfSize:FONT_SIZE];
    [self.text_type setEnabled:NO];
//    self.text_type.text = [NSString stringWithFormat:@"%@",self.listTeams[0]];
    [_type_btn addSubview:self.text_type];

    [_type_btn addTarget:self action:@selector(changeOpenStatus:) forControlEvents:UIControlEventTouchUpInside];
    _tb = [[TableViewWithBlock alloc]initWithFrame:CGRectMake(80, Y+34, self.view.frame.size.width - 82, 0.5)];
    [_tb initTableViewDataSourceAndDelegate:^(UITableView *tableView,NSInteger section){
        return (int)self.listTeams.count;
    } setCellForIndexPathBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
        if (!cell) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"SelectionCell" owner:self options:nil]objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        [cell.lb setText:[NSString stringWithFormat:@"%@",[[self.listTeams objectAtIndex:indexPath.row]objectForKey:@"chname"]]];
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    } setDidSelectRowBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=(SelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
        self.text_type.text=cell.lb.text;
        tourisType = (int)indexPath.row+1;
        [_type_btn sendActionsForControlEvents:UIControlEventTouchUpInside];
    }];
    [_tb.layer setBorderColor:[UIColor clearColor].CGColor];
    [_tb.layer setBorderWidth:2];
    Y = back_two.frame.size.height + back_two.frame.origin.y + 1;
    
    BZAppDelegate *app = [UIApplication sharedApplication].delegate;
    //出发地
    UIView *back_four = [[UIView alloc]initWithFrame:CGRectMake(0, Y, self.view.frame.size.width, 35)];
    [back_four setBackgroundColor:[UIColor whiteColor]];
    [sv addSubview:back_four];
    UILabel *label_four = [[UILabel alloc]initWithFrame:CGRectMake(0,0, 75, 35)];
    label_four.font = [UIFont systemFontOfSize:FONT_SIZE];
    label_four.text = @"出发地";
    label_four.textAlignment = 1;
    [back_four addSubview:label_four];
    
    UIView *View_four = [[UIView alloc]initWithFrame:CGRectMake(75, 2, 1, 30)];
    View_four.backgroundColor = LINECOLOR;
    [back_four addSubview:View_four];
    
    self.text_chufa = [[UITextField alloc]initWithFrame:CGRectMake(82, 0,self.view.frame.size.width- 82 ,35)];
    self.text_chufa.font = [UIFont systemFontOfSize:FONT_SIZE];
    self.text_chufa.tag = 100;
    self.text_chufa.delegate = self;
    self.text_chufa.text = [NSString stringWithFormat:@"%@",app.vallageName];
    [back_four addSubview:self.text_chufa ];
    
    Y = back_four.frame.size.height + back_four.frame.origin.y + 1;

    //目的地
    UIView *back_four1 = [[UIView alloc]initWithFrame:CGRectMake(0, Y, self.view.frame.size.width, 35)];
    [back_four1 setBackgroundColor:[UIColor whiteColor]];
    [sv addSubview:back_four1];
    UILabel *label_four1 = [[UILabel alloc]initWithFrame:CGRectMake(0,0, 75, 35)];
    label_four1.font = [UIFont systemFontOfSize:FONT_SIZE];
    label_four1.text = @"目的地";
    label_four1.textAlignment = 1;
    [back_four1 addSubview:label_four1];
    //
    UIView *View_four1 = [[UIView alloc]initWithFrame:CGRectMake(75, 2, 1, 30)];
    View_four1.backgroundColor = LINECOLOR;
    [back_four1 addSubview:View_four1];
    
    self.text_mudi = [[UITextField alloc]initWithFrame:CGRectMake(82, 0,self.view.frame.size.width- 82 ,35)];
    self.text_mudi.font = [UIFont systemFontOfSize:FONT_SIZE];
    self.text_mudi.placeholder = @"请输入目的地";
    self.text_mudi.delegate = self;
    self.text_mudi.tag = 100;
    [back_four1 addSubview:self.text_mudi ];
    
    Y = back_four1.frame.size.height + back_four1.frame.origin.y + 1;

    //路线
    UIView *back_four2 = [[UIView alloc]initWithFrame:CGRectMake(0, Y, self.view.frame.size.width, 35)];
    [back_four2 setBackgroundColor:[UIColor whiteColor]];
    [sv addSubview:back_four2];
    UILabel *label_four2 = [[UILabel alloc]initWithFrame:CGRectMake(0,0, 75, 35)];
    label_four2.font = [UIFont systemFontOfSize:FONT_SIZE];
    label_four2.text = @"路线";
    label_four2.textAlignment = 1;
    [back_four2 addSubview:label_four2];
    //
    UIView *View_four2 = [[UIView alloc]initWithFrame:CGRectMake(75, 2, 1, 30)];
    View_four2.backgroundColor = LINECOLOR;
    [back_four2 addSubview:View_four2];
    
    self.text_luxian = [[UITextField alloc]initWithFrame:CGRectMake(82, 0,self.view.frame.size.width- 82 ,35)];
    self.text_luxian.font = [UIFont systemFontOfSize:FONT_SIZE];
    self.text_luxian.placeholder = @"请输入路线";
    self.text_luxian.delegate = self;
    self.text_luxian.tag = 100;
    [back_four2 addSubview:self.text_luxian ];

    Y = back_four2.frame.size.height + back_four2.frame.origin.y + 1;
    
    //出发时间
    UIView *back_four3 = [[UIView alloc]initWithFrame:CGRectMake(0, Y, self.view.frame.size.width, 35)];
    [back_four3 setBackgroundColor:[UIColor whiteColor]];
    [sv addSubview:back_four3];
    UILabel *label_four3 = [[UILabel alloc]initWithFrame:CGRectMake(0,0, 75, 35)];
    label_four3.font = [UIFont systemFontOfSize:FONT_SIZE];
    label_four3.text = @"出发时间";
    label_four3.textAlignment = 1;
    [back_four3 addSubview:label_four3];
    
    UIView *View_four3 = [[UIView alloc]initWithFrame:CGRectMake(75, 2, 1, 30)];
    View_four3.backgroundColor = LINECOLOR;
    [back_four3 addSubview:View_four3];
    
    timeBTN =[UIButton buttonWithType:UIButtonTypeCustom];
    [timeBTN setFrame:CGRectMake(82, 0, self.view.frame.size.width-82, 35)];
    [timeBTN addTarget:self action:@selector(timeclicked) forControlEvents:UIControlEventTouchUpInside];
    
    timeLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-82, 35)];
    timeLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
    [timeBTN addSubview:timeLabel];
    [back_four3 addSubview:timeBTN];
    
    Y = back_four3.frame.size.height + back_four3.frame.origin.y + 1;


    //描述
    UIView *back_three = [[UIView alloc]initWithFrame:CGRectMake(0, Y, self.view.frame.size.width, 160)];
    [back_three setBackgroundColor:[UIColor whiteColor]];
    [sv addSubview:back_three];
    UILabel *label_two = [[UILabel alloc]initWithFrame:CGRectMake(0,0, 75, 160)];
    label_two.font = [UIFont systemFontOfSize:FONT_SIZE];
    label_two.text = @"要求";
    label_two.textAlignment = 1;
    [back_three addSubview:label_two];
    
    UIView *llView = [[UIView alloc]initWithFrame:CGRectMake(75, 4, 1, 152)];
    llView.backgroundColor = LINECOLOR;
    [back_three addSubview:llView];
    
    self.text_neirong = [[UITextView alloc]initWithFrame:CGRectMake(82, 0,self.view.frame.size.width- 82 ,160)];
    self.text_neirong.font = [UIFont systemFontOfSize:FONT_SIZE];
    self.text_neirong.delegate = self;
    [back_three addSubview:self.text_neirong ];
    [sv addSubview:_tb];
    
    Y = back_three.frame.size.height + back_three.frame.origin.y + 1;

    UIView *back_four5 = [[UIView alloc]initWithFrame:CGRectMake(0, Y, self.view.frame.size.width, 50)];
    [back_four5 setBackgroundColor:[UIColor whiteColor]];
    [sv addSubview:back_four5];
    
    UISwitch *switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width-60, 10, 50, 30)];
    [switchButton setOn:NO];
    [switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [back_four5 addSubview:switchButton];
    
    UILabel *chooseLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, self.view.frame.size.width-60, 30)];
    chooseLabel.font = [UIFont systemFontOfSize:14];
    chooseLabel.text = @"请选择是否公开您的电话号码";
    [back_four5 addSubview:chooseLabel];
    
    [sv setContentSize:CGSizeMake(self.view.frame.size.width, Y+45)];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.tF resignFirstResponder];
    return YES;
}
-(void)timeclicked{
    DatePickViewCon *viewCon = [DatePickViewCon ShareDatePickViewCon];
    viewCon.delegate = self;
    [viewCon show];
}

- (void)datePickDidSelected:(DatePickViewCon *)viewCon{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:kCFDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *fixString = [dateFormatter stringFromDate:viewCon.curDate];
    timeLabel.text = [NSString stringWithFormat:@"%@",fixString];
}


-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        mobileType = 1;
    }else {
        mobileType = 0;
    }
}

-(void)changeOpenStatus:(id)sender {
    
    if (isOpened) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame=_tb.frame;
            frame.size.height=1;
            [_tb setFrame:frame];
            [_tb.layer setBorderColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0  blue:245.0/255.0  alpha:1.0].CGColor];
        } completion:^(BOOL finished){
            isOpened=NO;
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame=_tb.frame;
            frame.size.height=60;
            [_tb.layer setBorderColor:[UIColor grayColor].CGColor];
            [_tb setFrame:frame];
        } completion:^(BOOL finished){
            isOpened=YES;
        }];
    }
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.photoArray count];
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    for (UIView *v in cell.contentView.subviews) {
        [v removeFromSuperview];
    }
    if (indexPath.row + 1  < self.photoArray.count) {
        NSString *string = [self.photoArray objectAtIndex:indexPath.row];
        UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
        UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:string];
        [backImage setImage:savedImage];
        [cell.contentView addSubview:backImage];
        UIButton *deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(35, 5, 20, 20)];
        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"photo-delete.png"] forState:UIControlStateNormal];
        deleteBtn.tag = indexPath.row;
        [deleteBtn addTarget:self action:@selector(deletePhoto:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:deleteBtn];
    }
    else{
        UIImageView *backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
        [backImage setImage:[UIImage imageNamed:@"photo-ad.png"]];
        [cell.contentView addSubview:backImage];
    }
    return cell;
}

-(void)deletePhoto:(UIButton *)sender
{
    NSLog(@"%d被点击了",(int)sender.tag);
    [self.photoArray removeObjectAtIndex:sender.tag];
    [self.collectionView reloadData];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row + 1  < self.photoArray.count) {//可以删除
    }
    else{//添加照片
        [self SetPictrue];
    }
}

-(void)tourismCilckAction{
    if ([self.titleTextField.text isEqualToString:@""]) {
        UIAlertView *view =[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请输入标题" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [view show];
        return;
    }
    if ([self.text_neirong.text isEqualToString:@""]) {
        UIAlertView *view =[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请描述该物品" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [view show];
        return;
    }
    if ([self.text_mudi.text isEqualToString:@""]) {
        UIAlertView *view =[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请输入目的地" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [view show];
        return;
    }
    if ([self.text_chufa.text isEqualToString:@""]) {
        UIAlertView *view =[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请输入出发地" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [view show];
        return;
    }
    if ([self.text_luxian.text isEqualToString:@""]) {
        UIAlertView *view =[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请输入路线" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [view show];
        return;
    }
    
    if ([timeLabel.text isEqualToString:@""]) {
        UIAlertView *view =[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请选择出发时间" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [view show];
        return;
    }
    if ([self.photoArray count] > 6) {
        UIAlertView *view =[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"最多只能上传五张图片" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [view show];
        return;
    }
    BZAppDelegate *app =[UIApplication sharedApplication].delegate;
    RequestUtil *requestUtil = [[RequestUtil alloc]init];
    NSString *biz = [NSString  stringWithFormat:@"{\"userId\":\"%@\",\"title\":\"%@\",\"content\":\"%@\",\"type\":\"%i\",\"vallageId\":\"%@\",\"startPlace\":\"%@\",\"endPlace\":\"%@\",\"line\":\"%@\",\"isOpen\":\"%i\",\"departureDate\":\"%@\"}",app.userID ,self.titleTextField.text,self.text_neirong.text,tourisType,app.vallageID,self.text_chufa.text,self.text_mudi.text,self.text_luxian.text,mobileType,timeLabel.text];
    NSString *sid = @"SaveNeighborhordCarpoolInfo";
    NSMutableArray *a = [[NSMutableArray alloc]init];
    for (int i = 0; i<self.photoArray.count -1; i++) {
        [a addObject:self.photoArray[i]];
    }
    NSArray *arr =[NSArray arrayWithArray:a];
    [requestUtil startUploadFileRequest:biz sid:sid file:arr send:self];
    
  
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
        if (json[@"listInfo"]){
            self.listTeams = json[@"listInfo"];
            
            [_tb reloadData];
        }else{
        [SVProgressHUD showSuccessWithStatus:json[@"message"]];
        [self.navigationController popToRootViewControllerAnimated:YES];
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

#pragma mark - 图片上传
- (IBAction)SetPictrue {
    UIActionSheet *sheet;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
    }
    else {
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
    }
    sheet.tag = 255;
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        NSUInteger sourceType = 0;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    // 取消
                    return;
                case 1:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                    
                case 2:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
            }
        }
        else {
            if (buttonIndex == 0) {
                
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        [self presentViewController:imagePickerController animated:YES completion:^{
        }];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [CommonUtil fixOrientation:[info objectForKey:UIImagePickerControllerOriginalImage]];
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    BZAppDelegate *app = [UIApplication sharedApplication].delegate;
    NSString *imageName = [NSString stringWithFormat:@"%@_%@_%@.png",app.userID,app.userMobile,timeSp];
    [self saveImage:image withName:imageName];
}

#pragma mark - 保存图片
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    picPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    [self.photoArray insertObject:picPath atIndex:self.photoArray.count - 1];
    [imageData writeToFile:picPath atomically:NO];
}

-(void)createBack{
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 15, 15);
    backButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    //TODO: 发布按钮
    UIButton *newBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [newBtn setFrame:CGRectMake(self.view.frame.size.width-60, 0, 60, 30)];
    UILabel *saveLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    saveLab.font = [UIFont systemFontOfSize:FONT_SIZE];
    saveLab.textAlignment = NSTextAlignmentRight;
    saveLab.text = @"发布";
    saveLab.textColor = [UIColor blackColor];
    [newBtn addSubview:saveLab];
    
    [newBtn addTarget:self action:@selector(tourismCilckAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:newBtn];
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
