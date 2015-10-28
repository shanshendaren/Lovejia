//
//  ActivityView.m
//  SouthPoleCenter
//
//  Created by Liu Lexi on 13-8-27.
//  Copyright (c) 2013年 Liu Lexi. All rights reserved.
//

#import "ActivityView.h"
#import <QuartzCore/QuartzCore.h>

@interface ActivityView ()
{
    UIActivityIndicatorView *activity;
    UILabel *loadLabel;
}

@end

@implementation ActivityView

- (id)initWithFrame:(CGRect)frame loadStr:(NSString *)loadStr
{
    CGRect avRect = CGRectMake((frame.size.width - 150) / 2, (frame.size.height - 190) / 2, 150, 150);
    self = [super initWithFrame:avRect];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        self.layer.cornerRadius = 12;
        self.layer.masksToBounds = YES;
        self.alpha = 0.75;
        
        activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((self.frame.size.width - 40) / 2, (self.frame.size.height - 80) / 2, 40, 40)];
        activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        activity.hidesWhenStopped = YES;
        [self addSubview:activity];
        
        loadLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height / 2 + 15, self.frame.size.width, 30)];
        loadLabel.textAlignment = NSTextAlignmentCenter;
        loadLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
        loadLabel.textColor = [UIColor blackColor];
        loadLabel.backgroundColor = [UIColor clearColor];
        loadLabel.text = loadStr;
        [self addSubview:loadLabel];
    }
    return self;
}

- (void)startAnimate:(UIViewController *)viewCon
{
    if (self.superview == nil) {
        [viewCon.view addSubview:self];
        [activity startAnimating];
    }
    else {
        NSLog(@"已经被添加，不应该在这里继续调用");
    }
}

- (void)stopAcimate
{
    if (self.superview != nil) {
        [activity stopAnimating];
        [self removeFromSuperview];
    }
}

- (BOOL)isVisible
{
    return self.superview != nil;
}

- (void)setShowStr:(NSString *)showStr
{
    if (loadLabel != nil) {
        loadLabel.text = showStr;
    }
}

- (void)setType:(ActivityType)typeValue
{
    if (typeValue != type) {
        type = typeValue;
        if (type == ActivityTypeLoad) {
            loadLabel.text = [NSString stringWithFormat:@"正在加载..."];
        }
        else if (type == ActivityTypeDownload) {
            loadLabel.text = [NSString stringWithFormat:@"正在下载..."];
        }
        else if (type == ActivityTypeUpload) {
            loadLabel.text = [NSString stringWithFormat:@"正在上传..."];
        }
    }
}

- (void)dealloc
{
    [loadLabel release]; loadLabel = nil;
    [activity release]; activity = nil;
    [super dealloc];
}

@end
