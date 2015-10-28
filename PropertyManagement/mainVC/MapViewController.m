//
//  MapViewController.m
//  PropertyManagement
//
//  Created by admin on 15/1/4.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "MapViewController.h"
#import "WXAnation.h"
#import "VersionAdapter.h"


@interface MapViewController (){
    NSString * currentLatitude;
    NSString * currentLongitude;
    CLLocationManager *locManager;
    int latitude;

}
@end

@implementation MapViewController

@synthesize mapView,locationManager;


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [locationManager stopUpdatingLocation];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    self.title = @"地图定位";
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:FONT_SIZE],NSFontAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    [self createBack];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    [locationManager requestAlwaysAuthorization];
    [locationManager startUpdatingLocation];
    
    latitude = 0;
//    mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44-[VersionAdapter getMoreVarHead])];
    mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    //是否显示当前设备的位置
    mapView.showsUserLocation = YES;
    mapView.delegate = self;
    //地图的显示类型
    /*
     *MKMapTypeStandard 标准地图
     *MKMapTypeSatellite卫星地图
     *MKMapTypeHybrid   混合地图
     */
    mapView.mapType = MKMapTypeStandard;
    [self.view addSubview:mapView];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currLocation = [locations lastObject];
    if (latitude == 0) {
        latitude = 1;
        CLLocationCoordinate2D coord = {currLocation.coordinate.latitude,currLocation.coordinate.longitude};
        //坐标,这是地图初始化的时候显示的坐标
        //显示的返回，数值越大，范围就越大
        MKCoordinateSpan span = {0.1,0.1};
        MKCoordinateRegion region = {coord,span};
        //地图初始化的时候显示的区域
        [mapView setRegion:region];
        [locationManager stopUpdatingLocation];
    }
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([error code] == kCLErrorDenied)
    {
        //访问被拒绝
        
    }
    if ([error code] == kCLErrorLocationUnknown) {
        //无法获取位置信息
    }
}

-(void)createBack{
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 15, 15);
    backButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:backButton];
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
