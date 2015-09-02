//
//  Fix.h
//  PropertyManagement
//
//  Created by admin on 14/11/24.
//  Copyright (c) 2014年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Fix : NSObject


@property(strong,nonatomic)NSString *fixId;
@property(strong,nonatomic)NSString *fixTitle;
@property(strong,nonatomic)NSString *fixMess;
@property(strong,nonatomic)NSString *fixTime;
@property(strong,nonatomic)NSString *fixAcceptRemark;
@property(strong,nonatomic)NSString *fixAcceptMess;
@property(strong,nonatomic)NSString *fixAcceptTime;
@property(strong,nonatomic)NSString *fixFeedback;
@property(strong,nonatomic)NSString *fixFeedbackStatus;
@property(strong,nonatomic)NSString *fixFeedbackDate;
@property(assign,nonatomic)int fix_isAccept;
@property(nonatomic,strong)NSArray *photos;
@end
