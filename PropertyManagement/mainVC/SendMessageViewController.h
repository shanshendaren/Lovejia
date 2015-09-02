//
//  SendMessageViewController.h
//  PropertyManagement
//
//  Created by admin on 15/3/6.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Barter.h"
#import "Carpooling.h"

@interface SendMessageViewController : UIViewController<UITextViewDelegate>
@property (nonatomic,strong)Barter *valuablesInfo;
@property (nonatomic,strong)Carpooling *car;
@end
