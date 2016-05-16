//
//  EACareRemindCell.m
//  梦想宝贝
//
//  Created by easaa on 7/11/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import "EACareRemindCell.h"

@implementation EACareRemindCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {

    [_titleLabel release];
    [_bgImageView release];
    [_headPic release];
    [super dealloc];
}
@end
