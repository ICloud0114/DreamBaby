//
//  MapController.m
//  zuimei
//
//  Created by FlipFlopStudio on 12-8-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MapController.h"
#import "MKMapView+ZoomLevel.h"
#import  "MapDeatilViewController.h"
#import "JSONKit.h"
#import "CustonMKAnnotation.h"
#define ZOOM_LEVEL 1

@implementation MapController
@synthesize lat,lng;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(id)initWithG:(NSString*)g
{
    self = [super init];
    if (self) {
        _g = g;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */
-(void)mapList
{
    [UIView beginAnimations:@"animationID" context:nil];
	[UIView setAnimationDuration:0.7f];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationRepeatAutoreverses:NO];
    if (mapView.hidden) {
//        [rightBtn setTitle:@"列表" forState:UIControlStateNormal];
        [rightBtn setBackgroundImage:[UIImage imageNamed:@"top_liebiao"] forState:UIControlStateNormal];
        //        self.navigationItem.rightBarButtonItem.title = @"列表";
        [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view cache:YES];
        [UIView commitAnimations];
        mapTabelView.hidden = YES;
        mapView.hidden = NO;
    }else{
//        [rightBtn setTitle:@"地图" forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"top_map"] forState:UIControlStateNormal];
        //        self.navigationItem.rightBarButtonItem.title = @"地图";
        [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view cache:YES];
        [UIView commitAnimations];
        mapTabelView.hidden = NO;
        mapView.hidden = YES;
    }
    
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *image = [UIImage imageNamed:@"top_liebiao"];
    rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGRect frame_1= CGRectMake(0, 0, image.size.width, image.size.height);
    rightBtn.frame = frame_1;
    [rightBtn setBackgroundImage:image forState:UIControlStateNormal];
//    [rightBtn setBackgroundImage:[UIImage imageNamed:@"top_liebiao"] forState:UIControlStateHighlighted];

//    [rightBtn setBackgroundImage:[UIImage imageNamed:@"top_btn02_h"] forState:UIControlStateHighlighted];
//    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBtn addTarget:self action:@selector(mapList) forControlEvents:UIControlEventTouchUpInside];
//    [rightBtn setBackgroundImage:[UIImage imageNamed:@"top_liebiao"] forState:UIControlStateNormal];
//    [rightBtn setTitle:@"列表" forState:UIControlStateNormal];
    rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [self.navigationItem setRightBarButtonItem:rightBtnItem];
//    CLLocationCoordinate2D coordinate;
//    coordinate.latitude = lat;
//    coordinate.longitude = lng;
    
//    _search = [[BMKSearch alloc] init];
//    _search.delegate =self;
//    [_search poiSearchNearBy:_g center:coordinate radius:5000 pageIndex:0];
    
    
    mapTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-44 - 49)];
    
    mapTabelView.delegate = self;
    mapTabelView.dataSource = self;
    mapTabelView.hidden = YES;
    [self.view addSubview:mapTabelView];
    
    mapView=[[MKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-44 - 49)];
    [mapView setDelegate:self];
    mapView.showsUserLocation = YES;
    [self.view addSubview:mapView];
    //设置地图中心
    [self conDidFinish];
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
        [mapTabelView setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-44 - 49 - 20)];
        [mapView setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-44 - 49 - 20)];
    }
    
//    MKCoordinateSpan span = MKCoordinateSpanMake(0.6250, 0.6250);
//    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);
//    MKLocalSearchRequest *locreq=[[MKLocalSearchRequest alloc]init];
//    locreq.naturalLanguageQuery=_g;
//    locreq.region=region;
//    
//    MKLocalSearch *secnew=[[MKLocalSearch alloc]initWithRequest:locreq];
//    [secnew startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
//        if(error){
//            NSLog(@"localSearch startWithCompletionHandlerFailed!  Error: %@", error);
//            return;
//        } else {
//            NSMutableArray *citems = [[NSMutableArray alloc] init];
//            if ([response.mapItems count]>0) {
//                int i=0;
//                for(MKMapItem *mapItem in response.mapItems){
//                    // Show pins, pix, w/e...
//                    NSLog(@"Name for result: = %@", mapItem.name);
//                    // Other properties includes: phoneNumber, placemark, url, etc.
//                    CustonMKAnnotation *ann = [[CustonMKAnnotation alloc] init];
////                    ann.coordinate = mapItem.placemark;
//                    [ann setTitle:mapItem.name];
//                    [ann setSubtitle:mapItem.phoneNumber];
//                    ann.tag = i;
//                    i++;
//                    [citems addObject:ann];
//                    [ann release];
//                }
//            }
//            MKCoordinateSpan span = MKCoordinateSpanMake(0.2, 0.2);
//            MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);
//            [mapView setRegion:region animated:NO];
//        }
//    }];
}


