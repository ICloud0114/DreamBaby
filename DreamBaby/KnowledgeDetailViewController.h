//
//  KnowledgeDetailViewController.h
//  DreamBaby
//
//  Created by easaa on 2/13/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DayKnowledgeCell.h"

@interface KnowledgeDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{

    NSString *article_id;
    UITableView * mTableView;
    int weekNum;
    NSString *weekdayStr;
    NSString *dateStr;
    NSString *titleStr;
    UIImage *iconImage;
    NSString *webStr;
    DayKnowledgeCell *currentCell;
}
-(id)initWithDetail:(NSString*)entity Week:(int)num Weekday:(NSString*)weekday Date:(NSString *)date Title:(NSString*)title Image:(UIImage*)image;
@end
