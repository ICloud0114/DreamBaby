//
//  ZZExpertCenterView.h
//  梦想宝贝
//
//  Created by wangshaosheng on 14-7-12.
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

@interface ZZMotherDetailReport : UIControl
{
    
}
@property (nonatomic, retain) UIView *mainView;
@property (nonatomic, retain) UILabel *userNameLabel;
@property (nonatomic, retain) UILabel *timeLabel;
@property (nonatomic, retain) UILabel *contentLabel;
@property (nonatomic, retain) ZZAutoSizeImageView *iconImageView;
@property (nonatomic, retain) ZZAutoSizeImageView *photoImageView;

@property (nonatomic, retain) UIImageView *lineImageView;

@property (nonatomic, retain) NSDictionary *dataDictionary;

@end