-(void)getlocInfo{

//    http=[[HttpRequestUnity alloc] init];
//    http.httpdelegate=self;
//     NSString *encodedValue = (NSString*)CFURLCreateStringByAddingPercentEscapes(nil,(CFStringRef)_g, nil,(CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
    dispatch_queue_t network;
    network = dispatch_queue_create("nearBy", nil);
    dispatch_async(network, ^{
        NSString *encodedValue =[_g URLEncodedString];
        NSLog(@"encoded:%@",encodedValue);
        NSString *param=[NSString stringWithFormat:@"http://api.map.baidu.com/place/v2/search?ak=0E2572be1c5cd07d2948acf696312669&output=json&query=%@&page_size=10&page_num=0&scope=1&location=%f,%f&radius=5000",encodedValue,lat,lng];
        NSLog(@"---%@",param);
        NSString *request=[HTTPRequest requestForGet:param];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (request) {
                if (request.length>0) {
                    listArray=[[NSMutableArray alloc]init];
                    NSMutableDictionary *temdic=[request objectFromJSONString];
                    NSMutableArray *arr=[temdic objectForKey:@"results"];
                    listArray=[arr copy];
                    NSMutableArray *citems = [[NSMutableArray alloc] init];
                    int i=0;
                    for (NSMutableDictionary *dic in arr) {
                        CustonMKAnnotation *ann = [[CustonMKAnnotation alloc] init];
                        NSMutableDictionary *locationdic=[dic objectForKey:@"location"];
                        CLLocationCoordinate2D coordinate;
                        coordinate.latitude =[[locationdic objectForKey:@"lat"] doubleValue];
                        coordinate.longitude =[[locationdic objectForKey:@"lng"] doubleValue];
                        ann.coordinate = coordinate;
                        [ann setTitle:[dic objectForKey:@"name"]];
                        [ann setSubtitle:[dic objectForKey:@"telephone"]];
                        ann.tag = i;
                        i++;
                        [citems addObject:ann];
                        [ann release];
                    }
                    [mapTabelView reloadData];
                    [mapView addAnnotations:citems];
                    [citems release];
                    CLLocationCoordinate2D coordinate;
                    coordinate.latitude = lat;
                    coordinate.longitude = lng;
                    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordinate,5000, 500);
                    MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
                    //    以上代码创建出来一个符合MapView横纵比例的区域
                    [mapView setRegion:adjustedRegion animated:YES];
                }
            }

        });
    });
    
//    [http requestNoCache:param setView:self.view];
    

}

-(void)conDidFinish:(NSData *)finishdata{
    NSString *result=[[NSString alloc]initWithData:finishdata encoding:NSUTF8StringEncoding];
    NSLog(@"finish:%@", finishdata );
    if (result.length>0) {
        listArray=[[NSMutableArray alloc]init];
     NSMutableDictionary *temdic=[result objectFromJSONString];
      NSMutableArray *arr=[temdic objectForKey:@"results"];
        listArray=[arr copy];
        NSMutableArray *citems = [[NSMutableArray alloc] init];
        int i=0;
        for (NSMutableDictionary *dic in arr) {
            CustonMKAnnotation *ann = [[CustonMKAnnotation alloc] init];
            NSMutableDictionary *locationdic=[dic objectForKey:@"location"];
            CLLocationCoordinate2D coordinate;
            coordinate.latitude =[[locationdic objectForKey:@"lat"] doubleValue];
            coordinate.longitude =[[locationdic objectForKey:@"lng"] doubleValue];
            ann.coordinate = coordinate;
            [ann setTitle:[dic objectForKey:@"name"]];
            [ann setSubtitle:[dic objectForKey:@"telephone"]];
            ann.tag = i;
            i++;
            [citems addObject:ann];
            [ann release];
        }
    [mapTabelView reloadData];
    [mapView addAnnotations:citems];
    [citems release];
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = lat;
    coordinate.longitude = lng;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordinate,5000, 500);
    MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
    //    以上代码创建出来一个符合MapView横纵比例的区域
    [mapView setRegion:adjustedRegion animated:YES];
    }
    
    [result release];
}

