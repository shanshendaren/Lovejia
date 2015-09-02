//
//  Vallage1ViewController.h
//  PropertyManagement
//
//  Created by mac on 15/7/21.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Vallage1ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property(strong ,nonatomic)NSString *type;
@property(strong ,nonatomic)NSString *orgId;
//小区请求数据
@property(nonatomic,strong)NSString *type1;
@property(nonatomic,strong)NSString *value;

//协议参数
@property(nonatomic,strong)NSString *peotocol2;

@end

