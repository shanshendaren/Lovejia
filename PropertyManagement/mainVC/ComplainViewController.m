//
//  ComplainViewController.m
//  PropertyManagement
//
//  Created by admin on 14/11/21.
//  Copyright (c) 2014年 admin. All rights reserved.
//

#import "ComplainViewController.h"
#import "BZAppDelegate.h"
#import "RequestUtil.h"
#import "ActivityView.h"
#import "SVProgressHUD.h"
#import "VersionAdapter.h"
#import "CommonUtil.h"
#import "TableViewWithBlock.h"
#import "SelectionCell.h"
#import <QuartzCore/QuartzCore.h>


@interface ComplainViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>{
    BOOL isOpened;
    int complainType;
    UITextField *complainTitle;
    UITextView * contentView;
    UITextField * time;
    ActivityView *activity;
    CGFloat Y;
    NSString *picPath;
}

@property (nonatomic,strong)TableViewWithBlock *tb;
@property (nonatomic,strong)UITextField *text_Biaoti;
@property (nonatomic,strong)UIButton *biaoti_Btn;
@property (nonatomic,strong)NSArray *listTeams;

@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray *photoArray;


@end

@implementation ComplainViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    BZAppDelegate* app = (BZAppDelegate *)[UIApplication sharedApplication].delegate;
    [app.tabBar customTabBarHidden:YES];
    [self.collectionView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    RequestUtil *request =[[RequestUtil alloc]init];
//    BZAppDelegate* app = (BZAppDelegate *)[UIApplication sharedApplication].delegate;
    NSString * str =nil;
    if (self.selfType ==1){
        str = @"MMTL";
    }else{
        str = @"TSLB";
    }
    
    NSString *biz = [NSString  stringWithFormat:@"{\"type\":\"%@\"}",str];
    NSString *sid = @"Sysdiclist";
    [request startRequest:sid biz:biz send:self];
    [self createUI];
    // Do any additional setup after loading the view.
}


-(void)createUI{
    [VersionAdapter setViewLayout:self];
//    UIView * viewY = [[UIView alloc]initWithFrame:self.view.frame];
//    viewY.backgroundColor =  [UIColor colorWithRed:238.0/255.0 green:238.0/255.0  blue:238.0/255.0  alpha:1.0];
//    [self.view addSubview:viewY];
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    self.title = @"投诉信息";
//    if (self.selfType ==1) {
//        complainType =1;
//        self.listTeams = [[NSArray alloc] initWithObjects:@"服务质量", @"乱收费", @"配套设施", @"安全隐患", @"卫生环境",@"小区绿化",@"小区装修噪音",@"其他",nil];
//    }else{
//        complainType =9;
//        self.listTeams = [[NSArray alloc] initWithObjects:@"周边生活设施", @"周边道路", @"周边环境卫生污染", @"周边网络信号", @"周边胶囊房及违建",@"其他",nil];
//    }
    self.photoArray = [[NSMutableArray alloc]initWithObjects:@"null", nil];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [flowLayout setItemSize:CGSizeMake(60, 60)];
    flowLayout.minimumLineSpacing = 5.0;
    [flowLayout setSectionInset:UIEdgeInsetsMake(10, 10, 10, 10)];
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80) collectionViewLayout:flowLayout];
    UIView *vi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.collectionView.frame.size.height)];
    
    [vi setBackgroundColor:[UIColor whiteColor]];
    [self.collectionView setBackgroundView:vi];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CollectionCell"];
    [self.view addSubview:self.collectionView];
    
    Y = self.collectionView.frame.size.height + self.collectionView.frame.origin.y+5;
    
    
    UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, Y, self.view.frame.size.width, 40)];
    [view1 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view1];
    
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(105, 10, 1, 20)];
    [line1 setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0  blue:238.0/255.0  alpha:1.0]];
    [view1 addSubview:line1];
    
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 80, 40)];
    titleLabel.text = @"投诉标题";
    [titleLabel setFont:[UIFont fontWithName:@"Arial" size:18]];
