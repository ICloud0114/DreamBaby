//
//  DayKnowledgeViewController.h
//  DreamBaby
//
//  Created by easaa on 14-1-9.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

//每日知识

#import <UIKit/UIKit.h>

@interface DayKnowledgeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
   
    UITableView * mTableView;
    
    NSString * flagType;

    NSMutableArray *listArray;

    unsigned long allDay;
    BOOL initTag;
}

@property (nonatomic, retain) NSDate *huaiYunDate;
@property (nonatomic, retain) NSDate *beforeDate;

@end
