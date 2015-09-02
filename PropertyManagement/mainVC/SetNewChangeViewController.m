#import "SetNewChangeViewController.h"
#import "VersionAdapter.h"
#import "CommonUtil.h"
#import "RequestUtil.h"
#import "BZAppDelegate.h"
#import "SVProgressHUD.h"
#import "ActivityView.h"

#import "TableViewWithBlock.h"
#import "SelectionCell.h"
#import <QuartzCore/QuartzCore.h>


@interface SetNewChangeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    UIImageView *iv;
    NSString *picPath;
    ActivityView *activity;
    int changeType;
    CGFloat Y;
    BOOL isOpened;
    
    int mobileType;
}

@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray *photoArray;
@property (nonatomic,strong)UITextField *titleTextField;
@property (nonatomic,strong)UITextView *describeTextField;
@property (nonatomic,strong)UITextView *text_neirong;

@property (nonatomic,strong)UITapGestureRecognizer *tap;//单击手势
@property (nonatomic,strong)UITextField *text_type;
@property (nonatomic,strong)TableViewWithBlock *tb;
@property (nonatomic,strong)UIButton *type_btn;
@property (nonatomic,strong)NSArray *listTeams;

@end

@implementation SetNewChangeViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [VersionAdapter setViewLayout:self];
//    UIView * viewY = [[UIView alloc]initWithFrame:self.view.frame];
//    viewY.backgroundColor =  [UIColor colorWithRed:238.0/255.0 green:238.0/255.0  blue:238.0/255.0  alpha:1.0];
//    [self.view addSubview:viewY];
    
    RequestUtil *request =[[RequestUtil alloc]init];
    NSString * str =@"WPJHLX";
    NSString *biz = [NSString  stringWithFormat:@"{\"type\":\"%@\"}",str];
    NSString *sid = @"Sysdiclist";
    [request startRequest:sid biz:biz send:self];


    
    self.title = @"新建发布";
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    [self createBack];
    
    UIScrollView * sv =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 60-44-[VersionAdapter getMoreVarHead])];
    [sv setUserInteractionEnabled:YES];
    [sv setBackgroundColor:[UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.0]];
    [self.view addSubview:sv];
    
    activity = [[ActivityView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44 - [VersionAdapter getMoreVarHead]) loadStr:NSLocalizedString(@"正在加载...", nil)];
    
//    self.listTeams = [[NSArray alloc]initWithObjects:@"衣物",@"电器",@"家具",@"数码", nil];
    self.photoArray = [[NSMutableArray alloc]initWithObjects:@"null", nil];
    
    mobileType = 0;
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

    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 44)];
    titleLabel.text = @"标题";
    titleLabel.textAlignment = 1;
    titleLabel.backgroundColor = [UIColor whiteColor];
    [back_one addSubview:titleLabel];
    
    UIImageView *lineView = [[UIImageView alloc]initWithFrame:CGRectMake(40, 4, 1, 36)];
    [lineView setImage:[UIImage imageNamed:@"line.png"]];
    [back_one addSubview:lineView];
    
    self.titleTextField = [[UITextField alloc]initWithFrame:CGRectMake(44, 0, self.view.frame.size.width - 44, 44)];
    [self.titleTextField setBackgroundColor:[UIColor whiteColor]];
    self.titleTextField.placeholder = @"请输入";
    [back_one addSubview:self.titleTextField];
    Y = back_one.frame.size.height + back_one.frame.origin.y + 10;
    
    //类型
    UIView *back_two = [[UIView alloc]initWithFrame:CGRectMake(0, Y, self.view.frame.size.width, 44)];
    [back_two setBackgroundColor:[UIColor whiteColor]];
    [sv addSubview:back_two];
    
    UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 44)];
    typeLabel.text = @"类型";
    typeLabel.textAlignment = 1;
    typeLabel.backgroundColor = [UIColor whiteColor];
    [back_two addSubview:typeLabel];
    
    UIImageView *lView = [[UIImageView alloc]initWithFrame:CGRectMake(40, 4, 1, 36)];
    [lView setImage:[UIImage imageNamed:@"line.png"]];
    [back_two addSubview:lView];
    
    _type_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_type_btn setFrame:CGRectMake(44, 2,  self.view.frame.size.width-110, 40)];
    [back_two addSubview:_type_btn];
    
    UIImageView *iv11 =[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-64, 20, 20, 20)];
    [iv11 setImage:[UIImage imageNamed:@"select.png"]];
    [_type_btn addSubview:iv11];

    self.text_type = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 66, 40)];
    [self.text_type setEnabled:NO];
