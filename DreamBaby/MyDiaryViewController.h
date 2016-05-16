//
//  MyDiaryViewController.h
//  DreamBaby
//
//  Created by easaa on 14-1-6.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaPlayer/MPMoviePlayerController.h"
#import "tipAlertView.h"
#import <MediaPlayer/MediaPlayer.h>
@class AppDelegate;

@interface MyDiaryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UITableView * diaryTableView;

    UIScrollView * contentScrollerView;
    
    tipAlertView * tipVC;
    
    UIImageView * _imageView;
}

@end
