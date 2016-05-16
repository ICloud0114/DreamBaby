//
//  EADiaryCell.h
//  梦想宝贝
//
//  Created by easaa on 7/10/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EADiaryCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *headerPic;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *timeLabel;

@property (retain, nonatomic) IBOutlet UILabel *weatherLabel;

@end
