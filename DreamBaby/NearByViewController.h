//
//  NearByViewController.h
//  DreamBaby
//
//  Created by easaa on 14-1-4.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MapController.h"

@interface NearByViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>
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