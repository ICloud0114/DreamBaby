//
//  NearbyController.h
//  zuimei
//
//  Created by FlipFlopStudio on 12-8-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>



@interface NearbyController : UIViewController<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>
{
    UITableView *nearbyTable;
    double lat;
    double lng;
    NSString *address;
    UILabel *loc;
    UIActivityIndicatorView *searchLoading;
    bool isLoading;
    NSString *btnflag;
    CLLocationManager *lm;
}
@property(nonatomic,retain)NSString *btnflag;
@end
