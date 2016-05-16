//
//  MyDiaryCell.h
//  DreamBaby
//
//  Created by easaa on 14-2-18.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "SWTableViewCell.h"

@interface MyDiaryCell : SWTableViewCell
{
    UIView  *bgView;
    UILabel *dayLabel;
    UILabel *monthLabel;
    UILabel *contentLabel;
    UILabel *musicLabel;
    UIImageView *musicImageView;
    UIImageView *contentImageView;

}

@property (retain, nonatomic)     UIView  *bgView;

@property (retain, nonatomic)NSString * daySTR;
@property (retain, nonatomic)NSString * month;
@property (retain, nonatomic)NSString * diaContent;
@property (retain, nonatomic)UILabel  * contentLabel;
@property (retain, nonatomic)UILabel *musicLabel;
@property (retain, nonatomic)UIImageView *photoImage;
@property (retain, nonatomic)UIImageView *musicImageView;


@property (retain, nonatomic) NSString * music;

@property (nonatomic ,retain) UIImageView *contentImageView;
@property (nonatomic, retain) UIButton * sharebtn;

@end
