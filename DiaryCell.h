//
//  DiaryCell.h
//  DreamBaby
//
//  Created by easaa on 14-1-6.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

typedef enum
{
    DiaryCellStyleDefault,//文字
    DiaryCellStyle1,//图片
    DiaryCellStyle2//音乐
}DiaryCellStyle;

@interface DiaryCell : SWTableViewCell
{
    DiaryCellStyle _style;
    
    UIView *bgView;//框背景
    UILabel * dayLabel;//日
    UILabel * monthLabel;//月
    UILabel * diaContentLabel;//内容简要
    
    //图片
    UIImageView * photoImage;
    
    //音乐
    UILabel * musicLabel;
}


@property (nonatomic ,retain) UIView *bgView;
@property (nonatomic, retain) UIButton * sharebtn;
//default

@property (nonatomic, retain) UIImageView * photoImage;

- (id)initWithInfoStyle:(DiaryCellStyle)style  reuseIdentifier:(NSString *)reuseIdentifier;
- (id)initWithInfoStyle:(DiaryCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containingTableView:(UITableView *)containingTableView leftUtilityButtons:(NSArray *)leftUtilityButtons rightUtilityButtons:(NSArray *)rightUtilityButtons height:(CGFloat)height;

@property (retain, nonatomic)NSString * daySTR;
@property (retain, nonatomic)NSString * month;
@property (retain, nonatomic)NSString * diaContent;




@property (retain, nonatomic) NSString * music;

@end