//    self.text_type.text = [NSString stringWithFormat:@"%@",self.listTeams[0]];
    [_type_btn addSubview:self.text_type];
    [_type_btn addTarget:self action:@selector(changeOpenStatus:) forControlEvents:UIControlEventTouchUpInside];
    
    _tb = [[TableViewWithBlock alloc]initWithFrame:CGRectMake(44, Y+44, self.view.frame.size.width - 44, 1)];
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
        changeType = (int)indexPath.row+1;
        [_type_btn sendActionsForControlEvents:UIControlEventTouchUpInside];
    }];
    
    [_tb.layer setBorderColor:[UIColor clearColor].CGColor];
    [_tb.layer setBorderWidth:2];

    Y = back_two.frame.size.height + back_two.frame.origin.y + 10;
    //描述
    UIView *back_three = [[UIView alloc]initWithFrame:CGRectMake(0, Y, self.view.frame.size.width, 160)];
    [back_three setBackgroundColor:[UIColor whiteColor]];
    [sv addSubview:back_three];
    
    UILabel *label_two = [[UILabel alloc]initWithFrame:CGRectMake(0,0, 40, 160)];
    label_two.text = @"描述:";
    label_two.textAlignment = 1;
    [back_three addSubview:label_two];
    
    UIImageView *llView = [[UIImageView alloc]initWithFrame:CGRectMake(40, 4, 1, 152)];
    [llView setImage:[UIImage imageNamed:@"line.png"]];
    [back_three addSubview:llView];
    self.text_neirong = [[UITextView alloc]initWithFrame:CGRectMake(44, 0,self.view.frame.size.width- 44 ,160)];
    self.text_neirong.delegate = self;
    [back_three addSubview:self.text_neirong ];
    
    
    Y = back_three.frame.size.height + back_three.frame.origin.y + 10;
    
    UIView *back_four = [[UIView alloc]initWithFrame:CGRectMake(0, Y, self.view.frame.size.width, 40)];
    [back_four setBackgroundColor:[UIColor whiteColor]];
    [sv addSubview:back_four];

    UISwitch *switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width-60, 5, 50, 30)];
    [switchButton setOn:NO];
    [switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [back_four addSubview:switchButton];

    UILabel *chooseLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width-60, 20)];
    chooseLabel.text = @"请选择是否公开您的电话号码";
    [back_four addSubview:chooseLabel];
    
    [sv addSubview:_tb];

    [sv setContentSize:CGSizeMake(self.view.frame.size.width, Y+40)];

    //发布
    UIImageView *backView = [[UIImageView alloc]init];
//     WithImage:[UIImage imageNamed:@"ip5_03.png"]];
    backView.userInteractionEnabled = YES;
    backView.backgroundColor = [UIColor clearColor];
    backView.frame = CGRectMake(0, self.view.frame.size.height - 60-44-[VersionAdapter getMoreVarHead], self.view.frame.size.width, 60);
    [self.view addSubview:backView];
    
    UIButton * btn1 =[UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setFrame:CGRectMake(60, 10, 200, 40)];
    [btn1 setTitle:@"发布" forState:UIControlStateNormal];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"17"] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(cilckAction) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:btn1];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    [view setBackgroundColor:[UIColor grayColor]];
    UIButton *downBtn = [[UIButton alloc]initWithFrame:CGRectMake(280, 0, 40, 30)];
    [downBtn setTitle:@"完成" forState:UIControlStateNormal];
    [downBtn addTarget:self action:@selector(downKb:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:downBtn];
    [self.titleTextField setInputAccessoryView:view];
    [self.text_neirong setInputAccessoryView:view];
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
    CGRect curFrame = self.view.frame;
    [UIView animateWithDuration:0.3f animations:^{
        self.view.frame=CGRectMake(0, self.navigationController.navigationBar.frame.size.height + [VersionAdapter getMoreVarHead], curFrame.size.width, curFrame.size.height);
    }];
}

-(void)tapGesture:(UITapGestureRecognizer *)tapGestrue
{
    if ([self.view pointInside:[tapGestrue locationInView:self.view] withEvent:0]) {
        [self.text_type resignFirstResponder];
        [self.titleTextField resignFirstResponder];
        CGRect curFrame = self.view.frame;
        [UIView animateWithDuration:0.3f animations:^{
            self.view.frame=CGRectMake(0, self.navigationController.navigationBar.frame.size.height + [VersionAdapter getMoreVarHead], curFrame.size.width, curFrame.size.height);
        }];
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
            frame.size.height=120;
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
    [self.tap setEnabled:YES];
    CGRect curFrame = self.view.frame;
    [UIView animateWithDuration:0.3f animations:^{
        self.view.frame=CGRectMake(0, self.navigationController.navigationBar.frame.size.height + [VersionAdapter getMoreVarHead] - self.text_neirong.frame.size.height - 15, curFrame.size.width, curFrame.size.height);
    }];
}


-(void)cilckAction{
//    if ([self.photoArray count] == 1 ) {
//        UIAlertView *view =[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请添加照片" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [view show];
//        return;
//    }
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
    if ([self.photoArray count] > 6) {
        UIAlertView *view =[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"最多只能上传五张图片" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [view show];
        return;
    }
    BZAppDelegate *app =[UIApplication sharedApplication].delegate;
    RequestUtil *requestUtil = [[RequestUtil alloc]init];
    NSString *biz = [NSString  stringWithFormat:@"{\"userId\":\"%@\",\"title\":\"%@\",\"content\":\"%@\",\"typeId\":\"%i\",\"vallageId\":\"%@\",\"isOpen\":\"%d\"}",app.userID ,self.titleTextField.text,self.text_neirong.text,changeType,app.vallageID,mobileType];
    NSString *sid = @"SaveBarterInfo";
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