-(void)conDidFailWithError:(NSString *)error{
}
-(void)conDidReceiveResponse:(NSURLResponse *)data{
}
-(void)conDidReceiveData:(NSData *)data{
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{

    mapTabelView.delegate = nil;
    [mapTabelView release];
    mapView.delegate = nil;
    [mapView release];
    [rightBtnItem release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return NO;
}

//- (void)onGetPoiResult:(NSArray*)poiResultList searchType:(int)type errorCode:(int)error
//{
//    NSMutableArray *citems = [[NSMutableArray alloc] init];
//    NSLog(@"onGetPoiResult");
//    if (poiResultList.count > 0) {
//        BMKPoiResult *result = [poiResultList objectAtIndex:0];
//        listArray = [result.poiInfoList retain];
//        //        BMKPoiInfo *info = [result.poiInfoList objectAtIndex:0];
//        for (int i = 0; i<listArray.count; i++) {
//            BMKPoiInfo *info = [listArray objectAtIndex:i];
//            CustonMKAnnotation *ann = [[CustonMKAnnotation alloc] init];
//            ann.coordinate = info.pt;
//            [ann setTitle:info.name];
//            [ann setSubtitle:info.phone];
//            ann.tag = i;
//            [citems addObject:ann];
//            [ann release];
//        }
//        [mapTabelView reloadData];
//    }
//    [mapView addAnnotations:citems];
//    [citems release];
//    CLLocationCoordinate2D coordinate;
//    coordinate.latitude = lat;
//    coordinate.longitude = lng;
//    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordinate,5000, 500);
//    MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
//    //    以上代码创建出来一个符合MapView横纵比例的区域
//    [mapView setRegion:adjustedRegion animated:YES];
//    
//}

- (MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
{
    if (annotation == mV.userLocation) {
        ((MKPointAnnotation*)annotation).title = @"我的位置";
        return nil;
    }
    MKPinAnnotationView *pinView = nil;
    static NSString *defaultPinID = @"custom pin";
    pinView = (MKPinAnnotationView *)[mV dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
    if ( pinView == nil )
    {
        pinView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:defaultPinID] autorelease];
        [pinView setDraggable:YES];
    }
    pinView.pinColor = MKPinAnnotationColorRed;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [button setTag:((CustonMKAnnotation*)annotation).tag];
    [button addTarget:self action:@selector(goToInfo:) forControlEvents:UIControlEventTouchUpInside];
    pinView.rightCalloutAccessoryView =button;
    pinView.canShowCallout = YES;
    pinView.animatesDrop = YES;
    return pinView;
}

- (void)goToInfo:(UIButton*)sender{
    NSMutableDictionary *result = [listArray objectAtIndex:sender.tag];
    MapDeatilViewController *mapviewdd=[[MapDeatilViewController alloc]init];
    mapviewdd.newresult=result;
    mapviewdd.title=@"详细信息";
    [self.navigationController pushViewController:mapviewdd animated:YES];
    [mapviewdd release];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    int index = indexPath.row;
    NSMutableDictionary *temdic=[listArray objectAtIndex:index];
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if (cell == nil) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                       reuseIdentifier: SimpleTableIdentifier] autorelease];
        cell.textLabel.backgroundColor = [UIColor colorwithHexString:@"#f4f5f7"];
//        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = [temdic objectForKey:@"name"];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor colorwithHexString:@"#F94BB3"];
    
    cell.detailTextLabel.text = [temdic objectForKey:@"address"];
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.detailTextLabel.textColor = [UIColor colorwithHexString:@"#878787"];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index = indexPath.row;
    NSMutableDictionary *result = [listArray objectAtIndex:index];
    MapDeatilViewController *mapviewdd=[[MapDeatilViewController alloc]init];
    mapviewdd.newresult=result;
    mapviewdd.title=@"详细信息";
    [self.navigationController pushViewController:mapviewdd animated:YES];
    [mapviewdd release];
    
}
@end
