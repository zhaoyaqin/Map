//
//  ViewController.m
//  mapView
//
//  Created by lanou3g on 15-5-28.
//  Copyright (c) 2015年 蓝鸥科技. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MyAnnotation.h"
#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)
@interface ViewController ()<MKMapViewDelegate>

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) CLGeocoder *geocoder;
@end

@implementation ViewController

- (CLGeocoder *)geocoder
{
    if (!_geocoder) {
        self.geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

- (MKMapView *)mapView
{
    if (_mapView == nil) {
        _mapView = [MKMapView new];
    }
    return _mapView;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.mapView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [self.view addSubview:self.mapView];
    
    // 1.跟踪用户位置(显示用户的具体位置)
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    
    // 2.设置地图类型
    self.mapView.mapType = MKMapTypeStandard;
    
    // 3.设置代理
    self.mapView.delegate = self;
    
    // 4.监听mapView的点击事件
    [self.mapView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMapView:)]];
    
    //导航
    
    NSString *address1 = @"北京";
    NSString *address2 = @"杭州";
    
    [self.geocoder geocodeAddressString:address1 completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) return;
        
        CLPlacemark *fromPm = [placemarks firstObject];
        
        [self.geocoder geocodeAddressString:address2 completionHandler:^(NSArray *placemarks, NSError *error) {
            if (error) return;
            
            CLPlacemark *toPm = [placemarks firstObject];
            
            [self addLineFrom:fromPm to:toPm];
        }];
    }];
    
    
    

    
    
}


/**
 *  监听mapView的点击
 */
- (void)tapMapView:(UITapGestureRecognizer *)tap
{
    // 1.获得用户在mapView点击的位置（x，y）
    CGPoint point = [tap locationInView:tap.view];
    
    // 2.将数学坐标 转为 地理经纬度坐标
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
    
    // 3.创建大头针模型，添加大头针到地图上
    MyAnnotation *anno = [[MyAnnotation alloc] init];
    
    //4.设置大头针的经纬度，标题
    anno.coordinate = coordinate;
    
    anno.title = @"111111111";
    anno.subtitle = @"222222222222222";
    
    //5.插入
    [self.mapView addAnnotation:anno];
    
}
#pragma mark - MKMapViewDelegate
/**
 *  当用户的位置更新，就会调用（不断地监控用户的位置，调用频率特别高）
 *
 *  @param userLocation 表示地图上蓝色那颗大头针的数据
 */
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    userLocation.title = @"北京帝都";
    userLocation.subtitle = @"北京帝都是个非常牛逼的地方！";
    
    CLLocationCoordinate2D center = userLocation.location.coordinate;
    NSLog(@"%f %f", center.latitude, center.longitude);
    
    // 设置地图的中心点（以用户所在的位置为中心点）
        [mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    
    // 设置地图的缩放范围
    MKCoordinateSpan span = MKCoordinateSpanMake(0.021321, 0.019366);
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    [mapView setRegion:region animated:YES];
}



/**
 *  添加导航的线路
 *
 *  @param fromPm 起始位置
 *  @param toPm   结束位置
 */
- (void)addLineFrom:(CLPlacemark *)fromPm to:(CLPlacemark *)toPm
{
    // 1.添加2个大头针
    MyAnnotation *fromAnno = [[MyAnnotation alloc] init];
    fromAnno.coordinate = fromPm.location.coordinate;
    fromAnno.title = fromPm.name;
    [self.mapView addAnnotation:fromAnno];
    
    MyAnnotation *toAnno = [[MyAnnotation alloc] init];
    toAnno.coordinate = toPm.location.coordinate;
    toAnno.title = toPm.name;
    [self.mapView addAnnotation:toAnno];
    
    // 2.查找路线
    
    // 方向请求
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    // 设置起点
    MKPlacemark *sourcePm = [[MKPlacemark alloc] initWithPlacemark:fromPm];
    request.source = [[MKMapItem alloc] initWithPlacemark:sourcePm];
    
    // 设置终点
    MKPlacemark *destinationPm = [[MKPlacemark alloc] initWithPlacemark:toPm];
    request.destination = [[MKMapItem alloc] initWithPlacemark:destinationPm];
    
    // 方向对象
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    
    // 计算路线
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        NSLog(@"总共%ld条路线", response.routes.count);
        
        // 遍历所有的路线
        for (MKRoute *route in response.routes) {
            // 添加路线遮盖
            [self.mapView addOverlay:route.polyline];
        }
    }];
}



#pragma mark - MKMapViewDelegate
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor redColor];
    return renderer;
}


@end
