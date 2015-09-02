//
//  ActivityView.h
//  SouthPoleCenter
//
//  Created by Liu Lexi on 13-8-27.
//  Copyright (c) 2013年 Liu Lexi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _ActivityType{
    ActivityTypeNone = 0,
    ActivityTypeLoad = 1,
    ActivityTypeDownload = 2,
    ActivityTypeUpload = 3,
} ActivityType;

@interface ActivityView : UIView
{
    ActivityType type;
}

- (id)initWithFrame:(CGRect)frame loadStr:(NSString *)loadStr;

- (void)startAnimate:(UIViewController *)viewCon;

- (void)stopAcimate;

- (BOOL)isVisible;

- (void)setShowStr:(NSString *)showStr;

- (void)setType:(ActivityType)typeValue;

@end
