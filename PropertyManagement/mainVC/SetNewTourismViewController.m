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
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    [self createBack];
    
    mobileType = 0;
    tourisType = 1;
    activity = [[ActivityView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44 - [VersionAdapter getMoreVarHead]) loadStr:NSLocalizedString(@"正在加载...", nil)];
    
//    UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,44 )];
//    view1.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:view1];
//    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(20     , 7, 100, 30)];
//    label.text = @"发表帖子";
//    [view1 addSubview:label];
//    
//    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(105, 10, 1, 20)];
//    [line1 setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0  blue:238.0/255.0  alpha:1.0]];
//    [view1 addSubview:line1];
//    
//    self.tF = [[UITextField alloc]initWithFrame:CGRectMake(110, 7, self.view.frame.size.width - 110, 30)];
//    self.tF.delegate = self;
//    [view1 addSubview:self.tF];
//    
//    self.tV= [[UITextView alloc]initWithFrame:CGRectMake(0, 45, self.view.frame.size.width, 250)];
//    self.tV.delegate = self;
//    [self.view addSubview:self.tV];
//    
//    UIButton * but = [[UIButton alloc]initWithFrame:CGRectMake(50, self.view.frame.size.height-200, self.view.frame.size.width-100, 44)];
//    [but setTitle:@"确定" forState:UIControlStateNormal];
//    [but setBackgroundImage:[UIImage imageNamed:@"17"] forState:UIControlStateNormal];
//    [but addTarget:self action:@selector(tourismCilckAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:but];
//    
//    self.listTeams = [[NSArray alloc]initWithObjects:@"有车",@"拼车/无车", nil];
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
    
    UIView *back_one = [[UIView alloc]initWithFrame:CGRectMake(0, Y+10, self.view.frame.size.width, 44)];
    [back_one setBackgroundColor:[UIColor whiteColor]];
    [sv addSubview:back_one];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
    titleLabel.text = @"标题";
    titleLabel.textAlignment = 1;
    titleLabel.backgroundColor = [UIColor whiteColor];
    [back_one addSubview:titleLabel];
    
    UIImageView *lineView = [[UIImageView alloc]initWithFrame:CGRectMake(80, 4, 1, 36)];
    [lineView setImage:[UIImage imageNamed:@"line.png"]];
    [back_one addSubview:lineView];
    
    self.titleTextField = [[UITextField alloc]initWithFrame:CGRectMake(82, 0, self.view.frame.size.width - 62, 44)];
    [self.titleTextField setBackgroundColor:[UIColor whiteColor]];
    self.titleTextField.placeholder = @"请输入";
    [back_one addSubview:self.titleTextField];
    Y = back_one.frame.size.height + back_one.frame.origin.y + 10;
    
    //类型
    UIView *back_two = [[UIView alloc]initWithFrame:CGRectMake(0, Y, self.view.frame.size.width, 44)];
    [back_two setBackgroundColor:[UIColor whiteColor]];
    [sv addSubview:back_two];
    
    UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,80, 44)];
    typeLabel.text = @"类型";
    typeLabel.textAlignment = 1;
    typeLabel.backgroundColor = [UIColor whiteColor];
    [back_two addSubview:typeLabel];
    
    UIImageView *lView = [[UIImageView alloc]initWithFrame:CGRectMake(80, 4, 1, 36)];
    [lView setImage:[UIImage imageNamed:@"line.png"]];
    [back_two addSubview:lView];
    
    _type_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_type_btn setFrame:CGRectMake(82, 2,  self.view.frame.size.width-82, 40)];
    [back_two addSubview:_type_btn];
    
    UIImageView *iv11 =[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-64, 20, 20, 20)];
    [iv11 setImage:[UIImage imageNamed:@"select.png"]];
    [_type_btn addSubview:iv11];
    
    self.text_type = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 82, 40)];
    [self.text_type setEnabled:NO];
