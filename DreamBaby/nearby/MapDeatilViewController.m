//
//  MapDeatilViewController.m
//  FoodTime
//
//  Created by FlipFlopStudio on 12-10-25.
//
//

#import "MapDeatilViewController.h"
#import "MKMapView+ZoomLevel.h"
#import  "MapDeatilViewController.h"
@interface MapDeatilViewController ()

@end

@implementation MapDeatilViewController
@synthesize newresult;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//NSString* _name;			///<POI名称
//NSString* _address;		///<POI地址
//NSString* _city;			///<POI所在城市
//NSString* _phone;		///<POI电话号码
//NSString* _postcode;		///<POI邮编
//int		  _epoitype;		///<POI类型，0:普通点 1:公交站 2:公交线路 3:地铁站 4:地铁线路

CLLocationCoordinate2D _pt;	///<POI坐标
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"详细信息";
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg"]];
    
    MKMapView *mapView=[[MKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-44 - 49)];
    mapView.delegate=self;
    [self.view addSubview:mapView];
    mapView.showsUserLocation = YES;
    [mapView release];
    
    NSMutableArray *citems=[[NSMutableArray alloc]init];
    MKPointAnnotation *ann = [[MKPointAnnotation alloc] init];
    CLLocationCoordinate2D coordinate;
    NSMutableDictionary *temdic=[newresult objectForKey:@"location"];
    coordinate.latitude =[[temdic objectForKey:@"lat"] doubleValue];
    coordinate.longitude =[[temdic objectForKey:@"lng"] doubleValue];
    ann.coordinate = coordinate;
    [ann setTitle:[newresult objectForKey:@"name"]];
    [ann setSubtitle:[newresult objectForKey:@"telephone"]];
    [citems addObject:ann];
    [ann release];
    [mapView addAnnotations:citems];
    [citems release];

    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordinate,500, 300);
    MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
    //    以上代码创建出来一个符合MapView横纵比例的区域
    [mapView setRegion:adjustedRegion animated:YES];
    
    
    
    UIView *myContentView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 49 - 66 - 44 , 320, 66)];
    [self.view addSubview:myContentView];
    myContentView.backgroundColor = [UIColor clearColor];
    
    UIView *myBG = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 66)];
    myBG.backgroundColor = [UIColor colorwithHexString:@"#DD2E94"];
    myBG.alpha = 0.4;
    [myContentView addSubview:myBG];
    [myBG release];
    
    namelab=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 300, 20)];
    namelab.font = [UIFont systemFontOfSize:13];
    namelab.textColor = [UIColor whiteColor];
    namelab.backgroundColor=[UIColor clearColor];
    namelab.text=[NSString stringWithFormat:@"%@",[newresult objectForKey:@"name"]];
    [myContentView addSubview:namelab];
    [namelab release];
    
    addresslab=[[UILabel alloc]initWithFrame:CGRectMake(10, 22, 300, 20)];
    addresslab.font = [UIFont systemFontOfSize:11];
    addresslab.textColor = [UIColor whiteColor];
    addresslab.backgroundColor=[UIColor clearColor];
    addresslab.text=[NSString stringWithFormat:@"地址:%@",[newresult objectForKey:@"address"]];
    [myContentView addSubview:addresslab];
    
    phonelab=[[UILabel alloc]initWithFrame:CGRectMake(10, 44, 300, 20)];
    phonelab.font = [UIFont systemFontOfSize:11];
    phonelab.textColor = [UIColor whiteColor];
    phonelab.backgroundColor=[UIColor clearColor];
    NSString *phonestr=[newresult objectForKey:@"telephone"];
    if (phonestr==NULL) {
        phonelab.text=@"电话:暂无数据";
    }
    else{
        phonelab.text=[NSString stringWithFormat:@"电话:%@",phonestr];
    }
    [myContentView addSubview:phonelab];
    
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
        [myContentView setFrame:CGRectMake(0, self.view.frame.size.height - 49 - 66 - 44 - 20, 320, 66)];
        [mapView setFrame:CGRectMake(0, 20, 320, self.view.frame.size.height-44 - 49 )];
        
    }
    
    [myContentView release];
}

- (MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
{
    if (annotation == mV.userLocation) {
        ((MKPointAnnotation*)annotation).title = @"我的位置";
        return nil;
    }
    MKPinAnnotationView *pinView = nil;
    pinView.pinColor = MKPinAnnotationColorRed;
    return pinView;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
