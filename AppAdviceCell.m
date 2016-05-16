//
//  AppAdviceCell.m
//  DreamBaby
//
//  Created by easaa on 14-1-7.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "AppAdviceCell.h"

@implementation AppAdviceCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)layoutSubviews
{

//    [self.DownloadBtn setImage:[UIImage imageNamed:@"yingyong_icon_h"] forState:UIControlStateHighlighted ];
//    self.NmaeLabel.textColor = [UIColor colorwithHexString:@"#d470a8"];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_DownloadBtn release];
    [_IconImageView release];
    [_NmaeLabel release];

    [_backgroundIMG release];
    [super dealloc];
}
@end
