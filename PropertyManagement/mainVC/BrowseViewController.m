//
//  BrowseViewController.m
//  PropertyManagement
//
//  Created by iosMac on 15-1-16.
//  Copyright (c) 2015年 iosMac. All rights reserved.
//

#import "BrowseViewController.h"
#import "VersionAdapter.h"
#import "UIImageView+WebCache.h"

#import "MRZoomScrollView.h"

@interface BrowseViewController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    CGFloat _lastScale;
}
@property (nonatomic,strong)UIPageControl *pageControl;
@property (strong, nonatomic)UIScrollView *scrollView;
@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic, retain)MRZoomScrollView  *zoomScrollView;
@end

@implementation BrowseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [VersionAdapter setViewLayout:self];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    // tapGesture.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height+[VersionAdapter getMoreVarHead])];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.userInteractionEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width * self.photoArray.count, self.view.frame.size.height+[VersionAdapter getMoreVarHead]);
    [_scrollView setContentOffset:CGPointMake(self.view.frame.size.width*self.page, 0)];
    for (int i = 0; i<self.photoArray.count; i++) {
        
        _zoomScrollView = [[MRZoomScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height+[VersionAdapter getMoreVarHead])];
        CGRect frame = self.scrollView.frame;
        frame.origin.x = frame.size.width * i;
        frame.origin.y = 0;
        _zoomScrollView.frame = frame;
        [_zoomScrollView.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.photoArray[i][@"path"]]] placeholderImage:nil];
       // SDWebImageDownloader *d = [[SDWebImageDownloader alloc]init];
        [self.scrollView addSubview:_zoomScrollView];
    }
    // 添加PageControl
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.center = CGPointMake(320 * 0.5, 480 - 10);
    pageControl.bounds = CGRectMake(0, 0, 150, 50);
    pageControl.numberOfPages = self.photoArray.count; // 一共显示多少个圆点（多少页）
    // 设置非选中页的圆点颜色
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    // 设置选中页的圆点颜色
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    // 禁止默认的点击功能
    pageControl.enabled = NO;
    pageControl.currentPage = self.page;
    [self.view addSubview:pageControl];
    _pageControl = pageControl;
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)tapGesture:(UITapGestureRecognizer *)tapGestrue
{
    if ([self.view pointInside:[tapGestrue locationInView:self.view] withEvent:0])
    {
        [self backAction];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    // 设置页码
    _pageControl.currentPage = page;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