//    [titleLabel setTextColor:[UIColor colorWithRed:158.0/255.0 green:219.0/255.0 blue:0.0/255.0 alpha:1]];
    [view1 addSubview:titleLabel];
    
    complainTitle =[[UITextField alloc]initWithFrame:CGRectMake(110, 0, self.view.frame.size.width-110, 40)];
    [view1 addSubview:complainTitle];
    
    Y = view1.frame.origin.y +view1.frame.size.height+5;
    
    
    UIView * view2 = [[UIView alloc]initWithFrame:CGRectMake(0, Y, self.view.frame.size.width, 40)];
    [view2 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view2];
    
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(105, 10, 1, 20)];
    [line2 setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0  blue:238.0/255.0  alpha:1.0]];
    [view2 addSubview:line2];
    
    UILabel *complainLabel =[[UILabel alloc]initWithFrame:CGRectMake(20, 0, 80, 40)];
    complainLabel.text = @"投诉类型";
    [complainLabel setFont:[UIFont fontWithName:@"Arial" size:18]];
//    [complainLabel setTextColor:[UIColor colorWithRed:158.0/255.0 green:219.0/255.0 blue:0.0/255.0 alpha:1]];
    [view2 addSubview:complainLabel];
    
    
    self.biaoti_Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [ self.biaoti_Btn  setFrame:CGRectMake(110, 0,  self.view.frame.size.width-110, 40)];
    [ self.biaoti_Btn  addTarget:self action:@selector(changeOpenStatus:) forControlEvents:UIControlEventTouchUpInside];
//    [self.biaoti_Btn setTitle:@"请选择类型" forState:UIControlStateNormal];
    [view2 addSubview: self.biaoti_Btn ];
    
    Y = view2.frame.origin.y +view2.frame.size.height+5;
    
    
    
    _tb = [[TableViewWithBlock alloc]initWithFrame:CGRectMake(110, Y, self.view.frame.size.width-140, 1)];
    [_tb initTableViewDataSourceAndDelegate:^(UITableView *tableView,NSInteger section){
//        int a ;
//        if (self.selfType == 1) {
//            a = 8;
//        }else{
//            a = 6;
//        }
        return (int)self.listTeams.count;
    } setCellForIndexPathBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
        if (!cell) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"SelectionCell" owner:self options:nil]objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        }
        NSString * str = [[self.listTeams objectAtIndex:indexPath.row]objectForKey:@"chname"];
        [cell.lb setText:[NSString stringWithFormat:@"%@",str]];
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    } setDidSelectRowBlock:^(UITableView *tableView,NSIndexPath *indexPath){
        SelectionCell *cell=(SelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
      
            self.text_Biaoti.text=cell.lb.text;
            [_biaoti_Btn sendActionsForControlEvents:UIControlEventTouchUpInside];
        
        if (self.selfType ==1) {
            complainType = (int)indexPath.row+1;
        }else{
            complainType = (int)indexPath.row+9;
        }
    }];
    [_tb.layer setBorderColor:[UIColor clearColor].CGColor];
    [_tb.layer setBorderWidth:1];
    
    UIView * view3 = [[UIView alloc]initWithFrame:CGRectMake(0, Y, self.view.frame.size.width, 200)];
    [view3 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view3];
    
    UILabel *infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 80, 80, 40)];
    infoLabel.text = @"投诉内容";
    [infoLabel setFont:[UIFont fontWithName:@"Arial" size:18]];
//    [infoLabel setTextColor:[UIColor colorWithRed:158.0/255.0 green:219.0/255.0 blue:0.0/255.0 alpha:1]];
    [view3 addSubview:infoLabel];
    
    UIView * line3 = [[UIView alloc]initWithFrame:CGRectMake(105, 10, 1, 180)];
    [line3 setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0  blue:238.0/255.0  alpha:1.0]];
    [view3 addSubview:line3];
    
    contentView= [[UITextView  alloc] initWithFrame:CGRectMake(110, 0, self.view.frame.size.width-110, 200)] ; //初始化大小
    contentView.tag = 2;
    [contentView setBackgroundColor:[UIColor clearColor]];
    contentView.font = [UIFont fontWithName:@"Arial" size:14.0];//设置字体名字和字体大小
    contentView.delegate = self;//设置它的委托方法
    contentView.returnKeyType = UIReturnKeyDefault;//返回键的类型
    contentView.keyboardType = UIKeyboardTypeDefault;//键盘类型
    [contentView setEditable:YES];
    contentView.scrollEnabled = YES;//是否可以拖动
    contentView.textColor = [UIColor blackColor];
    [view3 addSubview: contentView];
    
    
    Y = view3.frame.origin.y +view3.frame.size.height+5;
    
    [self.view addSubview:_tb];
    
    UIImageView *iv =[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-130, 20, 20, 20)];
    [iv setImage:[UIImage imageNamed:@"select.png"]];
    [self.biaoti_Btn addSubview:iv];
    
    self.text_Biaoti = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-110, 40)];
    [self.text_Biaoti setEnabled:NO];
