//
//  NearbyController.m
//  zuimei
//
//  Created by FlipFlopStudio on 12-8-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "MapController.h"
#import "NearbyController.h"
@implementation NearbyController
@synthesize btnflag;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
        [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_bg.png"]];
    isLoading = NO;
    UIImageView *header = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    [header setImage:[UIImage imageNamed:@"mid_bg02.png"]];
    searchLoading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    searchLoading.frame = CGRectMake(80, 13, 2, 2);
    [header addSubview:searchLoading];
    
    UIImageView *lbs = [[UIImageView alloc] initWithFrame:CGRectMake(0, 3, 15, 24)];
    [lbs setImage:[UIImage imageNamed:@"lbs_icon.png"]];    
    [lbs setBackgroundColor:[UIColor clearColor]];
    [header addSubview:lbs];
    [lbs release];
    
    loc = [[UILabel alloc] initWithFrame:CGRectMake(20, 2, 250, 26.0)];
    [loc setBackgroundColor:[UIColor clearColor]];
    [loc setFont:[UIFont boldSystemFontOfSize:14.0]];
    [loc setTextColor:[UIColor blackColor]];
    [loc setTextAlignment:NSTextAlignmentLeft];
    [header addSubview:loc];
    [self.view addSubview:header];
    [header release];
    
    nearbyTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, 320, self.view.frame.size.height-44) style:UITableViewStyleGrouped];
    nearbyTable.dataSource = self;
    nearbyTable.delegate = self;
    nearbyTable.backgroundColor = [UIColor clearColor];
    nearbyTable.backgroundView=nil;
    [self.view addSubview:nearbyTable];
    [self loadLocation];
    
    UIImage *image=[UIImage imageNamed:@"more_zhuce.png"];
    UIButton* backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(0, 0, image.size.width, image.size.height);
    [backButton setBackgroundImage:image forState:UIControlStateNormal];
    [backButton setTitle:@"定位" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backButton.titleLabel.font=[UIFont systemFontOfSize:16];
    [backButton addTarget:self action:@selector(loadLocation) forControlEvents:UIControlEventTouchUpInside];
    
    //定制自己的风格的  UIBarButtonItem
    UIBarButtonItem* someBarButtonItem= [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setRightBarButtonItem:someBarButtonItem];
    [someBarButtonItem release];

}

-(void)loadLocation
{
    [searchLoading startAnimating];
    loc.text = @"定位中..";
    lm = [[CLLocationManager alloc] init];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8)
    {
        //获取授权认证
        [lm requestAlwaysAuthorization];
        [lm requestWhenInUseAuthorization];
    }
    
    
    if ([CLLocationManager locationServicesEnabled])
    {
        lm.delegate = self;
        lm.desiredAccuracy = kCLLocationAccuracyBest;
        lm.distanceFilter = 1000.0f;
        [lm startUpdatingLocation];
    }
    else{
    
        
    
    }

}
- (void)dealloc
{
    [lm stopUpdatingLocation];
    lm.delegate = nil;
    [lm release];
//    _search.delegate = nil;
//    [_search release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return NO;
}

#pragma mark
#pragma nearBy methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index = indexPath.row;
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier: SimpleTableIdentifier] autorelease];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    switch (index) {
        case 0:
            cell.textLabel.text = @"餐饮美食";
            break;
        case 1:
            cell.textLabel.text = @"小吃快餐";
            break;
        case 2:
            cell.textLabel.text = @"咖啡茶室";
            break;
        case 3:
            cell.textLabel.text = @"商场超市";
            break;
        case 4:
            cell.textLabel.text = @"生活服务";
            break;
        default:
            cell.textLabel.text = @"停车服务";
            break;
    }
    return cell;
    
}
//餐厅饭店", "小吃快餐", "咖啡厅", "商场", "生活", "停车"
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index = indexPath.row;
    if (isLoading) {
        NSString *g;
        switch (index) {
            case 0:
                g = @"餐厅饭店";
                break;
            case 1:
                g = @"小吃快餐";
                break;
            case 2:
                g = @"咖啡厅";
                break;
            case 3:
                g = @"商场";
                break;
            case 4:
                g = @"生活";
                break;
            default:
                g = @"停车";
                break;
        }
        MapController *controller = [[MapController alloc] initWithG:g];
        controller.lat = lat;
        controller.lng = lng;
        controller.title = g;
        [self.navigationController pushViewController:[controller autorelease] animated:YES];
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"   
                                                       message:@"正在定位中请稍后。。"   
                                                      delegate:self   
                                             cancelButtonTitle:@"取消"
                                             otherButtonTitles:nil];  
        [alert show];
        [alert release];
    }
    
}

- (void) locationManager: (CLLocationManager *) manager
     didUpdateToLocation: (CLLocation *) newLocation
            fromLocation: (CLLocation *) oldLocation{
    lat = newLocation.coordinate.latitude;
    lng = newLocation.coordinate.longitude;
     NSLog(@"定位成功");
    CLGeocoder *clgeo=[[CLGeocoder alloc]init];
    [clgeo reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks,NSError *error){
        if ([placemarks count]>0)
        {
            isLoading=YES;
        }
        for (CLPlacemark *park in placemarks) {
//            NSLog(@"park:%@",park.addressDictionary);
//            NSLog(@"park:%@",[park.addressDictionary objectForKey:@"Name"]);
            address=[NSString stringWithFormat:@"%@%@%@",[park.addressDictionary objectForKey:@"Country"],[park.addressDictionary objectForKey:@"State"],[park.addressDictionary objectForKey:@"SubLocality"]];
            loc.text = address;
            loc.text = address;
            [searchLoading stopAnimating];
            [searchLoading removeFromSuperview];

        }
    
    }];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    [manager stopUpdatingLocation];
    if (locations.count > 0)
    {
        lat = ((CLLocation *)[locations objectAtIndex:0]).coordinate.latitude;
        lng = ((CLLocation *)[locations objectAtIndex:0]).coordinate.longitude;
        
    }
    
    CLGeocoder *clgeo=[[CLGeocoder alloc]init];
    [clgeo reverseGeocodeLocation:[locations objectAtIndex:0] completionHandler:^(NSArray *placemarks,NSError *error){
        if ([placemarks count]>0)
        {
            isLoading=YES;
        }
        for (CLPlacemark *park in placemarks) {
            //            NSLog(@"park:%@",park.addressDictionary);
            //            NSLog(@"park:%@",[park.addressDictionary objectForKey:@"Name"]);
            address=[NSString stringWithFormat:@"%@%@%@",[park.addressDictionary objectForKey:@"Country"],[park.addressDictionary objectForKey:@"State"],[park.addressDictionary objectForKey:@"SubLocality"]];
            loc.text = address;
            loc.text = address;
            [searchLoading stopAnimating];
            [searchLoading removeFromSuperview];
            
        }
        
    }];
    
    
}

- (void) locationManager: (CLLocationManager *) manager
        didFailWithError: (NSError *) error {
    NSLog(@"定位失败");
    loc.text = @"定位失败";
}

@end
