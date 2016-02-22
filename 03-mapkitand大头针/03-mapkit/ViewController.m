//
//  ViewController.m
//  03-mapkit
//
//  Created by lanou3g on 15-5-30.
//  Copyright (c) 2015年 蓝鸥科技. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "MyAnimaotion.h"
#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)
@interface ViewController ()<MKMapViewDelegate>

@property (strong, nonatomic) MKMapView *mapView;

@end

@implementation ViewController


- (MKMapView *)mapView
{
    if (!_mapView) {
        self.mapView = [[MKMapView alloc] init];
        _mapView.delegate = self;
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
    
    
    // 4.监听mapView的点击事件，在地图上添加大头针
    [self.mapView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMapView:)]];
    
   
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
    MyAnimaotion *anno = [[MyAnimaotion alloc] init];
    
    //4.设置大头针的经纬度，标题
    anno.coordinate = coordinate;
    
    anno.title = @"111111111";
    anno.subtitle = @"222222222222222";
    
    //5.插入
    [self.mapView addAnnotation:anno];
    
}

#pragma mark - 添加大头针时系统回调方法

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    // 获得地图标注对象
    MKPinAnnotationView * annotationView = (MKPinAnnotationView *)[_mapView dequeueReusableAnnotationViewWithIdentifier:@"identifier"];
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"identifier"];
    }
    // 设置大头针标注视图为紫色
    annotationView.pinColor = MKPinAnnotationColorPurple ;
    // 标注地图时 是否以动画的效果形式显示在地图上
    annotationView.animatesDrop = YES ;
    // 用于标注点上的一些附加信息
    annotationView.canShowCallout = YES ;
    
    return annotationView;
}




#pragma mark - MKMapViewDelegate
/**
 *  当用户的位置更新，就会调用（不断地监控用户的位置，调用频率特别高）
 *
 *  @param userLocation 表示地图上蓝色那颗大头针的数据
 */
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    userLocation.title = @"北京";
    userLocation.subtitle = @"北京是个非常牛逼的地方！";
    
    CLLocationCoordinate2D center = userLocation.location.coordinate;
    NSLog(@"%f %f", center.latitude, center.longitude);
    
    // 设置地图的中心点（以用户所在的位置为中心点）
    [mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    
    // 设置地图的缩放范围
    MKCoordinateSpan span = MKCoordinateSpanMake(0.5, 0.5);
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    [mapView setRegion:region animated:YES];
    
    
}


@end
