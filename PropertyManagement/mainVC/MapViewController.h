//
//  MapViewController.h
//  PropertyManagement
//
//  Created by admin on 15/1/4.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


@interface MapViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate>
@property(strong,nonatomic)MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end
