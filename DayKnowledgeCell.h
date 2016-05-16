//
//  DayKnowledgeCell.h
//  DreamBaby
//
//  Created by easaa on 14-1-9.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZAutoSizeImageView.h"

@interface DayKnowledgeCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIView *BgView;
@property (retain, nonatomic) IBOutlet UILabel *WeekLabel;
@property (retain, nonatomic) IBOutlet UILabel *Daylabel;
@property (retain, nonatomic) IBOutlet UILabel *TilLabel;
@property (retain, nonatomic) IBOutlet ZZAutoSizeImageView *IconImage;
@property (retain, nonatomic) IBOutlet UILabel *ContentLabel;
@property (retain, nonatomic) IBOutlet UIWebView *ContentWeb;

@end
