//
//  TaijiaoMusicViewController.h
//  DreamBaby
//
//  Created by easaa on 14-1-9.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MediaPlayer/MediaPlayer.h>

#import <AVFoundation/AVFoundation.h>
@class AppDelegate;

@interface TaijiaoMusicViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * mTableView;

    NSMutableArray *listArray;
}

@property (nonatomic ,retain) NSString *article_id;
@end
