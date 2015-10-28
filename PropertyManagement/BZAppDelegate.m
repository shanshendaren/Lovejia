//
//  BZAppDelegate.m
//  PropertyManagement
//
//  Created by iosMac on 14-11-12.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "BZAppDelegate.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "BuyViewController.h"
#import "SetViewController.h"
#import "MainViewController.h"
#import "BZStartViewController.h"
#import "HYBJPushHelper.h"
#import "APService.h"
#import "NewsMainViewController.h"
#import "ADViewController.h"
#import "ConvenientServiceViewController.h"
#import "ASIFormDataRequest.h"

#import "IQKeyboardManager.h"
#import "IQSegmentedNextPrevious.h"

@implementation BZAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //全局键盘设置
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setShouldPlayInputClicks:YES];
    [[IQKeyboardManager sharedManager] setCanAdjustTextView:YES];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
    application.statusBarHidden = NO;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [HYBJPushHelper setupWithOptions:launchOptions];
    [self adview];
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)adview{
   ADViewController *startViewController = [[ADViewController alloc]init];
    self.adView = startViewController;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:startViewController];
    navigationController.navigationBarHidden = YES;
    [_window setRootViewController:navigationController];
    timer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector: @selector(logo) userInfo: nil repeats: YES];
}

-(void)logo{
    [self.adView.view removeFromSuperview];
    [timer invalidate];
    [self startApp];
}

-(void)startApp{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *isLooked  = [userDefault objectForKey:@"isLooked"];//从本地存储获取是否看过引导页
    if(![isLooked isEqualToString:@"1"]){//没有看过滑动页,启动滑动页
        [self bootStartViewController];
    }else{//直接启动登录页面
        [self bootLoginViewController];
    }
}
-(void)bootStartViewController{
    BZStartViewController *startViewController = [[BZStartViewController alloc]init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:startViewController];
    navigationController.navigationBarHidden = YES;
    [_window setRootViewController:navigationController];
}

-(void)bootLoginViewController{
    LoginViewController *loginViewController = [[LoginViewController alloc]init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    navigationController.navigationBarHidden = YES;
    [_window setRootViewController:navigationController];
}

#pragma mark-   创建视图控制器
-(void)bootMainViewController{
    BZAppDelegate *app =[UIApplication sharedApplication].delegate;

    MainViewController *first = [[MainViewController alloc] init];
    ConvenientServiceViewController *third = [[ConvenientServiceViewController alloc] init];
    SetViewController *fourth = [[SetViewController alloc] init];
    //视图控制器的数组
    NSArray *array = [[NSArray alloc] initWithObjects:first, third, fourth, nil];

    //创建自定义TabBar
    PF_TabBar *tabBar = [[PF_TabBar alloc] initWithViewControl:array];
    //设置一个属性获取TabBar
    tabBar.newCount = app.unReadBarterNum + app.unReadNeigNum;
    _tabBar = tabBar;
    
    //未被选中的图片的数组
    NSArray *normalBackgroundArray = [[NSArray alloc] initWithObjects:@"tabbar", @"tabbar2", @"tabbar1", nil];

    //被选中的图片的数组
    NSArray *selectedBackgroundArray = [[NSArray alloc] initWithObjects:@"tabbarSel", @"tabbarSel2", @"tabbarSel1", nil];
    
    //TabBar的文字的数组
    NSArray *l = [[NSArray alloc] initWithObjects:@"首页", @"便民服务", @"我的",  nil];
    
    //调用自定义的方法设置TabBar上的视图
    [tabBar tabBarWithBackgroundImage:[UIImage imageNamed:@"menu_bg_02"] andNormalBackgroundArray:normalBackgroundArray andSelectedBackgroundArray:selectedBackgroundArray andTabBarLabelArray:l];
    tabBar.selectedIndex = 0;
    //设置自定义的TabBar为主控制器
    self.window.rootViewController = tabBar;
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [HYBJPushHelper handleRemoteNotification:userInfo completion:nil];
    return;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
// ios7.0以后才有此功能
- (void)application:(UIApplication *)application didReceiveRemoteNotification
                   :(NSDictionary *)userInfo fetchCompletionHandler
                   :(void (^)(UIBackgroundFetchResult))completionHandler {
    [HYBJPushHelper handleRemoteNotification:userInfo completion:completionHandler];
    // 应用正处理前台状态下，不会收到推送消息，因此在此处需要额外处理一下
    if (application.applicationState == UIApplicationStateActive) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"收到推送消息"message:userInfo[@"aps"][@"alert"]  delegate:nil cancelButtonTitle:@"取消"otherButtonTitles:@"确定", nil ];
        [alert show];
    }
    return;
}
#endif

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [HYBJPushHelper showLocalNotificationAtFront:notification];
    return;
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSLog(@"Error in registration. Error: %@", err);
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [APService resetBadge];
    [application setApplicationIconBadgeNumber:0];
    return;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(void)applicationDidFinishLaunching:(UIApplication *)application{
    
}
@end
