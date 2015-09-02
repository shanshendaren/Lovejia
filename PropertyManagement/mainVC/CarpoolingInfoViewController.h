//
//  CarpoolingInfoViewController.h
//  PropertyManagement
//
//  Created by admin on 15/3/11.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Carpooling.h"

@interface CarpoolingInfoViewController : UIViewController
@property(nonatomic,strong)Carpooling *car;
@property(nonatomic,strong)NSString *selfType;

@end
