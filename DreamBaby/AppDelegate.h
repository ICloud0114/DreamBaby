//
//  AppDelegate.h
//  DreamBaby
//
//  Created by easaa on 14-1-3.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MyNavigationController.h"
#import "LoginViewController.h"
#import "ATMHudDelegate.h"
#import "ATMHud.h"
#import "ChangeDate.h"
#import "AGViewDelegate.h"

#import "GuideViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate,CLLocationManagerDelegate,UIAlertViewDelegate, UITabBarControllerDelegate>
{
    CLLocationManager *lm;
    NSString* cityName;

    NSString* appsn;
    ATMHud *hud;
    AGViewDelegate *_viewDelegate;
    int selectIndex;
    GuideViewController *guideViewController;
    NSString *versionURLString;
    NSMutableDictionary *JPushDictionary;
    
    BOOL isActivity;
    
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,readonly) AGViewDelegate *viewDelegate;

@end
