//
//  PF_TabBar.h
//  PF_TabBar
//
//  Created by Adm on 14-3-6.
//  Copyright (c) 2014年 PFei_He. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PF_TabBar : UITabBarController


@property (assign)int newCount;


/**
 *  @brief  初始化视图控制器，并传入视图控制器的Array
 */
- (id)initWithViewControl:(NSArray *)tabBarArray;

/**
 *  @brief  初始化TabBar，并传入TabBar的背景，未被选中的图片的Array，选中的图片的Array，文字Array
 */
- (id)tabBarWithBackgroundImage:(UIImage *)backgroundImage
       andNormalBackgroundArray:(NSArray *)normalBackgroundArray
     andSelectedBackgroundArray:(NSArray *)selectedBackgroundArray
            andTabBarLabelArray:(NSArray *)tabBarLabelArray;

/**
 *  @brief  获取TabBar选中的Button
 */
- (void)onSelected:(UIButton *)button;

/**
 *  @brief  隐藏系统TabBar
 */
- (void)tabBarHidden:(BOOL)tabBarHidden;

/**
 *  @brief  隐藏自定义TabBar
 */
- (void)customTabBarHidden:(BOOL)customTabBarHidden;

@end
