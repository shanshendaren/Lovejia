//
//  WebsViewController.h
//  PropertyManagement
//
//  Created by mac on 15/8/17.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebsViewController : UIViewController<UIWebViewDelegate>
{
    IBOutlet UIWebView *webView;
    UIActivityIndicatorView *activityIndicatorView;
    UIView *opaqueView;
}
@end
