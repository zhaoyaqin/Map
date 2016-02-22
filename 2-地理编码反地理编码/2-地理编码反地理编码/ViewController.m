//
//  ViewController.m
//  2-地理编码反地理编码
//
//  Created by lanou3g on 15-5-30.
//  Copyright (c) 2015年 蓝鸥科技. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
@interface ViewController ()
@property (nonatomic, strong) CLGeocoder *geocoder;
@end

@implementation ViewController

#pragma mark - 懒加载
- (CLGeocoder *)geocoder
{
    if (!_geocoder) {
        self.geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //地理编码
    [self dili];
    
    //反地理编码
    [self fandili];
}

//地理
- (void)dili
{
    //地理编码方法
    
    NSString *straddress = @"北京";
    
    [self.geocoder geocodeAddressString:straddress completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) { // 有错误
            NSLog(@"找不到该地址");
        } else { // 编码成功
            
            // 取出最前面的地址
            CLPlacemark *pm = [placemarks firstObject];
            
            // 取出经纬度
            CGFloat  latitude = pm.location.coordinate.latitude;
            CGFloat longitude =  pm.location.coordinate.longitude;
            
      
            
            //NSLog(@"总共找到%d个地址", placemarks.count);
            
            for (CLPlacemark *pm in placemarks) {
                NSLog(@"-----地址开始----");
                
                NSLog(@"%f %f %@", pm.location.coordinate.latitude, pm.location.coordinate.longitude, pm.name);
                
                //列举
                [pm.addressDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    NSLog(@"%@ %@", key, obj);
                }];
                
                NSLog(@"-----地址结束----");
            }
        }
    }];
}



//反地理
- (void)fandili
{
    //反地理编码
    
    // 1.位置
    CLLocationDegrees latitude = 114.0;
    CLLocationDegrees longitude = 45.0;
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    // 2.反地理编码
    [self.geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) { // 有错误（地址乱输入）
            NSLog(@"找不到该地址");
        } else { // 编码成功
            // 取出最前面的地址
            CLPlacemark *pm = [placemarks firstObject];
            NSLog(@"%@", pm.name);
            // 设置具体地址
            
            NSLog(@"总共找到%ld个地址", (long)placemarks.count);
            
            for (CLPlacemark *pm in placemarks) {
                NSLog(@"-----地址开始----");
                
                NSLog(@"%f %f %@", pm.location.coordinate.latitude, pm.location.coordinate.longitude, pm.name);
                
                [pm.addressDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    NSLog(@"%@ %@", key, obj);
                }];
                
                NSLog(@"-----地址结束----");
            }
        }
    }];
}
@end
