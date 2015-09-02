//
//  BrowseViewController.h
//  PropertyManagement
//
//  Created by iosMac on 15-1-16.
//  Copyright (c) 2015年 iosMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrowseViewController : UIViewController
@property (nonatomic,strong)NSArray *photoArray;
@property ()NSInteger page;

-(void)viewWillAppear:(BOOL)animated;
@end
