//
//  VersionAdapter.h
//  SchoolApp
//
//  Created by Liu Lexi on 13-11-4.
//  Copyright (c) 2013年 Lexi & Bella. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VersionAdapter : NSObject

+ (BOOL)aboveiOS7;

/*!
 @method setViewLayout:
 @abstract 判断是否是7.0以上版本，如果是，则进行对应的适配
 @param viewCon 被调整布局的UIViewController
 @result void
 */
+ (void)setViewLayout:(UIViewController *)viewCon;

/*!
 @method getMoreVarHead
 @abstract 获取顶部的多余的的高度，避免显示不完全的问题
 @param nil
 @result CGFloat 一般为20，既为状态栏的高度
 */
+ (CGFloat)getMoreVarHead;

@end
