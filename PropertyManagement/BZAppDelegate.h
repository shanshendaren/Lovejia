//
//  BZAppDelegate.h
//  PropertyManagement
//
//  Created by iosMac on 14-11-12.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PF_TabBar.h"

#define APP_URL @"http://itunes.apple.com/lookup?id=972527156"

@interface BZAppDelegate : UIResponder <UIApplicationDelegate>{
    NSTimer*timer;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) PF_TabBar *tabBar;

@property(strong,nonatomic)NSString * userName; //用户名字
@property(strong,nonatomic)NSString * userMobile;//用户手机号
@property(strong,nonatomic)NSString * userEmail;//用户邮件
@property(strong,nonatomic)NSString * userID;//用户id
@property(strong,nonatomic)NSString * userSex;//用户性别
@property(strong,nonatomic)NSString * userCardNum;//用户身份证
@property(strong,nonatomic)NSString * userPlace;//用户身份证
@property(strong,nonatomic)NSString * vallageTel;//小区电话号码
@property(strong,nonatomic)NSString * vallageID;//小区ID
@property(strong,nonatomic)NSString * vallageName;//小区名字
@property(strong,nonatomic)NSString * seat;//用户所处楼栋号
@property(strong,nonatomic)NSString * unit;//单元
@property(strong,nonatomic)NSString * house;//房号
@property(strong,nonatomic)NSString * registrationID;//设备id
@property(strong,nonatomic)UIViewController * adView;//广告页面
@property(strong,nonatomic)NSString * affectionTel1;//关联号码
@property(strong,nonatomic)NSString * affectionTel2;//关联号码
@property(strong,nonatomic)NSString * affectionTel3;//关联号码
@property(assign)int  unReadBarterNum;//新的交换物品数
@property(assign)int unReadNeigNum;//邻里拼车未读条数
//app版本号
@property(nonatomic,strong)NSDictionary * infoID;
@property(nonatomic,strong)NSString *currentViason;


//创建登录界面
-(void)bootLoginViewController;

//创建主界面
-(void)bootMainViewController;
//版本更新
-(void)onCheckVersion;

@end
