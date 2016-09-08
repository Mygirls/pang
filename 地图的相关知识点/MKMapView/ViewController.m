//
//  ViewController.m
//  MKMapView
//
//  Created by administrator on 16/7/4.
//  Copyright © 2016年 com.baiyimao.bai. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>//定位
#import <MapKit/MapKit.h>   //地图
#import "KCAnnotation.h"    //大头针


#import "PickViewViewController.h"


/*
 
 地图的定位 地图的编码 地图系统的大头针 地图的自定义大头针
 
 */
@interface ViewController ()<CLLocationManagerDelegate,MKMapViewDelegate>{
    
    CLLocationManager *_locationManager;//定位管理器
    CLGeocoder *_geocoder;//地理编码
    MKMapView *_mapView;//地图
    
}


@end

@implementation ViewController
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    PickViewViewController *pickVC = [[PickViewViewController alloc]init];
    [self presentViewController:pickVC animated:YES completion:nil];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//        [self positionOfMap];//定位管理器
//        [self geocoderOfMap];//地理编码

    [self initGUI];
    
}

/**
 设置地图的时候 一定要在plist文件里面去设置属性：NSLocationAlwaysUsageDescription 、NSLocationWhenInUseUsageDescription
 以及网络属性的设置
 */
//定位管理器
- (void)positionOfMap
{
    //定位管理器
    _locationManager=[[CLLocationManager alloc]init];
    
    //+ (BOOL)locationServicesEnabled 是否启用定位服务，通常如果用户没有启用定位服务可以提示用户打开定位服务
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位服务当前可能尚未打开，请设置打开！");
        return;
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        
        [_locationManager requestWhenInUseAuthorization];  //调用了这句,就会弹出允许框了.
    }
    /*
     + (CLAuthorizationStatus)authorizationStatus;
     定位服务授权状态，返回枚举类型：
     
     kCLAuthorizationStatusNotDetermined： 用户尚未做出决定是否启用定位服务
     kCLAuthorizationStatusRestricted： 没有获得用户授权使用定位服务,可能用户没有自己禁止访问授权
     kCLAuthorizationStatusDenied ：用户已经明确禁止应用使用定位服务或者当前系统定位服务处于关闭状态
     kCLAuthorizationStatusAuthorizedAlways： 应用获得授权可以一直使用定位服务，即使应用不在使用状态
     kCLAuthorizationStatusAuthorizedWhenInUse： 使用此应用过程中允许访问定位服务
     */
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        [_locationManager requestWhenInUseAuthorization];
        
    }else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse){
        //设置代理
        _locationManager.delegate=self;
        //设置定位精度
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        //定位频率,每隔多少米定位一次
        CLLocationDistance distance=10.0;//十米定位一次
        _locationManager.distanceFilter=distance;
        //启动跟踪定位
        [_locationManager startUpdatingLocation];//开始定位追踪，开始定位后将按照用户设置的更新频率执行
        
    }
    
}
//地理编码
- (void)geocoderOfMap
{
    _geocoder=[[CLGeocoder alloc]init];
    [self getCoordinateByAddress:@"北京"];
    [self getAddressByLatitude:+39.90498900 longitude:+116.40528500];
    
}

#pragma mark - CoreLocation 代理
#pragma mark 跟踪定位代理方法，每次位置发生变化即会执行（只要定位到相应位置）
//可以通过模拟器设置一个虚拟位置，否则在模拟器中无法调用此方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *location=[locations firstObject];//取出第一个位置
    CLLocationCoordinate2D coordinate=location.coordinate;//位置坐标
    NSLog(@"经度：%f,纬度：%f,海拔：%f,航向：%f,行走速度：%f",coordinate.longitude,coordinate.latitude,location.altitude,location.course,location.speed);
    //如果不需要实时定位，使用完即使关闭定位服务
    [_locationManager stopUpdatingLocation];//停止定位追踪
    
    
}
/*
 1、 startUpdatingHeading   开始导航方向追踪
 
 2、 stopUpdatingHeading    停止导航方向追踪
 
 3、 startMonitoringForRegion 开始对某个区域进行定位追踪，开始对某个区域进行定位后。如果用户进入或者走出某个区域会调用- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
 和
 - (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region代理方法反馈相关信息
 
 4、 stopMonitoringForRegion    停止对某个区域进行定位追踪
 
 5、 requestWhenInUseAuthorization  请求获得应用使用时的定位服务授权，注意使用此方法前在要在info.plist中配置NSLocationWhenInUseUsageDescription
 
 6、requestAlwaysAuthorization 请求获得应用一直使用定位服务授权，注意使用此方法前要在info.plist中配置NSLocationAlwaysUsageDescription
 */

