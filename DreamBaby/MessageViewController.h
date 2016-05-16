//
//  MessageViewController.h
//  梦想宝贝
//
//  Created by IOS001 on 14-4-23.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTTPRequest.h"
#import "JsonUtil.h"
@interface MessageViewController : UIViewController
{
    BOOL isUp;
}
@property(nonatomic,copy)NSString *ID;
@end
