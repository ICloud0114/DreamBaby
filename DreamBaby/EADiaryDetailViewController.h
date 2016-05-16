//
//  DiaryDetailViewController.h
//  DreamBaby
//
//  Created by easaa on 14-1-6.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EADiaryDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * diaryTableView;
    NSString *contentString;
    UIImageView *imageView;
}

@property (nonatomic ,retain) NSDictionary *dictionary;
@end
