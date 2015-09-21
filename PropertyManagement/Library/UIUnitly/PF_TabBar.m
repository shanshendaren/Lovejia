//
//  PF_TabBar.m
//  PF_TabBar
//
//  Created by Adm on 14-3-6.
//  Copyright (c) 2014年 PFei_He. All rights reserved.
//

#import "PF_TabBar.h"
#import "VersionAdapter.h"
#import "JSBadgeView.h"
#import "BZAppDelegate.h"
#import "PhoneNCViewController.h"

//动态获取设备高度
//#define iPhone_Height (([UIScreen mainScreen].bounds.size.height == 568) ? 568 : 480)

#define COLOR(R, G, B, A)  [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

@interface PF_TabBar ()
{
    UIView *tabBarView;
}
//TODO: 自定义tabbarView设置
@property (strong, nonatomic) NSMutableArray *tabBarControlArray;   //自定义TabBarControl的数组
@property (strong, nonatomic) UIImageView *tabBarImageView;         //自定义图片的数组
@property (strong, nonatomic) NSMutableArray *tabBarButtonArray;    //自定义按钮的数组
@property (strong, nonatomic) NSMutableArray *tabBarlabelArray;    //自定义按钮标题的数组

@property (strong, nonatomic)UIView *recView;
@property (strong, nonatomic)JSBadgeView *badgeView;

@end

@implementation PF_TabBar
@synthesize tabBarButtonArray,tabBarlabelArray,recView,badgeView;

#pragma mark - Init TabBar



//初始化视图控制器，并传入视图控制器的Array
- (id)initWithViewControl:(NSArray *)tabBarArray
{
    _tabBarControlArray = [NSMutableArray arrayWithCapacity:3];
    for (UINavigationController *navigationController in tabBarArray) {
        PhoneNCViewController *nav = [[PhoneNCViewController alloc] initWithRootViewController:navigationController];
        [_tabBarControlArray addObject:nav];
      
    }
    self.viewControllers = _tabBarControlArray;
    return self;
}

//初始化TabBar，并传入TabBar的背景，未被选中的图片的Array，选中的图片的Array，文字Array
- (id)tabBarWithBackgroundImage:(UIImage *)backgroundImage andNormalBackgroundArray:(NSArray *)normalBackgroundArray andSelectedBackgroundArray:(NSArray *)selectedBackgroundArray andTabBarLabelArray:(NSArray *)tabBarLabelArray
{

//    self.tabBar.backgroundColor = [UIColor redColor];
    [self tabBarHidden:YES];
        [VersionAdapter setViewLayout:self];
    //TabBar的背景
    if (!_tabBarImageView)
        _tabBarImageView = [[UIImageView alloc] initWithImage:backgroundImage];
    _tabBarImageView.frame = CGRectMake(0, self.view.bounds.size.height - 40,self.view.frame.size.width, 40);
    _tabBarImageView.userInteractionEnabled = YES;
    [self.view addSubview:_tabBarImageView];
    
    //TabBar上Button的Array
    tabBarButtonArray = [[NSMutableArray alloc] initWithCapacity:3];
    tabBarlabelArray = [[NSMutableArray alloc] initWithCapacity:3];

    for (int i = 0; i < [normalBackgroundArray count]; i++)
    {
        //自定义TabBar的按钮
        NSString *normal = [[NSString alloc] initWithFormat:@"%@", [normalBackgroundArray objectAtIndex:i]];
        NSString *selected = [[NSString alloc] initWithFormat:@"%@", [selectedBackgroundArray objectAtIndex:i]];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((i * self.view.frame.size.width/3), 0, self.view.frame.size.width/3, 40);
        [button setImage:[UIImage imageNamed:normal] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:selected] forState:UIControlStateSelected];
        button.tag = i;
        if(i == 0) {
            button.selected = YES;
        }
        [button addTarget:self action:@selector(onSelected:) forControlEvents:UIControlEventTouchUpInside];
        [tabBarButtonArray addObject:button];
        [_tabBarImageView addSubview:button];
    
//        自定义TabBar的文字
        UILabel *tabBarLabel = [[UILabel alloc] initWithFrame:CGRectMake((i * self.view.frame.size.width/3), 27, self.view.frame.size.width/3, 10)];
        tabBarLabel.text = tabBarLabelArray[i];
        tabBarLabel.font = [UIFont systemFontOfSize:8.0f];
        tabBarLabel.textAlignment = 1;
        tabBarLabel.textColor = [UIColor grayColor];
        tabBarLabel.backgroundColor = [UIColor clearColor];
        [tabBarlabelArray addObject:tabBarLabel];
        [_tabBarImageView addSubview:tabBarLabel];
    }
    ((UIButton *)[tabBarButtonArray objectAtIndex:0]).selected = YES;
    ((UILabel *)[tabBarlabelArray objectAtIndex:0]).textColor = COLOR(73, 172, 53, 1.0);
    recView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-75, 10, 50, 1)];
    badgeView = [[JSBadgeView alloc] initWithParentView:recView alignment:JSBadgeViewAlignmentTopRight];
    badgeView.badgeText = [NSString stringWithFormat:@"%d",self.newCount];
    if (self.newCount == 0) {
        [recView setHidden:YES];
    }
    [_tabBarImageView addSubview:recView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTabNewCount:) name:@"updateTabNewCount" object:nil];
    
    


    return self;
}

#pragma mark - TabBar Methods

//获取TabBar选中的Button
- (void)onSelected:(UIButton *)button
{
    self.selectedIndex = button.tag;
    for (int i = 0; i < 3; i++) {
        UIButton *button = [tabBarButtonArray objectAtIndex:i];
        button.selected = NO;
        UILabel *label = [tabBarlabelArray objectAtIndex:i];
        label.textColor = [UIColor grayColor];
    }
    ((UILabel*)[tabBarlabelArray objectAtIndex:button.tag]).textColor = [UIColor colorWithRed:0.090 green:0.688 blue:0.200 alpha:1.000];
    button.selected = YES;
}

//设置系统TabBar的隐藏
- (void)tabBarHidden:(BOOL)tabBarHidden
{
    UIView *tab = self.view;
    if ([tab.subviews count] < 1) {
        return;
    }
    UIView *view;
    if ([[tab.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]]) {
        view = [tab.subviews objectAtIndex:1];
    } else {
      view = [tab.subviews objectAtIndex:0];
    }
    if (tabBarHidden) {
        view.frame = tab.bounds;
    
        self.tabBar.hidden = tabBarHidden;
    } else
        view.frame = CGRectMake(tab.bounds.origin.x, tab.bounds.origin.y, tab.bounds.size.width, tab.bounds.size.height);
}

//设置自定TabBar的隐藏
- (void)customTabBarHidden:(BOOL)customTabBarHidden
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.1];


        if(customTabBarHidden){
        self.tabBarImageView.hidden = YES;
                }
    else{
        self.tabBarImageView.hidden = NO;
    }

    [UIView commitAnimations];
}

#pragma mark - Orientation Management

//TabBar可否跟随设备的翻转而翻转
- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)updateTabNewCount: (NSNotification *) notification{
    
    BZAppDelegate *app = [UIApplication sharedApplication].delegate;
    int currentCount =  app.unReadBarterNum +app.unReadNeigNum;
    if (currentCount > 0) {
         [recView setHidden:NO];
    }else{
         [recView setHidden:YES];
    }
    badgeView.badgeText = [NSString stringWithFormat:@"%d",currentCount];
}

//- (void)setBadgeNumber:(NSInteger)number index:(NSInteger)index{
//    badgeView.badgeText = [NSString stringWithFormat:@"10"];
//}


#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
