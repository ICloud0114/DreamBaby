//
//  EANewsListCell.m
//  梦想宝贝
//
//  Created by easaa on 7/10/14.
//  Copyright (c) 2014 easaa. All rights reserved.
//

#import "EANewsListCell.h"

@implementation EANewsListCell

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
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_headerPic release];
    [_itemLabel release];
    [_contentLabel release];
    [super dealloc];
}
@end
