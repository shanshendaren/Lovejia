//
//  BZStartViewController.h
//  BlueFence
//
//  Created by iosMac on 14-8-28.
//  Copyright (c) 2014年 iosMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EAIntroView.h"

@interface BZStartViewController : UIViewController<EAIntroDelegate>
@property(strong,nonatomic) NSString *buttonTitle;

@end
