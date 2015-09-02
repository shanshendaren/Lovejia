//
//  CallForHelpViewController.m
//  PropertyManagement
//
//  Created by admin on 14/12/31.
//  Copyright (c) 2014年 admin. All rights reserved.
//

#import "CallForHelpViewController.h"
#import "VersionAdapter.h"
#import "RequestUtil.h"
#import "SVProgressHUD.h"
#import "ActivityView.h"
#import "BZAppDelegate.h"


@interface CallForHelpViewController (){
    ActivityView *activity;
    CallForHelpViewController *call;
}

//@property(nonatomic,strong)NSArray *ary;

@end


@implementation CallForHelpViewController

//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    BZAppDelegate* app = (BZAppDelegate *)[UIApplication sharedApplication].delegate;
//    [app.tabBar customTabBarHidden:YES];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [VersionAdapter setViewLayout:self];
    
    [self clickAction];
}


-(void)clickAction{
    BZAppDelegate *app =[UIApplication sharedApplication].delegate;
    
    RequestUtil *requestUtil = [[RequestUtil alloc]init];
    //业务数据参数组织成JSON字符串
    NSString *biz = [NSString  stringWithFormat:@"{\"owner_id\":\"%@\",\"tel\":\"%@\"}",app.userID,app.affectionTel1];
    NSString *sid = @"Sos";
    [requestUtil startRequest:sid biz:biz send:call];
    NSLog(@"发送短信  sid->%@   biz->%@",sid,biz);
    
    NSString *str = [NSString stringWithFormat:@"tel://%@",app.affectionTel1];
    NSURL *myURL = [NSURL URLWithString:str];
    [[UIApplication sharedApplication] openURL:myURL];
    
}
#pragma mark- 发送短信
    //参数phones：发短信的手机号码的数组，数组中是一个即单发,多个即群发。
    //4）调用发短信的方法
    //  [self showMessageView:[NSArray arrayWithObjects:str, nil] title:@"test" body:@"你是土豪么，么么哒"];
    


#pragma mark- 提供程序内部给关联亲属发送短信功能

//-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
//{
//    [self dismissViewControllerAnimated:YES completion:nil];
//    switch (result) {
//        case MessageComposeResultSent:
//            //信息传送成功
//            
//            break;
//        case MessageComposeResultFailed:
//            //信息传送失败
//            
//            break;
//        case MessageComposeResultCancelled:
//            //信息被用户取消传送
//            
//            break;
//        default:
//            break;
//    }
//}

//3）发送短信

//-(void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body
//{
//    if( [MFMessageComposeViewController canSendText] )
//    {
//        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
//        controller.recipients = phones;
//        controller.navigationBar.tintColor = [UIColor redColor];
//        controller.body = body;
//        controller.messageComposeDelegate =self;
//        [self presentViewController:controller animated:YES completion:nil];
//        [[[[controller viewControllers] lastObject] navigationItem] setTitle:title];//修改短信界面标题
//    }
//    else
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
//                                                        message:@"该设备不支持短信功能"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil, nil];
//        [alert show];
//    }
//}
//



//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    BZAppDelegate *app =[UIApplication sharedApplication].delegate;
//    RequestUtil *requestUtil = [[RequestUtil alloc]init];
//    //业务数据参数组织成JSON字符串
//    NSString *biz = [NSString  stringWithFormat:@"{\"mobile\":\"%@\",\"userName\":\"%@\",\"affectionTel1\":\"%@\",\"affectionTel2\":\"%@\",\"affectionTel3\":\"%@\",\"seat\":\"%@\",\"unit\":\"%@\",\"house\":\"%@\"}",app.userMobile,app.userName,app.affectionTel1,app.affectionTel2,app.affectionTel3,app.seat,app.unit,app.house];
//    NSString *sid = @"SendMsgToAffectionTel";
//    [requestUtil startRequest:sid biz:biz send:self];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://15927129727"]]];
//}

#pragma mark- 网络连接，返回数据
-(void)requestStarted:(ASIHTTPRequest *)request{
    if ([activity isVisible] == NO) {
        [activity startAnimate:self];
    }
}

-(void)requestCompleted:(ASIHTTPRequest *)request{
    NSError *error;
  //  获取接口总线返回的结果
    NSString *returnData = [request responseString];
    NSData *jsonData = [returnData dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    if ([json[@"status"]isEqualToString:@"success"]) {
        NSString *str = [json objectForKey:@"status"];
        NSLog(@"status--->%@",str);
    }
    else{
        [SVProgressHUD showErrorWithStatus:json[@"message"]];
    }
//    if ([activity isVisible]) {
//        [activity stopAcimate];
//    }
}

-(void)requestError:(ASIHTTPRequest *)request{
    NSError *error = [request error];
    if ([activity isVisible]) {
        [activity stopAcimate];
    }
    [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
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
