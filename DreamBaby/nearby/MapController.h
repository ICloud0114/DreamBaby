//
//  MapController.h
//  zuimei
//
//  Created by FlipFlopStudio on 12-8-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "HTTPRequest.h"
#import "NSString+URLEncoding.h"
#import "JSONKit.h"
@interface MapController :UIViewController <MKMapViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    MKMapView *mapView;
    UITableView *mapTabelView;
    NSMutableArray *listArray;
    NSString *_g;
    UIBarButtonItem *rightBtnItem;
    UIButton *rightBtn;
//    HttpRequestUnity *http;
}
-(id)initWithG:(NSString*)g;
@property(nonatomic,assign) double lat;
@property(nonatomic,assign) double lng;
@end
