//
//  JiaoliuDetailCell.h
//  DreamBaby
//
//  Created by easaa on 14-1-8.
//  Copyright (c) 2014年 easaa. All rights reserved.
//


#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define ZZ_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
boundingRectWithSize:CGSizeMake((maxSize.width) - 5.0, (maxSize.height)) options:(NSStringDrawingUsesLineFragmentOrigin) \
attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;
#else
#define ZZ_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
sizeWithFont:font constrainedToSize:maxSize lineBreakMode:mode] : CGSizeZero;
#endif



#import <UIKit/UIKit.h>
#import "ZZAutoSizeImageView.h"
#import "UIImageView+WebCache.h"
#import "ZZMotherDetailReport.h"

@interface JiaoliuDetailCell : UITableViewCell
{

    UIView *reportView;
}
@property (retain, nonatomic) IBOutlet UIImageView *IconBg;
@property (retain, nonatomic) IBOutlet UIImageView *IconImageView;

@property (retain, nonatomic) ZZAutoSizeImageView *photoImageView;
@property (retain, nonatomic) UIImageView *lineImageView;
@property (retain, nonatomic) IBOutlet UILabel *CityNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *NameLabel;
@property (retain, nonatomic) IBOutlet UILabel *ContentLabel;
@property (retain, nonatomic) IBOutlet UILabel *DataLabel;
@property (retain, nonatomic) IBOutlet UILabel *floorLabel;
@property (retain, nonatomic) IBOutlet UIButton *ReplyBtn;

@property (retain, nonatomic) NSDictionary *dataDictionary;
@property (assign, nonatomic) float self_height;

@property (retain, nonatomic) ZZMotherDetailReport *firstDetailReport;
@property (retain, nonatomic) ZZMotherDetailReport *secondDetailReport;

- (void)nibInit;
- (NSString *)dateFromString:(NSString *)dateString;
@end
