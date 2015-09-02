//
//  ValuablesDetailViewController.h
//  PropertyManagement
//
//  Created by iosMac on 15-1-12.
//  Copyright (c) 2015年 iosMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Barter.h"


@interface ValuablesDetailViewController : UIViewController
@property (nonatomic,strong)Barter *valuablesInfo;
@property(nonatomic,strong)NSString *selfType;
@end
