//
//  VallegeViewController.h
//  PropertyManagement
//
//  Created by admin on 15/1/28.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VallegeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(strong ,nonatomic)NSString *type;
@property(strong ,nonatomic)NSString *orgId;
////小区请求数据
//@property(nonatomic,strong)NSString *type1;
//@property(nonatomic,strong)NSString *value;

@end
