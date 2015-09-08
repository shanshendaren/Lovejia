//
//  SFSafeCommunityViewController.h
//  PropertyManagement
//
//  Created by mac on 15/9/2.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFSafeCommunityViewController : UIViewController<UIWebViewDelegate>
{
    IBOutlet UIWebView *webView;
    UIActivityIndicatorView *activityIndicatorView;
    UIView *opaqueView;
}
@end
