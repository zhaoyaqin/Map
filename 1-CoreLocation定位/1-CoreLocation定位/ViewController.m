//
//  ViewController.m
//  1-CoreLocation定位
//
//  Created by lanou3g on 15-5-30.
//  Copyright (c) 2015年 蓝鸥科技. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
@interface ViewController ()<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locMgr;
@end

@implementation ViewController

#pragma mark 懒加载
- (CLLocationManager *)locMgr
{
#warning 定位服务不可用
    if(![CLLocationManager locationServicesEnabled]) return nil;
    
    if (!_locMgr) {
        // 创建定位管理者
        self.locMgr = [[CLLocationManager alloc] init];
        // 设置代理
        self.locMgr.delegate = self;
    }
    return _locMgr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //判断系统的版本
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
        NSLog(@"ios8.0");
        [self.locMgr requestAlwaysAuthorization];  //请求前台和后台定位
        //        [self.locationManager requestWhenInUseAuthorization]; //请求后台定位
        
        [_locMgr startUpdatingLocation];
    } else {
        NSLog(@"ios 7");
        //开始监听（开始获取位置）
        [self.locMgr startUpdatingLocation];
    }
    //    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
    //        [_locationManager requestAlwaysAuthorization];
    //
    //    } else  {
    
    
    // 设置多久获取一次
    //    self.mgr.distanceFilter = 500;
    
    // 设置获取位置的精确度
    /*
     kCLLocationAccuracyBestForNavigation 最佳导航
     kCLLocationAccuracyBest;  最精准
     kCLLocationAccuracyNearestTenMeters;  10米
     kCLLocationAccuracyHundredMeters;  百米
     kCLLocationAccuracyKilometer;  千米
     kCLLocationAccuracyThreeKilometers;  3千米
     */
    //    self.mgr.desiredAccuracy = kCLLocationAccuracyNe arestTenMeters;
    
    
    /*
     注意: iOS7只要开始定位, 系统就会自动要求用户对你的应用程序授权. 但是从iOS8开始, 想要定位必须先"自己""主动"要求用户授权
     在iOS8中不仅仅要主动请求授权, 而且必须再info.plist文件中配置一项属性才能弹出授权窗口
     NSLocationWhenInUseDescription，允许在前台获取GPS的描述
     NSLocationAlwaysUsageDescription，允许在后台获取GPS的描述
     */
    
    //        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //        _locationManager.distanceFilter = 100.0f;
    //
    //        [_locationManager startUpdatingLocation];
    //        [self.activity startAnimating];
    
    //        NSLog(@"start");
    //
    //    }
    

    // 开始定位用户的位置
    [self.locMgr startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate
/**
 *  只要定位到用户的位置，就会调用（调用频率特别高）
 *  @param locations : 装着CLLocation对象
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // 1.取出位置对象
    CLLocation *loc = [locations firstObject];
    
    // 2.取出经纬度
    CLLocationCoordinate2D coordinate = loc.coordinate;
    
    // 3.打印经纬度
    NSLog(@"didUpdateLocations------%f %f", coordinate.latitude, coordinate.longitude);
    
    // 停止定位(省电措施：只要不想用定位服务，就马上停止定位服务)
    [manager stopUpdatingLocation];
}


/**
 *  计算2个经纬度之间的直线距离
 */
- (void)countLineDistance
{
    // 计算2个经纬度之间的直线距离
    CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:40 longitude:116];
    CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:41 longitude:116];
    CLLocationDistance distance = [loc1 distanceFromLocation:loc2];
    NSLog(@"%f", distance);
}


@end