//    self.text_type.text = [NSString stringWithFormat:@"%@",self.listTeams[0]];
    [_type_btn addSubview:self.text_type];

    [_type_btn addTarget:self action:@selector(changeOpenStatus:) forControlEvents:UIControlEventTouchUpInside];
    _tb = [[TableViewWithBlock alloc]initWithFrame:CGRectMake(62, Y+44, self.view.frame.size.width - 62, 1)];
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
    Y = back_two.frame.size.height + back_two.frame.origin.y + 10;
    
    BZAppDelegate *app = [UIApplication sharedApplication].delegate;
    //出发地
    UIView *back_four = [[UIView alloc]initWithFrame:CGRectMake(0, Y, self.view.frame.size.width, 44)];
    [back_four setBackgroundColor:[UIColor whiteColor]];
    [sv addSubview:back_four];
    UILabel *label_four = [[UILabel alloc]initWithFrame:CGRectMake(0,0, 80, 44)];
    label_four.text = @"出发地";
    label_four.textAlignment = 1;
    [back_four addSubview:label_four];
    //
    UIImageView *View_four = [[UIImageView alloc]initWithFrame:CGRectMake(80, 4, 1, 36)];
    [View_four setImage:[UIImage imageNamed:@"line.png"]];
    [back_four addSubview:View_four];
    self.text_chufa = [[UITextField alloc]initWithFrame:CGRectMake(82, 0,self.view.frame.size.width- 82 ,44)];
    self.text_chufa.tag = 100;
    self.text_chufa.delegate = self;
    self.text_chufa.text = [NSString stringWithFormat:@"%@",app.vallageName];
    [back_four addSubview:self.text_chufa ];
    
    Y = back_four.frame.size.height + back_four.frame.origin.y + 10;

    //目的地
    UIView *back_four1 = [[UIView alloc]initWithFrame:CGRectMake(0, Y, self.view.frame.size.width, 44)];
    [back_four1 setBackgroundColor:[UIColor whiteColor]];
    [sv addSubview:back_four1];
    UILabel *label_four1 = [[UILabel alloc]initWithFrame:CGRectMake(0,0, 80, 44)];
    label_four1.text = @"目的地";
    label_four1.textAlignment = 1;
    [back_four1 addSubview:label_four1];
    //
    UIImageView *View_four1 = [[UIImageView alloc]initWithFrame:CGRectMake(80, 4, 1, 36)];
    [View_four1 setImage:[UIImage imageNamed:@"line.png"]];
    [back_four1 addSubview:View_four1];
    self.text_mudi = [[UITextField alloc]initWithFrame:CGRectMake(82, 0,self.view.frame.size.width- 82 ,44)];
    self.text_mudi.delegate = self;
    self.text_mudi.tag = 100;
    [back_four1 addSubview:self.text_mudi ];
    
    Y = back_four1.frame.size.height + back_four1.frame.origin.y + 10;

    //路线
    UIView *back_four2 = [[UIView alloc]initWithFrame:CGRectMake(0, Y, self.view.frame.size.width, 44)];
    [back_four2 setBackgroundColor:[UIColor whiteColor]];
    [sv addSubview:back_four2];
    UILabel *label_four2 = [[UILabel alloc]initWithFrame:CGRectMake(0,0, 80, 44)];
    label_four2.text = @"路线";
    label_four2.textAlignment = 1;
    [back_four2 addSubview:label_four2];
    //
    UIImageView *View_four2 = [[UIImageView alloc]initWithFrame:CGRectMake(80, 4, 1, 36)];
    [View_four2 setImage:[UIImage imageNamed:@"line.png"]];
    [back_four2 addSubview:View_four2];
    self.text_luxian = [[UITextField alloc]initWithFrame:CGRectMake(82, 0,self.view.frame.size.width- 82 ,44)];
    self.text_luxian.delegate = self;
    self.text_luxian.tag = 100;
    [back_four2 addSubview:self.text_luxian ];

    Y = back_four2.frame.size.height + back_four2.frame.origin.y + 10;
    
    //出发时间
    UIView *back_four3 = [[UIView alloc]initWithFrame:CGRectMake(0, Y, self.view.frame.size.width, 44)];
    [back_four3 setBackgroundColor:[UIColor whiteColor]];
    [sv addSubview:back_four3];
    UILabel *label_four3 = [[UILabel alloc]initWithFrame:CGRectMake(0,0, 80, 44)];
    label_four3.text = @"出发时间";
    label_four3.textAlignment = 1;
    [back_four3 addSubview:label_four3];
    //
    UIImageView *View_four3 = [[UIImageView alloc]initWithFrame:CGRectMake(80, 4, 1, 36)];
    [View_four3 setImage:[UIImage imageNamed:@"line.png"]];
    [back_four3 addSubview:View_four3];
    
    timeBTN =[UIButton buttonWithType:UIButtonTypeCustom];
    [timeBTN setFrame:CGRectMake(82, 0, self.view.frame.size.width-82, 44)];
    [timeBTN addTarget:self action:@selector(timeclicked) forControlEvents:UIControlEventTouchUpInside];
    
    timeLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-82, 44)];
    [timeBTN addSubview:timeLabel];
    [back_four3 addSubview:timeBTN];
    
    Y = back_four3.frame.size.height + back_four3.frame.origin.y + 10;


    //描述
    UIView *back_three = [[UIView alloc]initWithFrame:CGRectMake(0, Y, self.view.frame.size.width, 160)];
    [back_three setBackgroundColor:[UIColor whiteColor]];
    [sv addSubview:back_three];
    UILabel *label_two = [[UILabel alloc]initWithFrame:CGRectMake(0,0, 80, 160)];
    label_two.text = @"要求";
    label_two.textAlignment = 1;
    [back_three addSubview:label_two];
    //
    UIImageView *llView = [[UIImageView alloc]initWithFrame:CGRectMake(80, 4, 1, 152)];
    [llView setImage:[UIImage imageNamed:@"line.png"]];
    [back_three addSubview:llView];
    self.text_neirong = [[UITextView alloc]initWithFrame:CGRectMake(82, 0,self.view.frame.size.width- 82 ,160)];
    self.text_neirong.delegate = self;
    [back_three addSubview:self.text_neirong ];
    [sv addSubview:_tb];
    
    Y = back_three.frame.size.height + back_three.frame.origin.y + 10;

    UIView *back_four5 = [[UIView alloc]initWithFrame:CGRectMake(0, Y, self.view.frame.size.width, 40)];
    [back_four5 setBackgroundColor:[UIColor whiteColor]];
    [sv addSubview:back_four5];
    
    UISwitch *switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width-60, 5, 50, 30)];
    [switchButton setOn:NO];
    [switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [back_four5 addSubview:switchButton];
    
    UILabel *chooseLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width-60, 20)];
    chooseLabel.text = @"请选择是否公开您的电话号码";
    [back_four5 addSubview:chooseLabel];

    [sv setContentSize:CGSizeMake(self.view.frame.size.width, Y+45)];
    //定义键盘
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    [view setBackgroundColor:[UIColor grayColor]];
    UIButton *downBtn = [[UIButton alloc]initWithFrame:CGRectMake(280, 0, 40, 30)];
    [downBtn setTitle:@"完成" forState:UIControlStateNormal];
    [downBtn addTarget:self action:@selector(downKb:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:downBtn];
    [self.titleTextField setInputAccessoryView:view];
    [self.text_neirong setInputAccessoryView:view];
    [self.text_luxian setInputAccessoryView:view];
    [self.text_mudi setInputAccessoryView:view];
    [self.text_chufa setInputAccessoryView:view];
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
    [self downKb:nil];
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

-(void)downKb:(UIButton *)sender
{
    [self.text_neirong resignFirstResponder];
    [self.titleTextField resignFirstResponder];
    [self.text_chufa resignFirstResponder];
    [self.text_mudi resignFirstResponder];
    [self.text_luxian resignFirstResponder];

    CGRect curFrame = self.view.frame;
    [UIView animateWithDuration:0.3f animations:^{
        self.view.frame=CGRectMake(0, self.navigationController.navigationBar.frame.size.height + [VersionAdapter getMoreVarHead], curFrame.size.width, curFrame.size.height);
    }];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
}

- (void) animateTextField: (UITextField*) textField up:(BOOL) up
{
    if (textField.tag ==100) {
        int movementDistance = 120;
        const float movementDuration = 0.3f;
        int movement = (up ? -movementDistance : movementDistance);
        [UIView beginAnimations: @"anim" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        self.view.frame = CGRectOffset(self.view.frame, 0, movement);
        [UIView commitAnimations];
    }
}

- (void)changeOpenStatus:(id)sender {
    
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

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    CGRect curFrame = self.view.frame;
    [UIView animateWithDuration:0.3f animations:^{
        self.view.frame=CGRectMake(0, self.navigationController.navigationBar.frame.size.height + [VersionAdapter getMoreVarHead] - self.text_neirong.frame.size.height - 125, curFrame.size.width, curFrame.size.height);
    }];
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
    
    
    UIButton *newBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [newBtn setFrame:CGRectMake(self.view.frame.size.width-60, 0, 60, 30)];
    [newBtn setTitle:@"发布" forState:UIControlStateNormal];
    [newBtn setTitleEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 10)];
    [newBtn addTarget:self action:@selector(tourismCilckAction) forControlEvents:UIControlEventTouchUpInside];
    [newBtn setTintColor:[UIColor lightGrayColor]];
//    [newBtn setBackgroundImage:[UIImage imageNamed:@"save.png"] forState:UIControlStateNormal];
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
