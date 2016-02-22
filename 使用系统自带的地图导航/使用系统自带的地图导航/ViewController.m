//
//  ViewController.m
//  使用系统自带的地图导航
//
//  Created by lanou3g on 15-5-30.
//  Copyright (c) 2015年 蓝鸥科技. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@interface ViewController ()<MKMapViewDelegate>
@property(nonatomic, strong) CLGeocoder *geocoder;

@end

@implementation ViewController

- (CLGeocoder *)geocoder
{
    if (!_geocoder) {
        self.geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    NSString *startStr = @"北京";
    NSString *endStr = @"金华";
    // 2.利用GEO对象进行地理编码获取到地标对象(CLPlacemark )
    // 2.1获取开始位置的地标
    [self.geocoder geocodeAddressString:startStr completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count == 0) return;
        
        // 开始位置的地标
        CLPlacemark *startCLPlacemark = [placemarks firstObject];
        
        
        // 3. 获取结束位置的地标
        [self.geocoder geocodeAddressString:endStr completionHandler:^(NSArray *placemarks, NSError *error) {
            
            if (placemarks.count == 0) return;
            
            // 结束位置的地标
            CLPlacemark *endCLPlacemark = [placemarks firstObject];
            
            // 开始导航
        
            // 开始导航
            [self startNavigationWithstartCLPlacemark:startCLPlacemark endCLPlacemark:endCLPlacemark];
            
        }];
        
    }];
    

    
    
    
    
    
    
}

- (void)startNavigationWithstartCLPlacemark:(CLPlacemark *)startCLPlacemark endCLPlacemark:(CLPlacemark *)endCLPlacemark
{
    
    // 1.创建起点和终点
    // 2.创建起点
    MKPlacemark *startPlacemark = [[MKPlacemark alloc] initWithPlacemark:startCLPlacemark];
    MKMapItem *startItem = [[MKMapItem alloc] initWithPlacemark:startPlacemark];;
    
    // 3.创建终点
    MKPlacemark *endPlacemark = [[MKPlacemark alloc] initWithPlacemark:endCLPlacemark];
    MKMapItem *endItem = [[MKMapItem alloc] initWithPlacemark:endPlacemark];
    
    // 4. 设置起点和终点数组
    NSArray *items = @[startItem, endItem];
    
    // 5.设置启动附加参数
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    // 导航模式(驾车/走路)
    md[MKLaunchOptionsDirectionsModeKey] = MKLaunchOptionsDirectionsModeDriving;
    // 地图显示模式
    //    md[MKLaunchOptionsMapTypeKey] = @(MKMapTypeHybrid);
    
    
    // 只要调用MKMapItem的open方法, 就可以打开系统自带的地图APP进行导航
    // Items: 告诉系统地图APP要从哪到哪
    // launchOptions: 启动系统自带地图APP的附加参数(导航的模式/是否需要先交通状况/地图的模式/..)
    [MKMapItem openMapsWithItems:items launchOptions:md];
}


@end
