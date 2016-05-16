//
//  YuerHistoryViewController.h
//  DreamBaby
//
//  Created by easaa on 14-1-9.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
//育儿故事
@interface YuerHistoryViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * mTableView;
    NSMutableArray *listArray;
}

@property (nonatomic ,retain)    NSString *article_id;
@property(nonatomic,retain)AVAudioPlayer *myBackMusic;





@end
