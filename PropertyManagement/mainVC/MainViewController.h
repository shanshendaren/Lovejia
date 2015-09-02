//
//  MainViewController.h
//  PropertyManagement
//
//  Created by admin on 14/11/13.
//  Copyright (c) 2014年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFAutomaticScrollView.h"
#import "PayForViewController.h"

@interface MainViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,PFAutomaticScrollViewDelegate>

@end
