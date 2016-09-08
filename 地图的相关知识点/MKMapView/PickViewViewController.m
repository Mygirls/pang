//
//  PickViewViewController.m
//  MKMapView
//
//  Created by administrator on 16/7/4.
//  Copyright © 2016年 com.baiyimao.bai. All rights reserved.
//

#import "PickViewViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "KCAnnotation.h"
#import "KCCalloutAnnotatonView.h"
#import "KCCalloutAnnotatonView.h"

@interface PickViewViewController ()<MKMapViewDelegate>{
    CLLocationManager *_locationManager;
    MKMapView *_mapView;
    
    
}
@property (nonatomic,strong) CLGeocoder *geocoder;

@end

@implementation PickViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self initGUI];
    
    [self _geocoder];
    
}

- (void)_geocoder
{
//面的代码演示了如何在苹果自带地图应用上标记一个位置，首先根据反地理编码获得一个CLPlacemark位置对象，然后将其转换为MKPlacemark对象用于MKMapItem初始化，最后调用其openInMapsWithLaunchOptions:打开地图应用并标记：
    _geocoder=[[CLGeocoder alloc]init];
//    [self location];//单个位置的标注
    
//    [self listPlacemark];//标记多个位置
    
    [self turnByTurn];//地图导航

}
#pragma mark 在地图上定位
//单个位置的标注:下面的代码演示了如何在苹果自带地图应用上标记一个位置，首先根据反地理编码获得一个CLPlacemark位置对象，然后将其转换为MKPlacemark对象用于MKMapItem初始化，最后调用其openInMapsWithLaunchOptions:打开地图应用并标记：
-(void)location{
    //根据“北京市”进行地理编码
    [_geocoder geocodeAddressString:@"北京市" completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *clPlacemark=[placemarks firstObject];//获取第一个地标
        MKPlacemark *mkplacemark=[[MKPlacemark alloc]initWithPlacemark:clPlacemark];//定位地标转化为地图的地标
        NSDictionary *options=@{MKLaunchOptionsMapTypeKey:@(MKMapTypeStandard)};
        MKMapItem *mapItem=[[MKMapItem alloc]initWithPlacemark:mkplacemark];
        [mapItem openInMapsWithLaunchOptions:options];
    }];
}
//标记多个位置:如果要标记多个位置需要调用MKMapItem的静态方法，下面的代码演示中需要注意，使用CLGeocoder进行定位时一次只能定位到一个位置，所以第二个位置定位放到了第一个位置获取成功之后。
-(void)listPlacemark{
    //根据“北京市”进行地理编码
    [_geocoder geocodeAddressString:@"北京市" completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *clPlacemark1=[placemarks firstObject];//获取第一个地标
        MKPlacemark *mkPlacemark1=[[MKPlacemark alloc]initWithPlacemark:clPlacemark1];
        //注意地理编码一次只能定位到一个位置，不能同时定位，所在放到第一个位置定位完成回调函数中再次定位
        [_geocoder geocodeAddressString:@"郑州市" completionHandler:^(NSArray *placemarks, NSError *error) {
            CLPlacemark *clPlacemark2=[placemarks firstObject];//获取第一个地标
            MKPlacemark *mkPlacemark2=[[MKPlacemark alloc]initWithPlacemark:clPlacemark2];
            NSDictionary *options=@{MKLaunchOptionsMapTypeKey:@(MKMapTypeStandard)};
            //MKMapItem *mapItem1=[MKMapItem mapItemForCurrentLocation];//当前位置
            MKMapItem *mapItem1=[[MKMapItem alloc]initWithPlacemark:mkPlacemark1];
            MKMapItem *mapItem2=[[MKMapItem alloc]initWithPlacemark:mkPlacemark2];
            [MKMapItem openMapsWithItems:@[mapItem1,mapItem2] launchOptions:options];
            
        }];
        
    }];
}
//地图导航:要使用地图导航功能在自带地图应用中相当简单，只要设置参数配置导航模式即可，例如在上面代码基础上设置驾驶模式，则地图应用会启动驾驶模式计算两点之间的距离同时对路线进行规划。
-(void)turnByTurn{
    //根据“北京市”地理编码
    [_geocoder geocodeAddressString:@"北京市" completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *clPlacemark1=[placemarks firstObject];//获取第一个地标
        MKPlacemark *mkPlacemark1=[[MKPlacemark alloc]initWithPlacemark:clPlacemark1];
        //注意地理编码一次只能定位到一个位置，不能同时定位，所在放到第一个位置定位完成回调函数中再次定位
        [_geocoder geocodeAddressString:@"郑州市" completionHandler:^(NSArray *placemarks, NSError *error) {
            CLPlacemark *clPlacemark2=[placemarks firstObject];//获取第一个地标
            MKPlacemark *mkPlacemark2=[[MKPlacemark alloc]initWithPlacemark:clPlacemark2];
            NSDictionary *options=@{MKLaunchOptionsMapTypeKey:@(MKMapTypeStandard),MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving};
            //MKMapItem *mapItem1=[MKMapItem mapItemForCurrentLocation];//当前位置
            MKMapItem *mapItem1=[[MKMapItem alloc]initWithPlacemark:mkPlacemark1];
            MKMapItem *mapItem2=[[MKMapItem alloc]initWithPlacemark:mkPlacemark2];
            [MKMapItem openMapsWithItems:@[mapItem1,mapItem2] launchOptions:options];
            
        }];
        
    }];
}



