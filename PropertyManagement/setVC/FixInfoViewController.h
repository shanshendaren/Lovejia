//
//  FixInfoViewController.h
//  PropertyManagement
//
//  Created by admin on 14/11/24.
//  Copyright (c) 2014年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fix.h"

@interface FixInfoViewController : UIViewController
@property(nonatomic,strong)NSString *fixId;
@property(nonatomic,strong)Fix *fix;

@end