//    self.text_Biaoti.text = [NSString stringWithFormat:@"%@",self.listTeams[0]];
    [self.biaoti_Btn addSubview:self.text_Biaoti];
    
    
    [self.view bringSubviewToFront:_tb];
    
    
    UIButton *comBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    comBtn.tag = 1;
    [comBtn setFrame:CGRectMake(10, self.view.frame.size.height-140, self.view.frame.size.width-20, 40)];
    [comBtn setBackgroundImage:[UIImage imageNamed:@"17"] forState:UIControlStateNormal];
    [comBtn setTitle:@"提交" forState:UIControlStateNormal];
    [comBtn addTarget:self action:@selector(cilick) forControlEvents:UIControlEventTouchUpInside];
//    [comBtn setBackgroundColor:[UIColor yellowColor]];
    [self.view addSubview:comBtn];
    
    
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    [topView setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(2, 5, 50, 25);
    [btn addTarget:self action:@selector(dismissKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"退出" forState:UIControlStateNormal];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneBtn,nil];
    [topView setItems:buttonsArray];
    [contentView setInputAccessoryView:topView];
    [complainTitle setInputAccessoryView:topView];
    
    activity = [[ActivityView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44 - [VersionAdapter getMoreVarHead]) loadStr:NSLocalizedString(@"正在加载...", nil)];
    [self createBack];
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
    [self dismissViewControllerAnimated:NO completion:^{
    }];
//    [self.navigationController popViewControllerAnimated:NO];
}



-(void)cilick{
    BZAppDelegate *app =[UIApplication sharedApplication].delegate;
    RequestUtil *requestUtil = [[RequestUtil alloc]init];
    if (complainTitle.text.length == 0) {
        [self doAlert:@"请输入标题"];
        [complainTitle becomeFirstResponder];
        return;
    }
    else if (contentView.text.length == 0){
        [self doAlert:@"请输入标题"];
        [contentView becomeFirstResponder];
        return;
    }
    else if (complainTitle.text.length > 25){
        [self doAlert:@"标题过长"];
        [complainTitle becomeFirstResponder];
        return;
    }
    else if (contentView.text.length > 250){
        [self doAlert:@"内容过长"];
        [contentView becomeFirstResponder];
        return;
    }
    
    if ([self.photoArray count] > 6) {
        UIAlertView *view =[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"最多只能上传五张图片" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [view show];
        return;
    }
    //业务数据参数组织成JSON字符串
    NSString *biz = [NSString  stringWithFormat:@"{\"userId\":\"%@\",\"title\":\"%@\",\"content\":\"%@\",\"complaintTypeId\":\"%d\",\"typeCode\":\"%d\"}",app.userID,complainTitle.text ,contentView.text,complainType,self.selfType];
    NSString *sid = @"DoComplaint";
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
            NSLog(@"%@",self.listTeams);
            [_tb reloadData];
        }else{
        [SVProgressHUD showSuccessWithStatus:json[@"message"]];
        [self dismissViewControllerAnimated:NO completion:^{
        }];
        }
    }else{
        [SVProgressHUD showErrorWithStatus:json[@"message"]];
    }
}

-(void)doAlert:(NSString *)inMessage {
    UIAlertView *alertDialog = [[UIAlertView alloc] initWithTitle:@"提示信息" message:inMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertDialog show];
}

-(void)requestError:(ASIHTTPRequest *)request{
    NSError *error = [request error];
    if ([activity isVisible]) {
        [activity stopAcimate];
    }
    [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    [self animateTextField: textView up: YES];
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    [self animateTextField: textView up: NO];
}

- (void) animateTextField: (UITextView*)textView up:(BOOL) up
{
    const int movementDistance = 100; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    int movement = (up ? -movementDistance : movementDistance);
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}


-(void)dismissKeyBoard
{
    [contentView resignFirstResponder];
    [complainTitle resignFirstResponder];
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
            frame.size.height=120;
            [_tb setFrame:frame];
            [_tb.layer setBorderColor:[UIColor grayColor].CGColor];
            
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
        [backImage setImage:[UIImage imageNamed:@"photo-ad"]];
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