#pragma mark 根据地名确定地理坐标
-(void)getCoordinateByAddress:(NSString *)address{
    //地理编码
    [_geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        //取得第一个地标，地标中存储了详细的地址信息，注意：一个地名可能搜索出多个地址
        CLPlacemark *placemark=[placemarks firstObject];
        
        CLLocation *location=placemark.location;//位置
        CLRegion *region=placemark.region;//区域
        NSDictionary *addressDic= placemark.addressDictionary;//详细地址信息字典,包含以下部分信息
        //        NSString *name=placemark.name;//地名
        //        NSString *thoroughfare=placemark.thoroughfare;//街道
        //        NSString *subThoroughfare=placemark.subThoroughfare; //街道相关信息，例如门牌等
        //        NSString *locality=placemark.locality; // 城市
        //        NSString *subLocality=placemark.subLocality; // 城市相关信息，例如标志性建筑
        //        NSString *administrativeArea=placemark.administrativeArea; // 州
        //        NSString *subAdministrativeArea=placemark.subAdministrativeArea; //其他行政区域信息
        //        NSString *postalCode=placemark.postalCode; //邮编
        //        NSString *ISOcountryCode=placemark.ISOcountryCode; //国家编码
        //        NSString *country=placemark.country; //国家
        //        NSString *inlandWater=placemark.inlandWater; //水源、湖泊
        //        NSString *ocean=placemark.ocean; // 海洋
        //        NSArray *areasOfInterest=placemark.areasOfInterest; //关联的或利益相关的地标
        NSLog(@"位置:%@,区域:%@,详细信息:%@",location,region,addressDic);
        
        //反编码
        [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            
            CLPlacemark *placemark=[placemarks firstObject];
            NSLog(@"详细信息:%@",placemark.addressDictionary);
        }];
        
    }];
    
    
    
}

#pragma mark 根据坐标取得地名
-(void)getAddressByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude{
    //反地理编码
    CLLocation *location=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark=[placemarks firstObject];
        NSLog(@"详细信息:%@",placemark.addressDictionary);
    }];
    
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        NSLog(@"反编码");
    }];
}




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
    [_mapView addAnnotation:annotation1];
    
    CLLocationCoordinate2D location2=CLLocationCoordinate2DMake(22.55, 114.12);
    KCAnnotation *annotation2=[[KCAnnotation alloc]init];
    annotation2.title=@"Kenshin&Kaoru";
    annotation2.subtitle=@"Kenshin Cui's Home";
    annotation2.coordinate=location2;
    annotation2.image=[UIImage imageNamed:@"icon_classify_cafe"];
    [_mapView addAnnotation:annotation2];
}
    /*
     *注意： 如果在plist 文件里面 没有设置requestAlwaysAuthorization或locationServicesEnabled 那么就不会显示当前的位置
     */


#pragma mark - 地图控件代理方法
#pragma mark 更新用户位置，只要用户改变则调用此方法（包括第一次定位到用户位置）
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    NSLog(@"%@",userLocation.title);
    //设置地图显示范围(如果不进行区域设置会自动显示区域范围并指定当前用户位置为地图中心点)
    //    MKCoordinateSpan span=MKCoordinateSpanMake(0.01, 0.01);
    //    MKCoordinateRegion region=MKCoordinateRegionMake(userLocation.location.coordinate, span);
    //    [_mapView setRegion:region animated:true];
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
            /*  canShowCallout
             点击大头针是否显示标题、子标题内容等，注意如果在
             - (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation;
             方法中重新定义大头针默认情况是无法交互的需要设置为true
             */
            annotationView.canShowCallout=true;//允许交互点击
            
            annotationView.calloutOffset=CGPointMake(0, 1);//定义详情视图偏移量
            annotationView.leftCalloutAccessoryView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"1"]];//定义详情左侧视图
//            annotationView.selected = YES;//是否被选中状态
//            annotationView.rightCalloutAccessoryView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"1"]];//弹出详情右侧视图


        }
        
        //修改大头针视图
        //重新设置此类大头针视图的大头针模型(因为有可能是从缓存池中取出来的，位置是放到缓存池时的位置)
        annotationView.annotation=annotation;
        annotationView.image=((KCAnnotation *)annotation).image;//设置大头针视图的图片
        
        return annotationView;
    }else {
        return nil;
    }
    /* 注意：
     a.这个代理方法的调用时机:每当有大头针显示到系统可视界面中时就会调用此方法返回一个大头针视图放到界面中，同时当前系统位置标注（也就是地图中蓝色的位置点）也是一个大头针，也会调用此方法，因此处理大头针视图时需要区别对待。
     
     b.类似于UITableView的代理方法，此方法调用频繁，开发过程中需要重复利用MapKit的缓存池将大头针视图缓存起来重复利用。
     
     c.自定义大头针默认情况下不允许交互，如果交互需要设置canShowCallout=true
     
     d.如果代理方法返回nil则会使用默认大头针视图，需要根据情况设置。
     
     下面以一个示例进行大头针视图设置，这里设置了大头针的图片、弹出视图、偏移量等信息。
     
     
     注意 ： 在MapKit框架中除了MKAnnotationView之外还有一个MKPinAnnotationView，它是MKAnnotationView的子类，相比MKAnnotationView多了两个属性pinColor和animationDrop，分别用于设置大头针视图颜色和添加大头针动画。
     */
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
