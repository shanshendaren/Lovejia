//
//  ComplainInfoViewController.h
//  PropertyManagement
//
//  Created by admin on 14/11/22.
//  Copyright (c) 2014年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Complain.h"


@interface ComplainInfoViewController : UIViewController
@property(nonatomic,strong)NSString *comId;
@property(nonatomic ,strong)Complain *complain;
@end
