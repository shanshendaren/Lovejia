//
//  UserInfoChangeViewController.m
//  PropertyManagement
//
//  Created by admin on 14/12/17.
//  Copyright (c) 2014年 admin. All rights reserved.
//

#import "UserInfoChangeViewController.h"
#import "VersionAdapter.h"
#import "BZAppDelegate.h"


#import "TableViewWithBlock.h"
#import "SelectionCell.h"
#import <QuartzCore/QuartzCore.h>

@interface UserInfoChangeViewController (){
    UITextField *tf;
    BOOL isOpened;
    int sexType;

}

@property (nonatomic,strong)TableViewWithBlock *tb;
@property (nonatomic,strong)UITextField *text_Biaoti;
@property (nonatomic,strong)UIButton *biaoti_Btn;
@property (nonatomic,strong)NSArray *listTeams;


@end

@implementation UserInfoChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0  blue:238.0/255.0  alpha:1.0]];
    [VersionAdapter setViewLayout:self];
    
    
    if (self.secNum !=3) {
        UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 15, self.view.frame.size.width, 40)];
        [view1 setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:view1];
        
        tf = [[UITextField alloc]initWithFrame:CGRectMake(20, 5, self.view.frame.size.width-40, 30)];
        [view1 addSubview:tf];
    } else{
        self.biaoti_Btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [ self.biaoti_Btn  setFrame:CGRectMake(self.view.frame.size.width/2-30, 25, 60, 30)];
        [ self.biaoti_Btn  setBackgroundImage:[UIImage imageNamed:@"save"] forState:UIControlStateNormal];
        [self.view addSubview: self.biaoti_Btn ];

        
        self.listTeams = [[NSArray alloc] initWithObjects:@"男", @"女", nil];
        self.text_Biaoti = [[UITextField alloc]initWithFrame:CGRectMake(20, 0, 30, 30)];
        [self.text_Biaoti setEnabled:NO];
        self.text_Biaoti.text = [NSString stringWithFormat:@"%@",self.listTeams[0]];
        [self.biaoti_Btn addSubview:self.text_Biaoti];
        
        
        [ self.biaoti_Btn  addTarget:self action:@selector(changeOpenStatus:) forControlEvents:UIControlEventTouchUpInside];
        
        _tb = [[TableViewWithBlock alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-30, 24, 60, 1)];
        [_tb initTableViewDataSourceAndDelegate:^(UITableView *tableView,NSInteger section){
            return 2;
        } setCellForIndexPathBlock:^(UITableView *tableView,NSIndexPath *indexPath){
            SelectionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SelectionCell"];
            if (!cell) {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"SelectionCell" owner:self options:nil]objectAtIndex:0];
                [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
            }
            [cell.lb setText:[NSString stringWithFormat:@"%@",[self.listTeams objectAtIndex:indexPath.row]]];
            cell.backgroundColor = [UIColor whiteColor];
            return cell;
        } setDidSelectRowBlock:^(UITableView *tableView,NSIndexPath *indexPath){
            SelectionCell *cell=(SelectionCell*)[tableView cellForRowAtIndexPath:indexPath];
            self.text_Biaoti.text=cell.lb.text;
            [_biaoti_Btn sendActionsForControlEvents:UIControlEventTouchUpInside];
            sexType = (int)indexPath.row+1;
        }];
        
        [_tb.layer setBorderColor:[UIColor clearColor].CGColor];
        [_tb.layer setBorderWidth:1];
        [self.view addSubview:_tb];
        [self.view bringSubviewToFront:_tb];
    }
    
    if (self.secNum == 0) {
        self.title = @"请输入名字";
    }else if (self.secNum ==1){
         self.title = @"请输入身份证";
    }
    else if (self.secNum ==2){
        self.title = @"请输入邮箱";
    }
    else if (self.secNum ==3){
        self.title = @"请选择性别";
    }
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
    [tf setInputAccessoryView:topView];
    
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
    
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerBtn setFrame:CGRectMake(self.view.frame.size.width-60, 0, 60, 30)];
    [registerBtn setTitle:@"保存" forState:UIControlStateNormal];
    [registerBtn setTitleEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 10)];
    [registerBtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    [registerBtn setTintColor:[UIColor lightGrayColor]];
    [registerBtn setBackgroundImage:[UIImage imageNamed:@"save.png"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:registerBtn];


}


- (void)changeOpenStatus:(id)sender {
    //[self.text_neirong setEditable:NO];
    if (isOpened) {
        [UIView animateWithDuration:0.3 animations:^{
            //            UIImage *closeImage=[UIImage imageNamed:@"dropdown.png"];
            //            [sender setImage:closeImage forState:UIControlStateNormal];
            CGRect frame=_tb.frame;
            frame.size.height=1;
            [_tb setFrame:frame];
            [_tb.layer setBorderColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0  blue:245.0/255.0  alpha:1.0].CGColor];
        } completion:^(BOOL finished){
            isOpened=NO;
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            //            UIImage *openImage=[UIImage imageNamed:@"dropup.png"];
            //            [sender setImage:openImage forState:UIControlStateNormal];
            CGRect frame=_tb.frame;
            frame.size.height=60;
            [_tb setFrame:frame];
            [_tb.layer setBorderColor:[UIColor grayColor].CGColor];
            
        } completion:^(BOOL finished){
            //[self.tap setEnabled:YES];
            isOpened=YES;
        }];
    }
}


-(void)backAction{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


//验证邮箱
- (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//验证身份证
-(BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}


-(void)saveAction{
    
    BZAppDelegate *app = [UIApplication sharedApplication].delegate;
    app.userEmail = @"12321";
    if (self.secNum ==1) {
        if (![self validateEmail:tf.text]){
            [self doAlert:@"请输入正确的身份证号！"];
            [tf becomeFirstResponder];
            return;
        }
    }
    else if (self.secNum == 2){
        if (![self validateEmail:tf.text]){
            [self doAlert:@"请输入正确的邮箱地址！"];
            [tf becomeFirstResponder];
            return;
        }
    }
    
    if (tf.text) {
        NSArray * arr =[[NSArray alloc]initWithObjects:[NSString stringWithFormat:@"%d",self.secNum],tf.text, nil];
        NSDictionary *dictionary = [NSDictionary dictionaryWithObject:arr forKey:@"information"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateUserInfo" object:dictionary];
    }
    
    
    else if (sexType == 1 ||sexType == 2){
        NSArray * arr =[[NSArray alloc]initWithObjects:[NSString stringWithFormat:@"%d",self.secNum],[NSString stringWithFormat:@"%d",sexType], nil];
        NSDictionary *dictionary = [NSDictionary dictionaryWithObject:arr forKey:@"information"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateUserInfo" object:dictionary];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)doAlert:(NSString *)inMessage {
    UIAlertView *alertDialog = [[UIAlertView alloc] initWithTitle:@"提示信息" message:inMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertDialog show];
}



-(void)dismissKeyBoard
{
    [tf resignFirstResponder];
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
