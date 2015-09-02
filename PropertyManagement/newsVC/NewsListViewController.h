//
//  NewsListViewController.h
//  PropertyManagement
//
//  Created by admin on 14/11/19.
//  Copyright (c) 2014年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSString *newsType;
@property(nonatomic,strong)NSString *newsName;


@end
