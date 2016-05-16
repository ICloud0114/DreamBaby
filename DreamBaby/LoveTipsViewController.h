//
//  LoveTipsViewController.h
//  DreamBaby
//
//  Created by easaa on 14-1-8.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

//关爱提醒

#import <UIKit/UIKit.h>
#import "DailyDetailViewController.h"

@interface LoveTipsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UILabel *titleLabel;
    
    UITableView *loveTipTable;

    NSMutableArray *droplistArray;
    UITableView *dropTable;
    UIImageView *dropView;
    UIView *tableImage;
    
    UITableView * goverTableView;
    
    UITableView *infoCheckTable;
    
    int flag;
    
    unsigned long allDay;
}
@property(nonatomic,retain)NSMutableArray *droplistArray;
@property(nonatomic,copy)NSString *isLoveTip;
@end