/*
 
注意：其实如果不用苹果自带的地图应用也可以实现地图导航，MapKit中提供了MKDirectionRequest对象用于计算路线，提供了MKDirections用于计算方向，这样一来只需要调用MKMapView的addOverlay等方法添加覆盖物即可实现类似的效果，有兴趣的朋友可以试一下。
 
 由于定位和地图框架中用到了诸多类，有些初学者容易混淆，下面简单对比一下。
 
 CLLocation：用于表示位置信息，包含地理坐标、海拔等信息，包含在CoreLoaction框架中。
 
 MKUserLocation：一个特殊的大头针，表示用户当前位置。
 
 CLPlacemark：定位框架中地标类，封装了详细的地理信息。
 
 MKPlacemark：类似于CLPlacemark，只是它在MapKit框架中，可以根据CLPlacemark创建MKPlacemark。
 */




/*
 
 自定义大头针
 
 */


#pragma mark 添加地图控件
-(void)initGUI{
    CGRect rect=[UIScreen mainScreen].bounds;
    _mapView=[[MKMapView alloc]initWithFrame:rect];
    [self.view addSubview:_mapView];
    //设置代理
    _mapView.delegate=self;
    
    //请求定位服务
    _locationManager=[[CLLocationManager alloc]init];
    if(![CLLocationManager locationServicesEnabled]||[CLLocationManager authorizationStatus]!=kCLAuthorizationStatusAuthorizedWhenInUse){
        [_locationManager requestWhenInUseAuthorization];
    }
    
    //用户位置追踪(用户位置追踪用于标记用户当前位置，此时会调用定位服务)
    _mapView.userTrackingMode=MKUserTrackingModeFollow;
    
    //设置地图类型
    _mapView.mapType=MKMapTypeStandard;
    
    //添加大头针
    [self addAnnotation];
}

#pragma mark 添加大头针
-(void)addAnnotation{
    CLLocationCoordinate2D location1=CLLocationCoordinate2DMake(39.95, 116.35);
    KCAnnotation *annotation1=[[KCAnnotation alloc]init];
    annotation1.title=@"CMJ Studio";
    annotation1.subtitle=@"Kenshin Cui's Studios";
    annotation1.coordinate=location1;
    annotation1.image=[UIImage imageNamed:@"icon_classify_cafe"];
    annotation1.icon=[UIImage imageNamed:@"2.png"];
    annotation1.detail=@"CMJ Studio...";
    annotation1.rate=[UIImage imageNamed:@"icon_Movie_Star_rating"];
    [_mapView addAnnotation:annotation1];
    
    CLLocationCoordinate2D location2=CLLocationCoordinate2DMake(22.55, 114.12);
    KCAnnotation *annotation2=[[KCAnnotation alloc]init];
    annotation2.title=@"Kenshin&Kaoru";
    annotation2.subtitle=@"Kenshin Cui's Home";
    annotation2.coordinate=location2;
    annotation2.image=[UIImage imageNamed:@"icon_classify_cafe"];
    annotation2.icon=[UIImage imageNamed:@"2.png"];
    annotation2.detail=@"Kenshin Cui...";
    annotation2.rate=[UIImage imageNamed:@"icon_Movie_Star_rating"];
    [_mapView addAnnotation:annotation2];
}

