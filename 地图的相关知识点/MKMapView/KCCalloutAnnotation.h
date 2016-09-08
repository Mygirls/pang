//
//  KCCalloutAnnotation.h
//  MKMapView
//
//  Created by administrator on 16/7/4.
//  Copyright © 2016年 com.baiyimao.bai. All rights reserved.
//
/*
 
 弹出详情大头针模型：KCCalloutAnnotation.h
 效果图：270849451061009.jpg
 
 */
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface KCCalloutAnnotation : NSObject<MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy,readonly) NSString *title;
@property (nonatomic, copy,readonly) NSString *subtitle;

#pragma mark 左侧图标
@property (nonatomic,strong) UIImage *icon;
#pragma mark 详情描述
@property (nonatomic,copy) NSString *detail;
#pragma mark 星级评价
@property (nonatomic,strong) UIImage *rate;


@end
