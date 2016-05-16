//
//  MoreControllerCell.m
//  GoodMom
//
//  Created by easaa on 13-7-25.
//  Copyright (c) 2013年 easaa. All rights reserved.
//

#import "MoreControllerCell.h"

@implementation MoreControllerCell

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
    [_moreArticalLabel release];
//    [_moreStateLabel release];
    [_moreAccessView release];
    [_cellBG release];

    [super dealloc];
}
@end