#pragma mark - 地图控件代理方法
#pragma mark 显示大头针时调用，注意方法中的annotation参数是即将显示的大头针对象
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    //由于当前位置的标注也是一个大头针，所以此时需要判断，此代理方法返回nil使用默认大头针视图
    if ([annotation isKindOfClass:[KCAnnotation class]]) {
        static NSString *key1=@"AnnotationKey1";
        MKAnnotationView *annotationView=[_mapView dequeueReusableAnnotationViewWithIdentifier:key1];
        //如果缓存池中不存在则新建
        if (!annotationView) {
            annotationView=[[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:key1];
            //            annotationView.canShowCallout=true;//允许交互点击
            annotationView.calloutOffset=CGPointMake(0, 1);//定义详情视图偏移量
            annotationView.leftCalloutAccessoryView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"1"]];//定义详情左侧视图
        }
        
        //修改大头针视图
        //重新设置此类大头针视图的大头针模型(因为有可能是从缓存池中取出来的，位置是放到缓存池时的位置)
        annotationView.annotation=annotation;
        annotationView.image=((KCAnnotation *)annotation).image;//设置大头针视图的图片
        
        return annotationView;
    }else if([annotation isKindOfClass:[KCCalloutAnnotation class]]){
        //对于作为弹出详情视图的自定义大头针视图无弹出交互功能（canShowCallout=false，这是默认值），在其中可以自由添加其他视图（因为它本身继承于UIView）
        KCCalloutAnnotatonView *calloutView=[KCCalloutAnnotatonView calloutViewWithMapView:mapView];
        calloutView.annotation=annotation;
        return calloutView;
    } else {
        return nil;
    }
}

#pragma mark 选中大头针时触发
//点击一般的大头针KCAnnotation时添加一个大头针作为所点大头针的弹出详情视图
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    KCAnnotation *annotation=view.annotation;
    if ([view.annotation isKindOfClass:[KCAnnotation class]]) {
        //点击一个大头针时移除其他弹出详情视图
        //        [self removeCustomAnnotation];
        //添加详情大头针，渲染此大头针视图时将此模型对象赋值给自定义大头针视图完成自动布局
        KCCalloutAnnotation *annotation1=[[KCCalloutAnnotation alloc]init];
        annotation1.icon=annotation.icon;
        annotation1.detail=annotation.detail;
        annotation1.rate=annotation.rate;
        annotation1.coordinate=view.annotation.coordinate;
        [mapView addAnnotation:annotation1];
    }
}

#pragma mark 取消选中时触发
-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    [self removeCustomAnnotation];
}

#pragma mark 移除所用自定义大头针
-(void)removeCustomAnnotation{
    [_mapView.annotations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[KCCalloutAnnotation class]]) {
            [_mapView removeAnnotation:obj];
        }
    }];
}


/*
 在这个过程中需要注意几点：
 
 1.大头针A作为一个普通大头针，其中最好保存自定义大头针视图C所需要的模型以便根据不同的模型初始化视图。
 
 2.自定义大头针视图C的大头针模型B中不需要title、subtitle属性，最好设置为只读；模型中最后保存自定义大头针视图C所需要的布局模型数据。
 
 3.只有点击非B类大头针时才新增自定义大头针，并且增加时要首先移除其他B类大头针避免重叠（一般建议放到取消大头针选择的代理方法中）。
 
 4.通常在自定义大头针视图C设置大头针模型时布局界面，此时需要注意新增大头针的位置，通常需要偏移一定的距离才能达到理想的效果。
 

*/

@end
