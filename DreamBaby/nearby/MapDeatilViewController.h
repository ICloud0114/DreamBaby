//
//  MapDeatilViewController.h
//  FoodTime
//
//  Created by FlipFlopStudio on 12-10-25.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface MapDeatilViewController : UIViewController<MKMapViewDelegate>
{
    NSMutableDictionary *newresult;
    UILabel *namelab;
    UILabel *addresslab;
    UILabel *phonelab;
}
@property (nonatomic,retain) NSMutableDictionary *newresult;
@end
