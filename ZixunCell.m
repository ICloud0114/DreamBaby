//
//  ZixunCell.m
//  DreamBaby
//
//  Created by easaa on 14-1-7.
//  Copyright (c) 2014年 easaa. All rights reserved.
//

#import "ZixunCell.h"

@implementation ZixunCell

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
    self.NameLabel.textColor = [UIColor colorwithHexString:@"#FFFFFF"];
    self.NameLabel.font = [UIFont systemFontOfSize:14];
    self.DetailLabel.textColor = [UIColor colorwithHexString:@"#FFFFFF"];
    self.DetailLabel.font = [UIFont systemFontOfSize:10];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_IconImageView release];
    [_NameLabel release];
    [_DetailLabel release];

    [_backgroundIMG release];
    [super dealloc];
}
@end
