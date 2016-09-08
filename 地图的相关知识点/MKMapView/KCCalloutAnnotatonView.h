//
//  KCCalloutAnnotatonView.h
//  MKMapView
//
//  Created by administrator on 16/7/4.
//  Copyright © 2016年 com.baiyimao.bai. All rights reserved.
//
/*
 
 弹出详情大头针视图：KCCalloutAnnotatonView.h
 
 效果图：270849451061009.jpg
 
 */
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "KCCalloutAnnotation.h"

@interface KCCalloutAnnotatonView : MKAnnotationView

@property (nonatomic ,strong) KCCalloutAnnotation *annotation;

#pragma mark 从缓存取出标注视图
+(instancetype)calloutViewWithMapView:(MKMapView *)mapView;

@end
